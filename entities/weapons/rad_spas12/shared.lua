if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 55
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "SPAS-12"
	SWEP.IconLetter = "k"
	SWEP.Slot = 3
	SWEP.Slotpos = 3
	
end

SWEP.HoldType = "shotgun"

SWEP.Base = "rad_base"

SWEP.UseHands = true
SWEP.UseShellSounds = false

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

//SWEP.SprintPos = Vector(-0.6026, -2.715, 0.0137)
//SWEP.SprintAng = Vector(-3.4815, -21.9362, 0.0001)
SWEP.SprintPos = Vector (1.4752, 0.0296, -3.577)
SWEP.SprintAng = Vector (5.8948, 20.2814, 0)

SWEP.IsSniper = false
SWEP.AmmoType = "Buckshot"

SWEP.Primary.Sound			= Sound( "Weapon_Shotgun.Double" )
SWEP.Primary.Pump           = Sound( "Weapon_Shotgun.Special1" )
SWEP.Primary.ReloadSound    = Sound( "Weapon_Shotgun.Reload" )
SWEP.Primary.Recoil			= 9.5
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 8
SWEP.Primary.Cone			= 0.080
SWEP.Primary.Delay			= 0.500

SWEP.Primary.ClipSize		= 8
SWEP.Primary.Automatic		= false

function SWEP:Deploy()

	self.Weapon:SetNWBool( "Reloading", false )
	self.Weapon:SetVar( "PumpTime", 0 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )

	if SERVER then
	
		self.Weapon:SetZoomMode( 1 )
		
	end

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end 

function SWEP:CanPrimaryAttack()

	if self.HolsterMode or self.LastRunFrame > CurTime() then return false end
	
	if self.Owner:GetNWInt( "Ammo"..self.AmmoType, 0 ) < 1 then 
	
		self.Weapon:EmitSound( self.Primary.Empty )
		return false 
		
	end
	
	if self.Weapon:GetNWBool( "Reloading", false ) then
	
		self.Weapon:SetNWBool( "Reloading", false )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
		
		return false
	
	end

	if self.Weapon:Clip1() <= 0 and not self.Weapon:GetNWBool( "Reloading", false ) then
		
		self.Weapon:SetNWBool( "Reloading", true )
		self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		//self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
		
		return false
		
	end
	
	return true
	
end

function SWEP:ShootEffects()	

	if IsFirstTimePredicted() then
	
		self.Owner:ViewPunch( Angle( math.Rand( -0.2, -0.1 ) * self.Primary.Recoil, math.Rand( -0.05, 0.05 ) * self.Primary.Recoil, 0 ) )
		
	end
	
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	
	if self.UseShellSounds then
	
		local pitch = self.Pitches[ self.AmmoType ] + math.random( -3, 3 )
		local tbl = self.BuckshotShellSounds
		local pos = self.Owner:GetPos()
	
		timer.Simple( math.Rand( self.MinShellDelay, self.MaxShellDelay ), function() sound.Play( table.Random( tbl ), pos, 50, pitch ) end )
		
	end
	
end

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then 
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return 
		
	end
	
	self.Weapon:SetVar( "PumpTime", CurTime() + 0.5 )

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Weapon:GetZoomMode() )
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:ShootEffects()
	
	if SERVER then
	
		self.Owner:AddAmmo( self.AmmoType, -1 )
		
	end

end

function SWEP:Reload()

	if self.Weapon:Clip1() == self.Primary.ClipSize or self.Weapon:Clip1() > self.Owner:GetNWInt( "Ammo" .. self.AmmoType, 0 ) or self.HolsterMode or self.ReloadTime then return end
	
	if self.Weapon:Clip1() < self.Primary.ClipSize then
		
		self.Weapon:SetNWBool( "Reloading", true )
		self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		
		//self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
		
	end
	
end

function SWEP:PumpIt()

	self.Weapon:SetNWBool( "Reloading", false )
	self.Weapon:SendWeaponAnim( ACT_SHOTGUN_PUMP )
	self.Weapon:EmitSound( self.Primary.Pump )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end

function SWEP:Think()

	if self.Owner:KeyDown( IN_WALK ) and self.HolsterTime < CurTime() then
	
		self.HolsterTime = CurTime() + 2
		self.HolsterMode = !self.HolsterMode
		
		--[[if self.HolsterMode then
		
			self.Owner:SetLuaAnimation( self.HoldType )
			
		else
		
			self.Owner:StopAllLuaAnimations( 0.5 )
		
		end]]
	
	end

	if self.Weapon:GetVar( "PumpTime", 0 ) != 0 and self.Weapon:GetVar( "PumpTime", 0 ) < CurTime() then
	
		self.Weapon:SetVar( "PumpTime", 0 )
		self.Weapon:PumpIt()
		
	end

	if self.Weapon:GetNWBool( "Reloading", false ) then
	
		if self.Weapon:GetVar( "ReloadTimer", 0 ) < CurTime() then
			
			// Finsished reload
			if self.Weapon:Clip1() >= self.Primary.ClipSize then
			
				self.Weapon:SetNWBool( "Reloading", false )
				self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
				
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
				
				return
				
			end
			
			// Next cycle
			self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.75 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			
			// Add ammo
			self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
			
			// Sound
			self.Weapon:EmitSound( self.Primary.ReloadSound, 100, math.random(90,110) )
			
		end
		
	end

	if self.Owner:GetVelocity():Length() > 0 then
	
		if self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetNWFloat( "Weight", 0 ) < 50 then
		
			self.LastRunFrame = CurTime() + 0.3
		
		end
		
	end

end

function SWEP:ShootBullets( damage, numbullets, aimcone, zoommode )

	if SERVER then
	
		self.Owner:AddStat( "Bullets", 1 )
	
	end

	local scale = aimcone
	
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
	
		scale = aimcone * 1.75
		
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
	
		scale = math.Clamp( aimcone / 1.25, 0, 10 )
		
	end
	
	local tracer = 1
	
	if ( zoommode or 1 ) > 1 then
	
		tracer = 0
	
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 0
	bullet.Force	= damage * 2						
	bullet.Damage	= damage 
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= tracername
	bullet.Callback = function ( attacker, tr, dmginfo )
	
		dmginfo:ScaleDamage( self:GetDamageFalloffScale( tr.HitPos:Distance( self.Owner:GetShootPos() ) ) )
		
		if tr.Entity.NextBot then
			
			tr.Entity:OnLimbHit( tr.HitGroup, dmginfo )
			
		end
		
		if math.random(1,6) == 1 then
		
			self.Weapon:BulletPenetration( attacker, tr, dmginfo, 0 )
			
		end

	end
	
	self.Owner:FireBullets( bullet )
	
end

function SWEP:DrawHUD()

	if self.Weapon:ShouldNotDraw() then return end

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	local scalebywidth = ( ScrW() / 1024 ) * 10
	local scale = self.Primary.Cone
		
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		
		scale = self.Primary.Cone * 1.75
			
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
		
		scale = math.Clamp( self.Primary.Cone / 1.25, 0, 10 )
			
	end
		
	scale = scale * scalebywidth
		
	local dist = math.abs( self.CrosshairScale - scale )
	self.CrosshairScale = math.Approach( self.CrosshairScale, scale, FrameTime() * 2 + dist * 0.05 )
		
	local gap = 40 * self.CrosshairScale
	local length = gap + self.CrossLength:GetInt()
		
	surface.SetDrawColor( self.CrossRed:GetInt(), self.CrossGreen:GetInt(), self.CrossBlue:GetInt(), self.CrossAlpha:GetInt() )
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
	
end
