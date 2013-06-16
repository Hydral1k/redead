if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "AWP"
	SWEP.IconLetter = "r"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"

SWEP.SprintPos = Vector(-2.4134, -2.7816, 0.4499)
SWEP.SprintAng = Vector(-4.2748, -48.8937, -0.0962)

SWEP.ZoomModes = { 0, 35, 5 }
SWEP.ZoomSpeeds = { 0.25, 0.30, 0.30 }

SWEP.IsSniper = true
SWEP.AmmoType = "Sniper"

SWEP.Primary.Sound			= Sound( "Weapon_AWP.Single" )
SWEP.Primary.Recoil			= 17.5
SWEP.Primary.Damage			= 175
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.001
SWEP.Primary.SniperCone     = 0.015
SWEP.Primary.Delay			= 1.500

SWEP.Primary.ClipSize		= 10
SWEP.Primary.Automatic		= false

SWEP.MinShellDelay = 0.8
SWEP.MaxShellDelay = 1.0
