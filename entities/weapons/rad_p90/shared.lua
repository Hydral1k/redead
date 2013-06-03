if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip = true
	
	SWEP.PrintName = "FN P90"
	SWEP.IconLetter = "l"
	SWEP.Slot = 3
	SWEP.Slotpos = 2
	
end

SWEP.HoldType = "rpg"

SWEP.Base = "rad_base"

SWEP.ViewModel			= "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"

SWEP.SprintPos = Vector(-4.7699, -7.2246, -2.8428)
SWEP.SprintAng = Vector(4.4604, -47.001, 6.8488)

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"

SWEP.LaserOffset = Angle( 39.9, -50, -90 )
SWEP.LaserScale = 0.75

SWEP.Primary.Sound			= Sound( "Weapon_p90.Single" )
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.040
SWEP.Primary.Delay			= 0.075

SWEP.Primary.ClipSize		= 50
SWEP.Primary.Automatic		= true
