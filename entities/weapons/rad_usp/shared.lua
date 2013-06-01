if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "USP Compact"
	SWEP.IconLetter = "a"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
end

SWEP.HoldType = "pistol"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.SprintPos = Vector (0.4776, 0.446, 3.1631)
SWEP.SprintAng = Vector (-15.3501, -1.3761, -1.5457)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_USP.Single" )
SWEP.Primary.Recoil			= 5.5
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.040
SWEP.Primary.Delay			= 0.150

SWEP.Primary.ClipSize		= 12
SWEP.Primary.Automatic		= false
