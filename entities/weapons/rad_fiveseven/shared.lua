if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "FN Five-Seven"
	SWEP.IconLetter = "y"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_fiveseven", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "pistol"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"

SWEP.SprintPos = Vector (1.3846, -0.6033, -7.1994)
SWEP.SprintAng = Vector (33.9412, 15.0662, 6.288)

SWEP.IronPos = Vector (4.5124, 0.2037, 3.1993)
SWEP.IronAng = Vector (0.2231, -0.1231, -0.2525)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_fiveseven.Single" )
SWEP.Primary.Recoil			= 4.5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 0.130

SWEP.Primary.ClipSize		= 10
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType = SHELL_9MM
