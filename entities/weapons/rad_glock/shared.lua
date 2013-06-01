if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Glock 19"
	SWEP.IconLetter = "c"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
end

SWEP.HoldType = "pistol"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.SprintPos = Vector (0.6553, 0.446, 3.2583)
SWEP.SprintAng = Vector (-15.5938, -2.8864, -1.5457)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_Glock.Single" )
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.040
SWEP.Primary.Delay			= 0.100

SWEP.Primary.ClipSize		= 15
SWEP.Primary.Automatic		= false
