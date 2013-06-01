if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "P228 Compact"
	SWEP.IconLetter = "y"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
end

SWEP.HoldType = "pistol"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.SprintPos = Vector(-0.8052, 0, 3.0657)
SWEP.SprintAng = Vector(-16.9413, -5.786, 4.0159)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_P228.Single" )
SWEP.Primary.Recoil			= 5.5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 0.150

SWEP.Primary.ClipSize		= 12
SWEP.Primary.Automatic		= false
