if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "MAC 10"
	SWEP.IconLetter = "l"
	SWEP.Slot = 3
	SWEP.Slotpos = 2
	
end

SWEP.HoldType = "pistol"

SWEP.Base = "rad_base"

SWEP.ViewModel			= "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mac10.mdl"

SWEP.SprintPos = Vector(-4.7699, -7.2246, -2.8428)
SWEP.SprintAng = Vector(4.4604, -47.001, 6.8488)

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"

SWEP.Primary.Sound			= Sound( "Weapon_mac10.Single" )
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.045
SWEP.Primary.Delay			= 0.080

SWEP.Primary.ClipSize		= 40
SWEP.Primary.Automatic		= true
