
// This is the ID given to any weapon item for all teams
ITEM_WPN_COMMON = 11

function FUNC_DROPWEAPON( ply, id, client )

	if client then return "Drop" end
	
	local tbl = item.GetByID( id )
	
	local prop = ents.Create( "sent_droppedgun" )
	prop:SetPos( ply:GetItemDropPos() )
	prop:SetModel( tbl.Model )
	prop:Spawn()
	
	ply:EmitSound( Sound( "items/ammopickup.wav" ) )
	ply:RemoveFromInventory( id )
	
	if not ply:HasItem( id ) then
	
		ply:StripWeapon( tbl.Weapon )
		
	end

end

function FUNC_REMOVEWEAPON( ply, id )

	local tbl = item.GetByID( id )
	
	if not ply:HasItem( id ) then
	
		ply:StripWeapon( tbl.Weapon )
		
	end

end

function FUNC_GRABWEAPON( ply, id )

	local tbl = item.GetByID( id )
	
	ply:Give( tbl.Weapon )
	
	return true

end

item.Register( { 
	Name = "Hammer", 
	Description = "Useful for building barricades and busting zombie skulls.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 3, 
	Price = 30,
	Rarity = 0.95,
	Model = "models/weapons/w_hammer.mdl",
	Weapon = "rad_hammer",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-28,0),
	CamOrigin = Vector(0,0,5)
} )

item.Register( { 
	Name = "USP Compact", 
	Description = "This well rounded pistol is an ideal sidearm for any situation.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 3, 
	Price = 15,
	Rarity = 0.50,
	Model = "models/weapons/w_pistol.mdl",
	Weapon = "rad_usp",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-18,0),
	CamOrigin = Vector(0,0,-1)
} )

item.Register( { 
	Name = "P228 Compact", 
	Description = "This well rounded pistol is an ideal sidearm for any situation.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 3, 
	Price = 15,
	Rarity = 0.50,
	Model = "models/weapons/w_pist_p228.mdl",
	Weapon = "rad_p228",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,15,5),
	CamOrigin = Vector(5,0,2)
} )

item.Register( { 
	Name = "Glock 19", 
	Description = "This well rounded pistol is an ideal sidearm for any situation.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 3, 
	Price = 15,
	Rarity = 0.50,
	Model = "models/weapons/w_pist_glock18.mdl",
	Weapon = "rad_glock",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,15,5),
	CamOrigin = Vector(5,0,2)
} )

item.Register( { 
	Name = "Desert Eagle", 
	Description = "This pistol makes up for its smaller magazine with raw firepower.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 4, 
	Price = 40,
	Rarity = 0.70,
	Model = "models/weapons/w_pist_deagle.mdl",
	Weapon = "rad_deagle",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,16,5),
	CamOrigin = Vector(7,0,2)
} )

item.Register( { 
	Name = "MAC 10", 
	Description = "This compact submachine gun packs a lot of kick.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 4, 
	Price = 40,
	Rarity = 0.25,
	Model = "models/weapons/w_smg_mac10.mdl",
	Weapon = "rad_mac10",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,22,5),
	CamOrigin = Vector(5,0,0)
} )

item.Register( { 
	Name = "Dual Berettas", 
	Description = "As if one Beretta wasn't already enough.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 3, 
	Price = 50,
	Rarity = 0.50,
	Model = "models/weapons/w_pist_elite_single.mdl",
	Weapon = "rad_berettas",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,18,-5),
	CamOrigin = Vector(5,0,2)
} )

item.Register( { 
	Name = "HK MP5", 
	Description = "A perfectly acceptable substitute for an assault rifle.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 6, 
	Price = 50,
	Rarity = 0.50,
	Model = "models/weapons/w_smg_mp5.mdl",
	Weapon = "rad_mp5",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,37,5),
	CamOrigin = Vector(5,0,2)
} )

item.Register( { 
	Name = "HK UMP45", 
	Description = "Don't let the small magazines fool you. Size isn't everything.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 6, 
	Price = 60,
	Rarity = 0.60,
	Model = "models/weapons/w_smg_ump45.mdl",
	Weapon = "rad_ump45",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,36,5),
	CamOrigin = Vector(5,0,0)
} )

item.Register( { 
	Name = "Winchester 1887", 
	Description = "The weapon of choice for deer hunters. Too bad it's zombie season.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 6, 
	Price = 60,
	Rarity = 0.40,
	Model = "models/weapons/w_annabelle.mdl",
	Weapon = "rad_shotgun",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-50,5),
	CamOrigin = Vector(3,0,2)
} )

item.Register( { 
	Name = "Axe", 
	Description = "The melee weapon of choice for lumberjacks and sociopaths alike.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 5, 
	Price = 70,
	Rarity = 0.95,
	Model = "models/weapons/w_axe.mdl",
	Weapon = "rad_axe",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-42,0),
	CamOrigin = Vector(0,0,8)
} )

item.Register( { 
	Name = "M3 Super 90", 
	Description = "This shotgun is useful for crowd control.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 7, 
	Price = 80,
	Rarity = 0.80,
	Model = "models/weapons/w_shot_m3super90.mdl",
	Weapon = "rad_m3",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,42,5),
	CamOrigin = Vector(8,0,2)
} )

item.Register( { 
	Name = "IMI Galil", 
	Description = "A less accurate assault rifle with a large magazine.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 8, 
	Price = 90,
	Rarity = 0.90,
	Model = "models/weapons/w_rif_galil.mdl",
	Weapon = "rad_galil",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,43,5),
	CamOrigin = Vector(10,0,0)
} )

item.Register( { 
	Name = "AK-47", 
	Description = "This accurate assault rifle packs a punch.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 7, 
	Price = 130,
	Rarity = 0.90,
	Model = "models/weapons/w_rif_ak47.mdl",
	Weapon = "rad_ak47",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,43,5),
	CamOrigin = Vector(10,0,0)
} )

item.Register( { 
	Name = "VX-5 Experimental Weapon", 
	Description = "This weapon uses prototype energy cell ammunition. It looks very shiny and dangerous.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 9, 
	Price = 150,
	Rarity = 0.80,
	Model = "models/weapons/w_smg_p90.mdl",
	Weapon = "rad_experimental",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,32,5),
	CamOrigin = Vector(3,0,0)
} )

item.Register( { 
	Name = "SG 552", 
	Description = "This assaualt rifle has a scope attached for precision shooting.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 8, 
	Price = 150,
	Rarity = 0.90,
	Model = "models/weapons/w_rif_sg552.mdl",
	Weapon = "rad_sg552",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,40,5),
	CamOrigin = Vector(6,0,0)
} )

item.Register( { 
	Name = "G3 SG1", 
	Description = "This automatic sniper rifle has a large magazine and a fast rate of fire.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 9, 
	Price = 170,
	Rarity = 0.90,
	Model = "models/weapons/w_snip_g3sg1.mdl",
	Weapon = "rad_g3",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,45,5),
	CamOrigin = Vector(7,0,2)
} )

item.Register( { 
	Name = "M1014 Shotgun", 
	Description = "This shotgun is useful for turning zombies into ground beef.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 7, 
	Price = 180,
	Rarity = 0.90,
	Model = "models/weapons/w_shot_xm1014.mdl",
	Weapon = "rad_m1014",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,34,5),
	CamOrigin = Vector(12,0,2)
} )

item.Register( { 
	Name = "Steyr Scout", 
	Description = "This bolt-action sniper rifle is useful for eliminating targets from a distance.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	Weight = 9, 
	Price = 190,
	Rarity = 0.80,
	Model = "models/weapons/w_snip_scout.mdl",
	Weapon = "rad_scout",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,45,5),
	CamOrigin = Vector(10,0,0)
} )

