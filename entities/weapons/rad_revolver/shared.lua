if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip = false
	
	SWEP.PrintName = "Colt Python"
	SWEP.IconLetter = "f"
	SWEP.Slot = 2
	SWEP.Slotpos = 1
	
	killicon.AddFont( "rad_revolver", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "revolver"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.IronPos = Vector (-5.7334, -0.3277, 2.3208)
SWEP.IronAng = Vector (0.5504, -0.1977, 1.2946)

SWEP.SprintPos = Vector (2.4955, 2.1219, 2.9007)
SWEP.SprintAng = Vector (-10.2034, 15.2433, 0)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_357.Single" )
SWEP.Primary.Recoil			= 13.5
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.030
SWEP.Primary.Delay			= 0.900

SWEP.Primary.ClipSize		= 6
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType = SHELL_57
