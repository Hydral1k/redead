if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip = true
	
	SWEP.PrintName = "FN P90"
	SWEP.IconLetter = "l"
	SWEP.Slot = 3
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_p90", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "smg"

SWEP.Base = "rad_base"

SWEP.ViewModel			= "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"

SWEP.SprintPos = Vector(-4.7699, -7.2246, -2.8428)
SWEP.SprintAng = Vector(4.4604, -47.001, 6.8488)

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"
SWEP.Laser = true
SWEP.LaserOffset = Vector(0,0,2.1)
//SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_p90.Single" )
SWEP.Primary.Recoil			= 7.5
SWEP.Primary.Damage			= 22
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.050
SWEP.Primary.Delay			= 0.075

SWEP.Primary.ClipSize		= 50
SWEP.Primary.Automatic		= true

SWEP.Primary.ShellType = SHELL_9MM
