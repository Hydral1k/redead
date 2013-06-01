if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "G3 SG1"
	SWEP.IconLetter = "i"
	SWEP.Slot = 4
	SWEP.Slotpos = 3
	
end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_snip_g3sg1.mdl"
SWEP.WorldModel = "models/weapons/w_snip_g3sg1.mdl"

SWEP.SprintPos = Vector(-2.8398, -3.656, 0.5519)
SWEP.SprintAng = Vector(0.1447, -34.0929, 0)

SWEP.ZoomModes = { 0, 35, 10 }
SWEP.ZoomSpeeds = { 0.25, 0.40, 0.40 }

SWEP.IsSniper = true
SWEP.AmmoType = "Sniper"

SWEP.Primary.Sound			= Sound( "Weapon_G3SG1.Single" )
SWEP.Primary.Recoil			= 5.5
SWEP.Primary.Damage			= 100
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.002
SWEP.Primary.SniperCone		= 0.035
SWEP.Primary.Delay			= 0.380

SWEP.Primary.ClipSize		= 20
SWEP.Primary.Automatic		= true

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then 
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.25 )
		
		return 
		
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:SetClip1( self.Weapon:Clip1() - 1 )
	self.Weapon:ShootEffects()
	
	if self.IsSniper and self.Weapon:GetZoomMode() == 1 then
	
		self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.SniperCone, 1 )
	
	else
	
		self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Weapon:GetZoomMode() )
	
	end
	
	if SERVER then
	
		self.Owner:AddAmmo( self.AmmoType, -1 )
		
	end

end