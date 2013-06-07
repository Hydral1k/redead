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
	
	killicon.AddFont( "rad_z_contagion", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.Base = "rad_z_base"

SWEP.ViewModel = "models/Zed/weapons/v_ghoul.mdl"

SWEP.Taunt = {"npc/zombie/zombie_voice_idle1.wav",
"npc/zombie/zombie_voice_idle2.wav",
"npc/zombie/zombie_voice_idle3.wav",
"npc/zombie/zombie_voice_idle4.wav",
"npc/zombie/zombie_voice_idle5.wav",
"npc/zombie/zombie_voice_idle7.wav",
"npc/zombie/zombie_voice_idle8.wav",
"npc/zombie/zombie_voice_idle9.wav",
"npc/zombie/zombie_voice_idle10.wav",
"npc/zombie/zombie_voice_idle12.wav",
"npc/zombie/zombie_voice_idle13.wav",
"npc/zombie/zombie_voice_idle14.wav" }

SWEP.Die = { "npc/zombie/zombie_die1.wav",
"npc/zombie/zombie_die2.wav",
"npc/zombie/zombie_die3.wav",
"npc/zombie/zombie_voice_idle6.wav",
"npc/zombie/zombie_voice_idle11.wav" }

SWEP.Primary.Sound			= Sound( "npc/zombie/zombie_pain1.wav" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 45
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 1.800

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= true

function SWEP:NoobHelp()

	self.Owner:NoticeOnce( "You will unleash a toxic shower when you die", GAMEMODE.Colors.Blue, 5, 10 )

end

function SWEP:OnHitHuman( ent, dmg )

	ent:ViewBounce( 20 )
	
	self.Owner:AddZedDamage( dmg )
	self.Owner:DrawBlood( 5 )

end
