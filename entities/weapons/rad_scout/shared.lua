if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Steyr Scout"
	SWEP.IconLetter = "n"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"

SWEP.SprintPos = Vector(-1.7763, -1.9796, 1.677)
SWEP.SprintAng = Vector(-11.9431, -36.4352, 0)

SWEP.ZoomModes = { 0, 40, 10 }
SWEP.ZoomSpeeds = { 0.25, 0.40, 0.40 }

SWEP.IsSniper = true
SWEP.AmmoType = "Sniper"

SWEP.Primary.Sound			= Sound( "Weapon_Scout.Single" )
SWEP.Primary.Recoil			= 15.5
SWEP.Primary.Damage			= 110
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.001
SWEP.Primary.SniperCone		= 0.035
SWEP.Primary.Delay			= 1.400

SWEP.Primary.ClipSize		= 10
SWEP.Primary.Automatic		= false

SWEP.MinShellDelay = 0.8
SWEP.MaxShellDelay = 1.0
