
// This is the ID given to any weapon item for all teams
ITEM_WPN_COMMON = 11

function FUNC_DROPWEAPON( ply, id, client, icon )

	if icon then return "icon16/arrow_down.png" end
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
	Description = "Builds barricades and bashes skulls.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 3, 
	Price = 35,
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
	Name = "Axe", 
	Description = "The messiest melee weapon.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
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
	Name = "FN Five-Seven", 
	Description = "A standard issue sidearm.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 3, 
	Price = 15,
	Rarity = 0.50,
	Model = "models/weapons/w_pist_fiveseven.mdl",
	Weapon = "rad_fiveseven",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,15,5),
	CamOrigin = Vector(6,0,2)
} )

item.Register( { 
	Name = "USP Compact", 
	Description = "A standard issue sidearm.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
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
	Description = "A standard issue sidearm.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 3, 
	Price = 15,
	Rarity = 0.50,
	Model = "models/weapons/w_pist_p228.mdl",
	Weapon = "rad_p228",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,15,5),
	CamOrigin = Vector(6,0,2)
} )

item.Register( { 
	Name = "Glock 19", 
	Description = "A standard issue sidearm.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
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
	Name = "Dual Berettas", 
	Description = "Double the guns, double the fun.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 3, 
	Price = 45,
	Rarity = 0.40,
	Model = "models/weapons/w_pist_elite_single.mdl",
	Weapon = "rad_berettas",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,18,-5),
	CamOrigin = Vector(6,0,2)
} )

item.Register( { 
	Name = "Desert Eagle", 
	Description = "Small magazine, big firepower.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 50,
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
	Name = "Colt Python", 
	Description = "A six shooter that packs a punch.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 50,
	Rarity = 0.70,
	Model = "models/weapons/w_357.mdl",
	Weapon = "rad_revolver",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,20,0),
	CamOrigin = Vector(6,0,0)
} )

item.Register( { 
	Name = "MAC-10", 
	Description = "A compact SMG that packs a kick.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 55,
	Rarity = 0.25,
	Model = "models/weapons/w_smg_mac10.mdl",
	Weapon = "rad_mac10",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,22,5),
	CamOrigin = Vector(5,0,0)
} )

item.Register( { // fuck this gun
	Name = "UMP45", 
	Description = "Size isn't everything.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
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
	Name = "CMP-250", 
	Description = "An experimental burst-fire SMG.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 65,
	Rarity = 0.25,
	Model = "models/weapons/w_smg1.mdl",
	Weapon = "rad_cmp",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,27,0),
	CamOrigin = Vector(-1,0,-1)
} )

item.Register( { 
	Name = "Winchester 1887", 
	Description = "Zombies are in season.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 6, 
	Price = 70,
	Rarity = 0.40,
	Model = "models/weapons/w_annabelle.mdl",
	Weapon = "rad_shotgun",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-50,5),
	CamOrigin = Vector(3,0,1)
} )

item.Register( { 
	Name = "TMP", 
	Description = "A silent but deadly SMG.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 75,
	Rarity = 0.25,
	Model = "models/weapons/w_smg_tmp.mdl",
	Weapon = "rad_tmp",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,24,5),
	CamOrigin = Vector(10,0,0)
} )

item.Register( { 
	Name = "MP5", 
	Description = "A well-rounded, reliable SMG.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 6, 
	Price = 80,
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
	Name = "FN P90 LV", 
	Description = "A powerful SMG with a large magazine.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 85,
	Rarity = 0.25,
	Model = "models/weapons/w_smg_p90.mdl",
	Weapon = "rad_p90",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,32,5),
	CamOrigin = Vector(3,0,0)
} )

item.Register( { 
	Name = "SPAS-12", 
	Description = "Useful for crowd control.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 7, 
	Price = 90,
	Rarity = 0.80,
	Model = "models/weapons/w_shotgun.mdl",
	Weapon = "rad_spas12",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-34,0),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "IMI Galil", 
	Description = "Lower accuracy, larger magazine.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 8, 
	Price = 100,
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
	Description = "A solid, reliable assault rifle.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 7, 
	Price = 110,
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
	Name = "FAMAS PBW-5", 
	Description = "An experimental particle beam weapon.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 9, 
	Price = 130,
	Rarity = 0.80,
	Model = "models/weapons/w_rif_famas.mdl",
	Weapon = "rad_experimental",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(-7,35,5),
	CamOrigin = Vector(3,0,0)
} )

item.Register( { 
	Name = "SG552", 
	Description = "Comes with a free scope.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
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
	Name = "Steyr Scout", 
	Description = "A bolt-action sniper rifle.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 9, 
	Price = 170,
	Rarity = 0.80,
	Model = "models/weapons/w_snip_scout.mdl",
	Weapon = "rad_scout",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,45,5),
	CamOrigin = Vector(10,0,0)
} )

item.Register( { 
	Name = "G3 SG1", 
	Description = "An automatic sniper rifle.",
	Stackable = false, 
	Type = ITEM_WPN_COMMON,
	TypeOverride = "sent_droppedgun",
	Weight = 9, 
	Price = 190,
	Rarity = 0.90,
	Model = "models/weapons/w_snip_g3sg1.mdl",
	Weapon = "rad_g3",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,45,5),
	CamOrigin = Vector(7,0,2)
} )


