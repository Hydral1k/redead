if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "M249 SAW"
	SWEP.IconLetter = "z"
	SWEP.Slot = 4
	SWEP.Slotpos = 2
	
end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.ViewModel = "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"

SWEP.SprintPos = Vector (4.0541, -2.0077, -5.4061)
SWEP.SprintAng = Vector (11.4322, 40.43, -7.9447)

SWEP.IsSniper = false
SWEP.AmmoType = "Rifle"

SWEP.Primary.Sound			= Sound( "Weapon_M249.Single" )
SWEP.Primary.Recoil			= 9.5
SWEP.Primary.Damage			= 75
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.040
SWEP.Primary.Delay			= 0.090

SWEP.Primary.ClipSize		= 100
SWEP.Primary.Automatic		= true

