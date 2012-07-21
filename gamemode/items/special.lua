
// This is the ID given to any item that is a SPECIALIST supply
ITEM_SPECIAL = 3

function FUNC_ANTIRAD( ply, id, client )

	if icon then return "icon16/pill.png" end
	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "Weapon_SMG1.Special1" )
	ply:SetRadiation( 0 )
	ply:Notice( "-5 Radiation", GAMEMODE.Colors.Green )

end

function FUNC_FLARE( ply, id, client, icon )

	if icon then return "icon16/lightbulb.png" end
	if client then return "Ignite" end
	
	ply:RemoveFromInventory( id )
	
	local prop = ents.Create( "sent_flare" )
	prop:SetPos( ply:GetItemDropPos() )
	prop:Spawn()

end

item.Register( { 
	Name = "Anti-Rad", 
	Description = "Radiation poisoning medication.",
	Stackable = true, 
	Type = ITEM_SPECIAL,
	Weight = 0.15, 
	Price = 15,
	Rarity = 0.30,
	Model = "models/healthvial.mdl",
	Functions = { FUNC_ANTIRAD },
	CamPos = Vector(15,10,9),
	CamOrigin = Vector(0,0,5)	
} )

item.Register( { 
	Name = "Respirator", 
	Description = "Filters out hazardous chemicals and radiation.",
	Stackable = true, 
	Type = ITEM_SPECIAL,
	Weight = 1.75, 
	Price = 40,
	Rarity = 0.95,
	Model = "models/items/combine_rifle_cartridge01.mdl",
	CamPos = Vector(15,15,0),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Sonar Module", 
	Description = "Improves your radar detection range and speed.",
	Stackable = true, 
	Type = ITEM_SPECIAL,
	Weight = 0.75, 
	Price = 30,
	Rarity = 0.90,
	Model = "models/gibs/shield_scanner_gib1.mdl",
	Functions = {},
	CamPos = Vector(5,8,8),
	CamOrigin = Vector(0,0,0)		
} )

item.Register( { 
	Name = "Flare", 
	Description = "Emits a bright red light for a short duration of time.",
	Stackable = true, 
	Type = ITEM_SPECIAL,
	Weight = 0.35, 
	Price = 3,
	Rarity = 0.10,
	Model = "models/props_c17/trappropeller_lever.mdl",
	Functions = { FUNC_FLARE },
	CamPos = Vector(15,5,5),
	CamOrigin = Vector(0,0,0)		
} )


