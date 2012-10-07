
// This is the ID given to any weapon item for SPECIAL
ITEM_WPN_SPECIAL = 10

--[[function FUNC_PLANTBOMB( ply, id, client )

	if client then return "Arm" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "weapons/c4/c4_plant.wav" )
	
	local trace = {}
	trace.start = ply:GetShootPos()
	trace.endpos = ply:GetShootPos() + ply:GetAimVector() * 50
	trace.filter = ply
	local tr = util.TraceLine( trace )
	
	local bomb = ents.Create( "sent_c4" )
	bomb:SetPos( tr.HitPos )
	bomb:SetOwner( ply )
	bomb:Spawn()

end]]

item.Register( { 
	Name = "HE Grenade", 
	Description = "The fuse lasts 3 seconds.",
	Stackable = true, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 1, 
	Price = 5,
	Rarity = 0.20,
	Model = "models/weapons/w_eq_fraggrenade_thrown.mdl",
	Weapon = "rad_grenade",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(1,10,4),
	CamOrigin = Vector(0,0,1)
} )

item.Register( { 
	Name = "Incendiary Grenade", 
	Description = "These grenades ignite a small area.",
	Stackable = true, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 1, 
	Price = 8,
	Rarity = 0.20,
	Model = "models/weapons/w_eq_flashbang.mdl",
	Weapon = "rad_incendiarygrenade",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(3,11,1),
	CamOrigin = Vector(0,0,-1)
} )

item.Register( { 
	Name = "M249", 
	Description = "A belt-fed support machine gun.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 10, 
	Price = 150,
	Rarity = 0.90,
	Model = "models/weapons/w_mach_m249para.mdl",
	Weapon = "rad_m249",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,36,5),
	CamOrigin = Vector(13,0,2)
} )

item.Register( { 
	Name = "AWP", 
	Description = "The very definition of overkill.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 9, 
	Price = 200,
	Rarity = 0.90,
	Model = "models/weapons/w_snip_awp.mdl",
	Weapon = "rad_awp",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,55,5),
	CamOrigin = Vector(12,0,2)
} )

--[[item.Register( { 
	Name = "Timed Explosives", 
	Description = "This is a homemade timed explosive.",
	Stackable = true, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 3, 
	Price = 10,
	Rarity = 0.80,
	Model = "models/weapons/w_c4.mdl",
	Functions = { FUNC_PLANTBOMB },
	CamPos = Vector(-12,-2,0),
	CamOrigin = Vector(0,5,0)
} )]]