
// This is the ID given to any weapon item for SPECIAL
ITEM_WPN_SPECIAL = 10

function FUNC_PLANTBOMB( ply, id, client )

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

end

item.Register( { 
	Name = "HE Grenade", 
	Description = "These grenades have a large explosion radius and a fuse that lasts 3 seconds.",
	Stackable = true, 
	Type = ITEM_WPN_SPECIAL,
	Weight = 1, 
	Price = 5,
	Rarity = 0.20,
	Model = "models/weapons/w_eq_fraggrenade.mdl",
	Weapon = "rad_grenade",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(1,10,-3),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "Timed Explosives", 
	Description = "This is a homemade Composition-C explosive. The timer is set to last 10 seconds.",
	Stackable = true, 
	Type = ITEM_WPN_SPECIAL,
	Weight = 3, 
	Price = 10,
	Rarity = 0.80,
	Model = "models/weapons/w_c4.mdl",
	Functions = { FUNC_PLANTBOMB },
	CamPos = Vector(-13,-3,-3),
	CamOrigin = Vector(0,5,0)
} )

item.Register( { 
	Name = "M249", 
	Description = "This belt-fed machine gun chews through the zombie hordes with ease.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
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
	Description = "The very definition of overkill, now in sniper rifle form.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
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