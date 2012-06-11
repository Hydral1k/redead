
// This is the ID given to any item that doesnt fit in any other category - feel free to add your own items here
ITEM_MISC = 5 // Can be found in stores or in loot
ITEM_BUYABLE = 6 // Only found in stores
ITEM_LOOT = 7 // Only found in loot
ITEM_QUEST_ZOMBIE = 421 

PRICE_QUEST_ZOMBIE_ITEM = 20

function FUNC_BOOZE( ply, id, client )

	if client then return "Drink" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddRadiation( -2 )
	ply:AddStamina( 20 )
	ply:Notice( "+20 Stamina", GAMEMODE.Colors.Green )
	ply:Notice( "-2 Radiation", GAMEMODE.Colors.Green )
	
	umsg.Start( "Drunk", ply )
    umsg.Short( 2 )
	umsg.End()

end

function FUNC_MOONSHINE( ply, id, client )

	if client then return "Drink" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddRadiation( -1 )
	ply:Notice( "-1 Radiation", GAMEMODE.Colors.Green )
	
	umsg.Start( "Drunk", ply )
    umsg.Short( 3 )
	umsg.End()

end

item.Register( { 
	Name = "Wood", 
	Description = "This piece of wood can be used to build a sturdy barricade.",
	Stackable = true, 
	Type = ITEM_MISC,
	Weight = 1.50, 
	Price = 15,
	Rarity = 0.10,
	Model = "models/props_debris/wood_chunk04a.mdl",
	Functions = {},
	CamPos = Vector(42,15,0),
	CamOrigin = Vector(0,0,1)
} )

item.Register( { 
	Name = "Vodka", 
	Description = "This glass bottle is full of vodka. It will provide some relief from radiation poisoning when drunk.",
	Stackable = true, 
	Type = ITEM_MISC,
	Weight = 0.30, 
	Price = 10,
	Rarity = 0.10,
	Model = "models/props_junk/garbage_glassbottle002a.mdl",
	Functions = { FUNC_BOOZE },
	CamPos = Vector(15,20,0),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "Moonshine Vodka", 
	Description = "This old glass bottle is full of homemade vodka. It's less potent than regular vodka but tastes twice as strong.",
	Stackable = true, 
	Type = ITEM_BUYABLE,
	Weight = 0.30, 
	Price = 5,
	Rarity = 0.25,
	Model = "models/props_junk/garbage_glassbottle003a.mdl",
	Functions = { FUNC_MOONSHINE },
	CamPos = Vector(16,18,-3),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Human Skull", 
	Description = "This human skull looks pretty old. You decided to name it Murray.",
	Stackable = true, 
	Type = ITEM_QUEST_ZOMBIE,
	Weight = 2.50, 
	Price = PRICE_QUEST_ZOMBIE_ITEM,
	Rarity = 0.75,
	Model = "models/gibs/hgibs.mdl",
	Functions = { },
	CamPos = Vector(15,10,0),
	CamOrigin = Vector(0,0,2)	
} )

item.Register( { 
	Name = "Zombie Claw", 
	Description = "This is the claw of a zombie.",
	Stackable = true, 
	Type = ITEM_QUEST_ZOMBIE,
	Weight = 2.50, 
	Price = PRICE_QUEST_ZOMBIE_ITEM,
	Rarity = 0.25,
	Model = "models/gibs/antlion_gib_small_1.mdl",
	Functions = { },
	CamPos = Vector(10,15,5),
	CamOrigin = Vector(0,0,1)	
} )

item.Register( { 
	Name = "Zombie Spine", 
	Description = "This is the spine of a zombie.",
	Stackable = true, 
	Type = ITEM_QUEST_ZOMBIE,
	Weight = 2.50, 
	Price = PRICE_QUEST_ZOMBIE_ITEM,
	Rarity = 0.25,
	Model = "models/gibs/HGIBS_spine.mdl",
	Functions = { },
	CamPos = Vector(15,15,5),
	CamOrigin = Vector(0,0,2)	
} )

item.Register( { 
	Name = "Zombie Rib", 
	Description = "This is the rib of a zombie.",
	Stackable = true, 
	Type = ITEM_QUEST_ZOMBIE,
	Weight = 2.50, 
	Price = PRICE_QUEST_ZOMBIE_ITEM,
	Rarity = 0.25,
	Model = "models/gibs/HGIBS_rib.mdl",
	Functions = { },
	CamPos = Vector(10,15,3),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Zombie Flesh", 
	Description = "This is a chunk of zombie flesh.",
	Stackable = true, 
	Type = ITEM_QUEST_ZOMBIE,
	Weight = 2.50, 
	Price = PRICE_QUEST_ZOMBIE_ITEM,
	Rarity = 0.25,
	Model = "models/props_junk/watermelon01_chunk02a.mdl",
	Functions = { },
	CamPos = Vector(8,8,5),
	CamOrigin = Vector(0,0,2.5)	
} )
