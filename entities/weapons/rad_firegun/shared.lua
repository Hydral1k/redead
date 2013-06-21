if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then
	
	SWEP.ViewModelFlip = false
	
	SWEP.ViewModelFOV = 60
	
	SWEP.PrintName = "HEAT Cannon"
	SWEP.IconLetter = "m"
	SWEP.Slot = 4
	SWEP.Slotpos = 2
	
end

SWEP.HoldType = "physgun"

SWEP.Base = "rad_base"

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"

//SWEP.SprintPos = Vector (4.9288, -2.4157, 2.2032)
//SWEP.SprintAng = Vector (0.8736, 40.1165, 28.0526)

SWEP.SprintPos = Vector(5.36, -0.401, 2.88)
SWEP.SprintAng = Vector(-3.201, 26.799, 5.4)

SWEP.IsSniper = false
SWEP.AmmoType = "Prototype"
SWEP.LaserOffset = Angle( -90, -0.9, 0 )
SWEP.LaserScale = 0.25
//SWEP.IronsightsFOV = 60

SWEP.Burn = Sound( "ambient/fire/ignite.wav" )
SWEP.Burn2 = Sound( "Weapon_Mortar.Impact" )

SWEP.Primary.Sound			= Sound( "Weapon_mortar.single" )
SWEP.Primary.Sound2			= Sound( "weapons/physcannon/physcannon_charge.wav" )
SWEP.Primary.Recoil			= 15.5
SWEP.Primary.Damage			= 80
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.015
SWEP.Primary.Delay			= 1.700

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= true

function SWEP:ShootEffects()	

	if IsFirstTimePredicted() then
	
		self.Owner:ViewPunch( Angle( math.Rand( -0.2, -0.1 ) * self.Primary.Recoil, math.Rand( -0.05, 0.05 ) * self.Primary.Recoil, 0 ) )
		
	end
	
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK ) 
	
end

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then 
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return 
		
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(90,100) )
	//self.Weapon:EmitSound( self.Primary.Sound3, 100, 80 )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Weapon:GetZoomMode() )
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:ShootEffects()
	
	if SERVER then
	
		self.Owner:AddAmmo( self.AmmoType, -1 )
		self.Owner:EmitSound( self.Primary.Sound2 )
		
	end
	
	self.ReloadTime = CurTime() + self.Primary.Delay

end

function SWEP:ReloadThink()

	if self.ReloadTime and self.ReloadTime <= CurTime() then
	
		self.ReloadTime = nil
		self.Weapon:SetClip1( self.Primary.ClipSize )
	
	end

end

function SWEP:Reload()
	
end

SWEP.Decals = { "Scorch", "SmallScorch" }

function SWEP:ShootBullets( damage, numbullets, aimcone, zoommode )

	if SERVER then
	
		self.Owner:AddStat( "Bullets", numbullets )
	
	end

	local scale = aimcone
	
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
	
		scale = aimcone * 1.75
		
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
	
		scale = math.Clamp( aimcone / 1.75, 0, 10 )
		
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1
	bullet.Force	= damage * 2						
	bullet.Damage	= 1
	bullet.AmmoType = "Pistol"
	bullet.TracerName = "fire_tracer"
	
	bullet.Callback = function ( attacker, tr, dmginfo )

		if IsValid( tr.Entity ) and IsValid( self ) and IsValid( self.Owner ) and SERVER then
		
			if tr.Entity:IsPlayer() then
			
				tr.Entity:TakeDamage( self.Primary.Damage, self.Owner )
			
			else
			
				tr.Entity:TakeDamage( math.Clamp( math.min( 20, tr.Entity:Health() - 5 ), 1, 20 ), self.Owner )
			
			end
			
			if tr.Entity.NextBot or ( tr.Entity:IsPlayer() and tr.Entity:Team() != TEAM_ARMY ) then
			
				tr.Entity:DoIgnite( self.Owner )
				tr.Entity:EmitSound( self.Burn, 100, math.random(90,110) )
				
			end
		
		end
		
		sound.Play( self.Burn2, tr.HitPos )
		
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		ed:SetNormal( tr.HitNormal )
		util.Effect( "fire_explosion", ed, true, true )
		
		if tr.HitNormal.z > 0.5 and tr.HitWorld then
		
			local ed = EffectData()
			ed:SetOrigin( tr.HitPos )
			ed:SetMagnitude( 0.5 )
			util.Effect( "smoke_crater", ed, true, true )
		
		end
		
		util.Decal( table.Random( self.Decals ), tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )

	end
	
	self.Owner:FireBullets( bullet )
	
end
