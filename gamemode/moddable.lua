
// Team numbers

TEAM_ARMY = 1
TEAM_ZOMBIES = 2

// Currency name

GM.CurrencyName = "Bone"

// Shop name and description - obsolete?

GM.ShopName = "UNCLE VIKTOR'S RUSSKI WEAPON SHOPPE"
GM.ShopDesc = "A HAPPY CUSTOMER IS A DEAD ONE!"

// Team names

GM.ArmyTeamName = "S.I.N Unit"
GM.ZombieTeamName = "The Undead"

// Amount of damage that the zombie lord needs to deal before he is redeemed

GM.RedemptionDamage = 450

// Class names, descriptions, logos

GM.ClassNames = {}
GM.ClassNames[CLASS_SCOUT] = "Scout"
GM.ClassNames[CLASS_COMMANDO] = "Commando"
GM.ClassNames[CLASS_SPECIALIST] = "Specialist"

GM.ClassDescriptions = {}
GM.ClassDescriptions[CLASS_SCOUT] = "The Scout: Wears lightweight kevlar armor, allowing for improved mobility. Starts off with extra " .. GM.CurrencyName .. "s."
GM.ClassDescriptions[CLASS_COMMANDO] = "The Commando: Wears prototype kevlar armor, allowing for improved melee damage resistance."
GM.ClassDescriptions[CLASS_SPECIALIST] = "The Specialist: Has access to restricted tools and weapons due to a higher level of field experience."

GM.ClassLogos = {}
GM.ClassLogos[CLASS_SCOUT] = "toxsin/scout"
GM.ClassLogos[CLASS_COMMANDO] = "toxsin/commando"
GM.ClassLogos[CLASS_SPECIALIST] = "toxsin/specialist"

GM.ZombieNames = {}
GM.ZombieNames[CLASS_RUNNER] = "Runner"
GM.ZombieNames[CLASS_BANSHEE] = "Banshee"
GM.ZombieNames[CLASS_CONTAGION] = "Contagion"

GM.ZombieDescriptions = {}
GM.ZombieDescriptions[CLASS_RUNNER] = "The Runner: An agile reanimated corpse. Capable of infecting humans with its claws."
GM.ZombieDescriptions[CLASS_BANSHEE] = "The Banshee: A highly radioactive zombie. Capable of disorienting humans with its scream."
GM.ZombieDescriptions[CLASS_CONTAGION] = "The Contagion: A bloated, festering zombie. When killed it will burst into a shower of acid."

GM.ZombieLogos = {}
GM.ZombieLogos[CLASS_RUNNER] = "toxsin/zomb_corpse"
GM.ZombieLogos[CLASS_BANSHEE] = "toxsin/zomb_banshee"
GM.ZombieLogos[CLASS_CONTAGION] = "toxsin/zomb_zombie"
	
// Weight Limits (lbs)

GM.OptimalWeight = 20 // If your weight is less than this then you gain stamina faster.
GM.MaxWeight = 35     // If your weight is higher than this then you run slower. 
GM.WeightCap = 50     // If your weight is higher than this then you run at a snail's pace.

// The individual waves and the list of zombies that will spawn. ( more waves means a longer match )

GM.Waves = {}
GM.Waves[1] = { "npc_zombie_common" }
GM.Waves[2] = { "npc_zombie_common", "npc_zombie_normal" }
GM.Waves[3] = { "npc_zombie_common", "npc_zombie_normal", "npc_zombie_fast" }
GM.Waves[4] = { "npc_zombie_common", "npc_zombie_normal", "npc_zombie_fast", "npc_zombie_poison" }

// Colors used by notices

GM.Colors = {}
GM.Colors.Green = Color(70,250,170,255)
GM.Colors.Red = Color(250,120,100,255)
GM.Colors.Blue = Color(70,170,250,255)
GM.Colors.Yellow = Color(250,220,70,255)
GM.Colors.White = Color(250,250,250,255)

// Music to play when a player spawns ( randomly picked in table )

GM.OpeningMusic = { "music/HL1_song5.mp3",
"music/HL1_song6.mp3",
"music/HL1_song9.mp3",
"music/HL1_song19.mp3",
"music/HL1_song20.mp3",
"music/HL1_song21.mp3",
"music/HL1_song24.mp3",
"music/HL1_song26.mp3",
"music/HL2_intro.mp3",
"music/HL2_song0.mp3",
"music/HL2_song1.mp3",
"music/HL2_song2.mp3",
"music/HL2_song3.mp3",
"music/HL2_song4.mp3",
"music/HL2_song8.mp3",
"music/HL2_song12_long.mp3",
"music/HL2_song13.mp3",
"music/HL2_song14.mp3",
"music/HL2_song15.mp3",
"music/HL2_song16.mp3",
"music/HL2_song17.mp3",
"music/HL2_song19.mp3",
"music/HL2_song26.mp3",
"music/HL2_song20_submix0.mp3",
"music/HL2_song20_submix4.mp3",
"music/HL2_song26_trainstation1.mp3",
"music/HL2_song27_trainstation2.mp3",
"music/HL2_song30.mp3",
"music/stingers/industrial_suspense1.wav" }

// Music to play on death

GM.DeathMusic = { "music/Ravenholm_1.mp3",
"music/HL2_song28.mp3",
"music/stingers/HL1_stinger_song16.mp3",
"music/stingers/HL1_stinger_song7.mp3",
"music/stingers/HL1_stinger_song8.mp3",
"music/stingers/HL1_stinger_song27.mp3",
"music/stingers/HL1_stinger_song28.mp3",
"music/stingers/industrial_suspense2.wav" }

// Win and lose tunes

GM.WinMusic = { "music/HL2_song6.mp3",
"music/HL1_song17.mp3",
"music/HL2_song29.mp3",
"music/HL2_song31.mp3" }

GM.LoseMusic = { "music/HL1_song14.mp3",
"music/HL2_song7.mp3",
"music/HL2_song32.mp3",
"music/HL2_song33.mp3" }

// Last minute

GM.LastMinute = Sound( "toxsin/lastminute.mp3" )

if CLIENT then return end // Serverside configuration stuff past this point.

// Headshot combo values

GM.HeadshotCombos = {}
GM.HeadshotCombos[5] = 1    // Get 1 point for 5 consecutive headshots
GM.HeadshotCombos[10] = 2   // Get 2 points for 10 consecutive headshots
GM.HeadshotCombos[15] = 3
GM.HeadshotCombos[20] = 5
GM.HeadshotCombos[50] = 10
 
// Player class models + weapons

GM.ClassModels = {}
GM.ClassModels[CLASS_SCOUT] = "models/player/riot.mdl"
GM.ClassModels[CLASS_COMMANDO] = "models/player/swat.mdl"
GM.ClassModels[CLASS_SPECIALIST] = "models/player/gasmask.mdl"

GM.ClassWeapons = {}
GM.ClassWeapons[CLASS_SCOUT] = "models/weapons/w_pist_glock18.mdl" // use world model names since we have to use the old inventory system
GM.ClassWeapons[CLASS_COMMANDO] = "models/weapons/w_pistol.mdl"
GM.ClassWeapons[CLASS_SPECIALIST] = "models/weapons/w_pist_p228.mdl"

GM.WalkSpeed = 175 // speed for humans
GM.RunSpeed = 250

GM.ZombieModels = {}
GM.ZombieModels[CLASS_RUNNER] = "models/player/corpse1.mdl"
GM.ZombieModels[CLASS_BANSHEE] = "models/player/charple01.mdl"
GM.ZombieModels[CLASS_CONTAGION] = "models/player/classic.mdl"

GM.ZombieWeapons = {}
GM.ZombieWeapons[CLASS_RUNNER] = "rad_z_runner"
GM.ZombieWeapons[CLASS_BANSHEE] = "rad_z_banshee"
GM.ZombieWeapons[CLASS_CONTAGION] = "rad_z_contagion"

GM.ZombieHealth = {}
GM.ZombieHealth[CLASS_RUNNER] = 150
GM.ZombieHealth[CLASS_BANSHEE] = 175
GM.ZombieHealth[CLASS_CONTAGION] = 250

GM.ZombieSpeed = {}
GM.ZombieSpeed[CLASS_RUNNER] = 250
GM.ZombieSpeed[CLASS_BANSHEE] = 200
GM.ZombieSpeed[CLASS_CONTAGION] = 225

// Chances to spawn each zombie type ( from 100 to 0 %)

GM.SpawnChance = {}
GM.SpawnChance[ "npc_zombie_common" ] = 1.0 // 100% chance
GM.SpawnChance[ "npc_zombie_normal" ] = 0.2 // 20% chance
GM.SpawnChance[ "npc_zombie_fast" ] = 0.4
GM.SpawnChance[ "npc_zombie_poison" ] = 0.3

GM.WaitTime = 45           // How much time (in seconds) do players have before the first wave spawns?
GM.RadiationAmount = 0.6   // How much of the radiation on the map should be disabled on map startup? ( 0.6 means 60% will be disabled ) - OBSOLETE?
GM.MaxLoot = 0.3           // Maximum amount of loot to be generated ( 0.05 means 5% of the info_lootspawns will have loot at them. )

