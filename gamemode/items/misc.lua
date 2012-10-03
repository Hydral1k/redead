
// This is the ID given to any item that doesnt fit in any other category - feel free to add your own items here
ITEM_MISC = 5 // Can be found in stores or in loot
ITEM_BUYABLE = 6 // Only found in stores
ITEM_LOOT = 7 // Only found in loot
ITEM_QUEST_ZOMBIE = 421 // obsolete?

function FUNC_DRINK( ply, id, client, icon )

	if icon then return "icon16/cup.png" end
	if client then return "Drink" end

	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddHealth( 15 )
	ply:AddStamina( 25 )
	ply:Notice( "+15 Health", GAMEMODE.Colors.Green )
	ply:Notice( "+25 Stamina", GAMEMODE.Colors.Green )

end

function FUNC_EAT( ply, id, client, icon )

	if icon then return "icon16/cake.png" end
	if client then return "Eat" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "npc/barnacle/barnacle_crunch2.wav", 100, math.random( 90, 110 ) )
	ply:AddHealth( 25 )
	ply:AddStamina( 15 )
	ply:Notice( "+25 Health", GAMEMODE.Colors.Green )
	ply:Notice( "+15 Stamina", GAMEMODE.Colors.Green )

end

function FUNC_BOOZE( ply, id, client, icon )

	if icon then return "icon16/drink.png" end
	if client then return "Drink" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddRadiation( -2 )
	ply:AddStamina( 20 )
	ply:Notice( "+20 Stamina", GAMEMODE.Colors.Green )
	ply:Notice( "-2 Radiation", GAMEMODE.Colors.Green )
	ply:Notice( "+3 Drunkness", GAMEMODE.Colors.Red )
	
	umsg.Start( "Drunk", ply )
    umsg.Short( 3 )
	umsg.End()

end

function FUNC_MOONSHINE( ply, id, client, icon )

	if icon then return "icon16/drink.png" end
	if client then return "Drink" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddRadiation( -1 )
	ply:Notice( "-1 Radiation", GAMEMODE.Colors.Green )
	ply:Notice( "+4 Drunkness", GAMEMODE.Colors.Red )
	
	umsg.Start( "Drunk", ply )
    umsg.Short( 4 )
	umsg.End()

end

function FUNC_BEER( ply, id, client, icon )

	if icon then return "icon16/drink.png" end
	if client then return "Drink" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddStamina( 10 )
	ply:Notice( "+15 Stamina", GAMEMODE.Colors.Green )
	ply:Notice( "+2 Drunkness", GAMEMODE.Colors.Red )
	
	umsg.Start( "Drunk", ply )
    umsg.Short( 2 )
	umsg.End()

end

function FUNC_SPACEBEER( ply, id, client, icon )

	if icon then return "icon16/drink.png" end
	if client then return "Drink" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:Notice( "+10 Drunkness", GAMEMODE.Colors.Red )
	
	umsg.Start( "Drunk", ply )
    umsg.Short( 10 )
	umsg.End()

end

function FUNC_OPENSUITCASE( ply, id )

	local tbl = item.GetByID( id )
	
	ply:Notice( "You found some " .. GAMEMODE.CurrencyName .. "s", GAMEMODE.Colors.Green )
	ply:EmitSound( Sound( "Chain.ImpactSoft" ) )
	
	if math.random(1,10) == 1 then
	
		ply:AddCash( math.random(5,50) )
	
	else
	
		ply:AddCash( math.random(2,10) )
		
	end
	
	return false

end

item.Register( { 
	Name = "Suitcase", 
	CollisionOverride = true,
	Type = ITEM_LOOT,
	Rarity = 0.50,
	Model = "models/props_c17/suitcase_passenger_physics.mdl", 
	PickupFunction = FUNC_OPENSUITCASE,
	Functions = {}
} )

item.Register( { 
	Name = "Briefcase", 
	CollisionOverride = true,
	Type = ITEM_LOOT,
	Rarity = 0.50,
	Model = "models/props_c17/briefcase001a.mdl", 
	PickupFunction = FUNC_OPENSUITCASE,
	Functions = {}
} )

item.Register( { 
	Name = "Wood", 
	Description = "Used in building barricades.",
	Stackable = true, 
	Type = ITEM_MISC,
	Weight = 1.50, 
	Price = 15,
	Rarity = 0.10,
	Model = "models/props_debris/wood_chunk04a.mdl",
	Functions = {},
	CamPos = Vector(42,15,0),
	CamOrigin = Vector(0,0,-1)
} )

item.Register( { 
	Name = "Water", 
	Description = "Restores 25 stamina and 10 health.",
	Stackable = true, 
	Type = ITEM_MISC,
	Weight = 0.15, 
	Price = 3,
	Rarity = 0.05,
	Model = "models/props/cs_office/water_bottle.mdl",
	Functions = { FUNC_DRINK },
	CamPos = Vector(12,12,1),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Canned Food", 
	Description = "Restores 25 health and 10 stamina.",
	Stackable = true, 
	Type = ITEM_MISC,
	Weight = 0.15, 
	Price = 3,
	Rarity = 0.05,
	Model = "models/props_junk/garbage_metalcan001a.mdl",
	Functions = { FUNC_EAT },
	CamPos = Vector(10,10,0),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Beer", 
	Description = "Restores 15 stamina.",
	Stackable = true, 
	Type = ITEM_LOOT,
	Weight = 0.30, 
	Price = 5,
	Rarity = 0.80,
	Model = "models/props_junk/glassbottle01a.mdl",
	Functions = { FUNC_BEER },
	CamPos = Vector(16,12,1),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Tequila", 
	Description = "Don't drink this shit.",
	Stackable = true, 
	Type = ITEM_LOOT,
	Weight = 0.30, 
	Price = 5,
	Rarity = 0.95,
	Model = "models/props_junk/glassjug01.mdl",
	Functions = { FUNC_SPACEBEER },
	CamPos = Vector(19,0,6),
	CamOrigin = Vector(0,0,5)	
} )

item.Register( { 
	Name = "Vodka", 
	Description = "Releives radiation poisoning.",
	Stackable = true, 
	Type = ITEM_MISC,
	Weight = 0.30, 
	Price = 12,
	Rarity = 0.10,
	Model = "models/props_junk/garbage_glassbottle002a.mdl",
	Functions = { FUNC_BOOZE },
	CamPos = Vector(15,19,4),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "Moonshine Vodka", 
	Description = "Weaker homebrewed vodka.",
	Stackable = true, 
	Type = ITEM_BUYABLE,
	Weight = 0.30, 
	Price = 5,
	Rarity = 0.25,
	Model = "models/props_junk/garbage_glassbottle003a.mdl",
	Functions = { FUNC_MOONSHINE },
	CamPos = Vector(16,17,1),
	CamOrigin = Vector(0,0,-1)	
} )

item.Register( { 
	Name = "Human Skull", 
	Description = "This human skull looks pretty old. You decided to name it Murray.",
	Stackable = true, 
	Type = ITEM_QUEST_ZOMBIE,
	Weight = 2.50, 
	Price = 1,
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
	Price = 1,
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
	Price = 1,
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
	Price = 1,
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
	Price = 1,
	Rarity = 0.25,
	Model = "models/props_junk/watermelon01_chunk02a.mdl",
	Functions = { },
	CamPos = Vector(8,8,5),
	CamOrigin = Vector(0,0,2.5)	
} )
