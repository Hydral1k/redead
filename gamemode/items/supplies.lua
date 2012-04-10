
// This is the ID given to any item that is an essential supply for every faction
ITEM_SUPPLY = 2

function FUNC_ENERGY( ply, id, client )

	if client then return "Drink" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddStamina( 100 )
	ply:Notice( "+100 Stamina", GAMEMODE.Colors.Green )

end

function FUNC_HEAL( ply, id, client )

	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "HealthVial.Touch" )
	ply:AddHealth( 75 )
	ply:Notice( "+75 Health", GAMEMODE.Colors.Green )

end

function FUNC_SUPERHEAL( ply, id, client )

	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "HealthVial.Touch" )
	ply:AddRadiation( -1 )
	ply:AddHealth( 150 )
	ply:Notice( "+150 Health", GAMEMODE.Colors.Green )
	ply:Notice( "-1 Radiation", GAMEMODE.Colors.Green )

end

function FUNC_BANDAGE( ply, id, client )

	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "Cardboard.Strain" )
	ply:SetBleeding( false )
	ply:AddHealth( 20 )
	ply:Notice( "+20 Health", GAMEMODE.Colors.Green )
	ply:Notice( "Stopped bleeding", GAMEMODE.Colors.Green )

end

item.Register( { 
	Name = "Energy Drink", 
	Description = "This is a carbonated energy drink. It will replenish your stamina when used.",
	Stackable = true, 
	Type = ITEM_SUPPLY,
	Weight = 0.25, 
	Price = 5,
	Rarity = 0.25,
	Model = "models/props_junk/popcan01a.mdl",
	Functions = { FUNC_ENERGY },
	CamPos = Vector(10,10,0),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Basic Medikit", 
	Description = "This kit will heal 50% of your health when used.",
	Stackable = true, 
	Type = ITEM_SUPPLY,
	Weight = 1.25, 
	Price = 5,
	Rarity = 0.65,
	Model = "models/radbox/healthpack.mdl",
	Functions = { FUNC_HEAL },
	CamPos = Vector(23,8,5)	
} )

item.Register( { 
	Name = "Advanced Medikit", 
	Description = "This kit will heal 100% of your health and relieve a small amount of radiation poisoning when used.",
	Stackable = true, 
	Type = ITEM_SUPPLY,
	Weight = 1.25, 
	Price = 15,
	Rarity = 0.85,
	Model = "models/radbox/healthpack2.mdl",
	Functions = { FUNC_SUPERHEAL },
	CamPos = Vector(23,8,5)
} )

item.Register( { 
	Name = "Bandage", 
	Description = "This medicinal gauze will effectively cover your open wounds and stop all bleeding.",
	Stackable = true, 
	Type = ITEM_SUPPLY,
	Weight = 0.35, 
	Price = 5,
	Rarity = 0.50,
	Model = "models/radbox/bandage.mdl",
	Functions = { FUNC_BANDAGE },
	CamPos = Vector(20,10,5),
	CamOrigin = Vector(0,1,1)
} )

