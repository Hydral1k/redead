if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "FAMAS"
	SWEP.IconLetter = "v"
	SWEP.Slot = 4
	SWEP.Slotpos = 2

end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.ViewModel = "models/weapons/v_rif_famas.mdl"
SWEP.WorldModel = "models/weapons/w_rif_famas.mdl"

SWEP.SprintPos = Vector(4.9288, -2.4157, 2.2032)
SWEP.SprintAng = Vector(0.8736, 40.1165, 28.0526)

SWEP.IsSniper = false
SWEP.AmmoType = "Rifle"

SWEP.Primary.Sound			= Sound( "Weapon_famas.Single" )
SWEP.Primary.Recoil			= 7.5
SWEP.Primary.Damage			= 45
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 0.100

SWEP.Primary.ClipSize		= 25
SWEP.Primary.Automatic		= true
