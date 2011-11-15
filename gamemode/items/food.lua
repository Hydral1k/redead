
// This is the ID given to any item that is edible 
ITEM_FOOD = 1

// Weight constants
WEIGHT_FOOD_SMALL = 0.15

// Price constants
PRICE_FOOD = 3

function FUNC_DRINK( ply, id, client )

	if client then return "Drink" end

	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddHealth( 20 )
	ply:AddStamina( 50 )
	ply:Notice( "+20 Health", GAMEMODE.Colors.Green )
	ply:Notice( "+50 Stamina", GAMEMODE.Colors.Green )

end

function FUNC_EAT( ply, id, client )

	if client then return "Eat" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "npc/barnacle/barnacle_crunch2.wav", 100, math.random( 90, 110 ) )
	ply:AddHealth( 50 )
	ply:AddStamina( 20 )
	ply:Notice( "+50 Health", GAMEMODE.Colors.Green )
	ply:Notice( "+20 Stamina", GAMEMODE.Colors.Green )

end

item.Register( { 
	Name = "Water", 
	Description = "This old bottle is full of clean water. It should be safe to drink.",
	Stackable = true, 
	Type = ITEM_FOOD,
	Weight = WEIGHT_FOOD_SMALL, 
	Price = PRICE_FOOD,
	Rarity = 0.05,
	Model = "models/props_junk/garbage_plasticbottle003a.mdl",
	Functions = { FUNC_DRINK },
	CamPos = Vector(22,22,0),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Canned Meat", 
	Description = "This can contains what appears to be processed meat. Maybe it's dog food.",
	Stackable = true, 
	Type = ITEM_FOOD,
	Weight = WEIGHT_FOOD_SMALL, 
	Price = PRICE_FOOD,
	Rarity = 0.05,
	Model = "models/props_junk/garbage_metalcan001a.mdl",
	Functions = { FUNC_EAT },
	CamPos = Vector(10,10,0),
	CamOrigin = Vector(0,0,0)	
} )

