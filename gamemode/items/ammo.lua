
// This is the ID given to any item that is ammunition
ITEM_AMMO = 4

// ammo constant
PRICE_AMMOBOX = 5

function FUNC_AMMO( ply, id )

	local tbl = item.GetByID( id )
	
	if not tbl.Ammo then return true end

	ply:AddAmmo( tbl.Ammo, tbl.Amount )

	return true
	
end

function FUNC_DROPAMMO( ply, id, drop )

	local tbl = item.GetByID( id )
	
	if not tbl.Ammo then return end

	ply:AddAmmo( tbl.Ammo, -tbl.Amount, true )
	
	return true // we don't want to override spawning the prop

end

item.Register( { 
	Name = "Pistol Rounds", 
	Description = "40 pistol rounds per box.",
	Stackable = true, 
	Type = ITEM_AMMO,
	Weight = 0.75, 
	Price = PRICE_AMMOBOX,
	Rarity = 0.20,
	Model = "models/items/357ammo.mdl",
	Ammo = "Pistol",
	Amount = 40,
	PickupFunction = FUNC_AMMO,
	DropFunction = FUNC_DROPAMMO,
	CamPos = Vector(14,13,4),
	CamOrigin = Vector(0,0,3)	
} )

item.Register( { 
	Name = "Buckshot", 
	Description = "20 shotgun rounds per box.",
	Stackable = true, 
	Type = ITEM_AMMO,
	Weight = 0.75, 
	Price = PRICE_AMMOBOX,
	Rarity = 0.20,
	Model = "models/items/boxbuckshot.mdl",
	Ammo = "Buckshot",
	Amount = 20,
	PickupFunction = FUNC_AMMO,
	DropFunction = FUNC_DROPAMMO,
	CamPos = Vector(21,15,8),
	CamOrigin = Vector(0,0,4)
} )

item.Register( { 
	Name = "SMG Rounds", 
	Description = "60 SMG rounds per box.",
	Stackable = true, 
	Type = ITEM_AMMO,
	Weight = 0.75, 
	Price = PRICE_AMMOBOX,
	Rarity = 0.60,
	Model = "models/items/boxsrounds.mdl",
	Ammo = "SMG",
	Amount = 60,
	PickupFunction = FUNC_AMMO,
	DropFunction = FUNC_DROPAMMO,
	CamPos = Vector(27,15,10),
	CamOrigin = Vector(0,0,4)
} )

item.Register( { 
	Name = "Rifle Rounds", 
	Description = "60 automatic rifle rounds per box.",
	Stackable = true, 
	Type = ITEM_AMMO,
	Weight = 0.75, 
	Price = PRICE_AMMOBOX + 5,
	Rarity = 0.80,
	Model = "models/items/boxmrounds.mdl",
	Ammo = "Rifle",
	Amount = 60,
	PickupFunction = FUNC_AMMO,
	DropFunction = FUNC_DROPAMMO,
	CamPos = Vector(29,22,10),
	CamOrigin = Vector(0,0,5)
} )

item.Register( { 
	Name = "Sniper Rounds", 
	Description = "30 sniper rounds per box.",
	Stackable = true, 
	Type = ITEM_AMMO,
	Weight = 0.75, 
	Price = PRICE_AMMOBOX + 5,
	Rarity = 0.80,
	Model = "models/items/boxqrounds.mdl",
	Ammo = "Sniper",
	Amount = 30,
	PickupFunction = FUNC_AMMO,
	DropFunction = FUNC_DROPAMMO,
	CamPos = Vector(-18,-14,8),
	CamOrigin = Vector(4,0,-1)
} )

item.Register( { 
	Name = "Prototype Energy Cell", 
	Description = "20 energy charges per cell.",
	Stackable = true, 
	Type = ITEM_AMMO,
	Weight = 1.25, 
	Price = PRICE_AMMOBOX + 5,
	Rarity = 0.80,
	Model = "models/items/battery.mdl",
	Ammo = "Prototype",
	Amount = 20,
	PickupFunction = FUNC_AMMO,
	DropFunction = FUNC_DROPAMMO,
	CamPos = Vector(15,15,8),
	CamOrigin = Vector(0,0,5)	
} )

