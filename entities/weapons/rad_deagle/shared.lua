if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Desert Eagle"
	SWEP.IconLetter = "f"
	SWEP.Slot = 2
	SWEP.Slotpos = 1
	
end

SWEP.HoldType = "revolver"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"

SWEP.SprintPos = Vector (-4.2232, -5.1203, -2.0386)
SWEP.SprintAng = Vector (12.7496, -52.6848, -7.5206)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )
SWEP.Primary.Recoil			= 11.5
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.030
SWEP.Primary.Delay			= 0.380

SWEP.Primary.ClipSize		= 7
SWEP.Primary.Automatic		= false