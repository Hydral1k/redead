if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "IMI Galil"
	SWEP.IconLetter = "v"
	SWEP.Slot = 4
	SWEP.Slotpos = 2

end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.ViewModel = "models/weapons/v_rif_galil.mdl"
SWEP.WorldModel = "models/weapons/w_rif_galil.mdl"

SWEP.SprintPos = Vector (5.6501, -4.3222, 2.1819)
SWEP.SprintAng = Vector (-10.5144, 47.7303, 2.2908)

SWEP.IsSniper = false
SWEP.AmmoType = "Rifle"

SWEP.Primary.Sound			= Sound( "Weapon_Galil.Single" )
SWEP.Primary.Recoil			= 7.5
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.040
SWEP.Primary.Delay			= 0.110

SWEP.Primary.ClipSize		= 40
SWEP.Primary.Automatic		= true
