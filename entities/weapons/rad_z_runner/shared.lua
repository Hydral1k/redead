if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Claws"
	SWEP.IconLetter = "C"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	killicon.AddFont( "rad_z_runner", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "slam"

SWEP.Base = "rad_z_base"

SWEP.Taunt = { "npc/zombie/zombie_alert1.wav",
"npc/zombie/zombie_alert2.wav",
"npc/zombie/zombie_alert3.wav" }

SWEP.Die = { "vo/npc/vortigaunt/vortigese02.wav",
"vo/npc/vortigaunt/vortigese03.wav",
"vo/npc/vortigaunt/vortigese05.wav",
"vo/npc/vortigaunt/vortigese07.wav" }

SWEP.Primary.Hit            = Sound( "npc/zombie/claw_strike1.wav" )
SWEP.Primary.HitFlesh		= Sound( "npc/zombie/claw_strike2.wav" )
SWEP.Primary.Sound			= Sound( "npc/fast_zombie/idle1.wav" )
SWEP.Primary.Miss           = Sound( "npc/zombie/claw_miss1.wav" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 35
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 1.500

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= true
