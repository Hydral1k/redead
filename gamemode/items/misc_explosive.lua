
function FUNC_OXYGEN( ply, id, client, icon )

	if icon then return "icon16/arrow_turn_right.png" end
	if client then return "Throw" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( Sound( "WeaponFrag.Throw" ) )
	
	local oxy = ents.Create( "sent_oxygen" )
	oxy:SetPos( ply:GetItemDropPos() )
	oxy:SetAngles( ply:GetAimVector():Angle() )
	oxy:Spawn()

end

function FUNC_DROPOXYGEN( ply, id, drop )

	
	if not drop then return end

	local oxy = ents.Create( "sent_oxygen" )
	oxy:SetSpeed( 500 )
	oxy:SetPos( ply:GetItemDropPos() )
	oxy:SetAngles( ply:GetAimVector():Angle() )
	oxy:Spawn()

	return false // override spawning a prop for this item

end

item.Register( { 
	Name = "Liquid Oxygen", 
	Description = "Highly explosive liquid oxygen.",
	TypeOverride = "sent_oxygen",
	Stackable = true, 
	Type = ITEM_LOOT,
	Weight = 1.50, 
	Price = 50,
	Rarity = 0.15,
	Model = "models/props_phx/misc/potato_launcher_explosive.mdl",
	Functions = { FUNC_OXYGEN },
	DropFunction = FUNC_DROPOXYGEN,
	CamPos = Vector(24,0,8),
	CamOrigin = Vector(0,0,6)	
} )

item.Register( { 
	Name = "Gasoline", 
	TypeOverride = "sent_fuel_gas",
	AllowPickup = true,
	CollisionOverride = true,
	Type = ITEM_LOOT,
	Rarity = 0.40,
	Model = "models/props_junk/gascan001a.mdl",
	Functions = {}
} )

item.Register( { 
	Name = "Diesel Fuel", 
	TypeOverride = "sent_fuel_diesel",
	AllowPickup = true,
	CollisionOverride = true,
	Type = ITEM_LOOT,
	Rarity = 0.60,
	Model = "models/props_junk/metalgascan.mdl",
	Functions = {}
} )

item.Register( { 
	Name = "Propane Canister", 
	TypeOverride = "sent_propane_canister",
	AllowPickup = true,
	CollisionOverride = true,
	Type = ITEM_LOOT,
	Rarity = 0.60,
	Model = "models/props_junk/propane_tank001a.mdl",
	Functions = {}
} )

item.Register( { 
	Name = "Propane Tank", 
	TypeOverride = "sent_propane_tank",
	AllowPickup = true,
	CollisionOverride = true,
	Type = ITEM_LOOT,
	Rarity = 0.40,
	Model = "models/props_junk/propanecanister001a.mdl",
	Functions = {}
} )
