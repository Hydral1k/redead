if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "TMP"
	SWEP.IconLetter = "x"
	SWEP.Slot = 3
	SWEP.Slotpos = 2
	
end

SWEP.HoldType = "rpg"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel = "models/weapons/w_smg_tmp.mdl"

SWEP.SprintPos = Vector (2.0027, -0.751, 0.1411)
SWEP.SprintAng = Vector (-1.2669, -27.7284, 10.4434)

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"

SWEP.Primary.Sound			= Sound( "Weapon_USP.SilencedShot" )
SWEP.Primary.Recoil			= 4.5
SWEP.Primary.Damage			= 35
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 0.075

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true
