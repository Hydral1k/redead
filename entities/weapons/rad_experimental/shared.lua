if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	
	SWEP.PrintName = "VX-5 Experimental Weapon"
	SWEP.IconLetter = "m"
	SWEP.Slot = 4
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_experimental", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.ViewModel = "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"

SWEP.SprintPos = Vector (-2.3999, -8.8621, -1.3655)
SWEP.SprintAng = Vector (35.187, -44.8601, -25.4546)

SWEP.IsSniper = false
SWEP.AmmoType = "Prototype"
SWEP.IronsightsFOV = 60

SWEP.Gore = Sound( "npc/roller/mine/rmine_explode_shock1.wav" )

SWEP.Primary.Sound			= Sound( "Weapon_SMG1.Single" )
SWEP.Primary.Sound2			= Sound( "npc/scanner/scanner_electric2.wav" )
SWEP.Primary.Recoil			= 15.5
SWEP.Primary.Damage			= 350
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.015
SWEP.Primary.Delay			= 1.550

SWEP.Primary.ClipSize		= 5
SWEP.Primary.Automatic		= false

function SWEP:ShootEffects()	

	if SERVER then
	
		self.Owner:ViewBounce( self.Primary.Recoil )  
		
	end
	
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	
end

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then 
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return 
		
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:EmitSound( self.Primary.Sound2, 100, math.random(120,130) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Weapon:GetZoomMode() )
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:ShootEffects()
	
	if SERVER then
	
		self.Owner:AddAmmo( self.AmmoType, -1 )
		
	end

end

function SWEP:ShootBullets( damage, numbullets, aimcone, zoommode )

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
	bullet.TracerName = "AirboatGunHeavyTracer"
	
	bullet.Callback = function ( attacker, tr, dmginfo )

		if ValidEntity( tr.Entity ) and SERVER then
		
			if tr.Entity:IsPlayer() and tr.Entity:Team() == TEAM_ZOMBIES then
			
				tr.Entity:SetModel( table.Random( GAMEMODE.Corpses ) )
				
			end
		
			local dmg = DamageInfo()
			dmg:SetDamage( 500 )
			dmg:SetDamageType( DMG_BLAST )
			dmg:SetAttacker( self.Owner )
			dmg:SetInflictor( self.Weapon )
			
			tr.Entity:EmitSound( self.Gore, 100, math.random(90,110) )
			tr.Entity:TakeDamageInfo( dmg )
		
		end
		
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		ed:SetNormal( tr.HitNormal )
		util.Effect( "energy_explosion", ed, true, true )

	end
	
	self.Owner:FireBullets( bullet )
	
end
