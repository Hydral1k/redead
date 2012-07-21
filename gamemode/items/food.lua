
// This is the ID given to any item that is edible 
ITEM_FOOD = 1

// Weight constants
WEIGHT_FOOD_SMALL = 0.15

// Price constants
PRICE_FOOD = 3

function FUNC_DRINK( ply, id, client, icon )

	if icon then return "icon16/cup.png" end
	if client then return "Drink" end

	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddHealth( 10 )
	ply:AddStamina( 25 )
	ply:Notice( "+10 Health", GAMEMODE.Colors.Green )
	ply:Notice( "+25 Stamina", GAMEMODE.Colors.Green )

end

function FUNC_EAT( ply, id, client, icon )

	if icon then return "icon16/cake.png" end
	if client then return "Eat" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "npc/barnacle/barnacle_crunch2.wav", 100, math.random( 90, 110 ) )
	ply:AddHealth( 25 )
	ply:AddStamina( 10 )
	ply:Notice( "+25 Health", GAMEMODE.Colors.Green )
	ply:Notice( "+10 Stamina", GAMEMODE.Colors.Green )

end

item.Register( { 
	Name = "Water", 
	Description = "Restores 25 stamina and 10 health.",
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
	Name = "Canned Food", 
	Description = "Restores 25 health and 10 stamina.",
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

