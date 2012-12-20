
// This is the ID given to any item that is an essential supply for every faction
ITEM_SUPPLY = 2

function FUNC_ENERGY( ply, id, client, icon )

	if icon then return "icon16/cup.png" end
	if client then return "Drink" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddStamina( 50 )
	ply:Notice( "+50 Stamina", GAMEMODE.Colors.Green )

end

function FUNC_HEAL( ply, id, client, icon )

	if icon then return "icon16/heart.png" end
	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "HealthVial.Touch" )
	ply:AddHealth( 75 )
	ply:Notice( "+75 Health", GAMEMODE.Colors.Green )

end

function FUNC_SUPERHEAL( ply, id, client, icon )

	if icon then return "icon16/heart.png" end
	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "HealthVial.Touch" )
	ply:AddHealth( 150 )
	ply:Notice( "+150 Health", GAMEMODE.Colors.Green )

end

function FUNC_BANDAGE( ply, id, client, icon )

	if icon then return "icon16/heart.png" end
	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "Cardboard.Strain" )
	ply:SetBleeding( false )
	ply:AddHealth( 20 )
	ply:Notice( "+20 Health", GAMEMODE.Colors.Green )
	ply:Notice( "Stopped bleeding", GAMEMODE.Colors.Green )

end

function FUNC_MUTAGEN( ply, id, client, icon )

	if icon then return "icon16/pill.png" end
	if client then return "Inject" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "Weapon_SMG1.Special1" )
	
	if ply:IsInfected() then
		
		ply:Notice( "Your infection has been cured", GAMEMODE.Colors.Green, 5, 0 )
		ply:SetInfected( false )
					
	end
	
	local tbl = {}
	local inc = 0
	
	for i=1,math.random(1,3) do
	
		local rand = math.random(1,5)
		
		while table.HasValue( tbl, rand ) do
		
			rand = math.random(1,5)
		
		end
		
		table.insert( tbl, rand )
		
		if rand == 1 then
		
			ply:Notice( "You feel extremely nauseous", GAMEMODE.Colors.Red, 5, inc * 2 )
		
			umsg.Start( "Drunk", ply )
			umsg.Short( math.random( 10, 20 ) )
			umsg.End()
		
		elseif rand == 2 then
		
			local rad = math.random(2,5)
		
			if math.random(1,2) == 1 and ply:GetRadiation() < 1 then
		
				ply:Notice( "+" .. rad .. " Radiation", GAMEMODE.Colors.Red, 5, inc * 2 )
				ply:AddRadiation( rad )
				
			else
			
				ply:Notice( "-" .. rad .. " Radiation", GAMEMODE.Colors.Green, 5, inc * 2 )
				ply:AddRadiation( -rad )
			
			end
		
		elseif rand == 3 then
		
			ply:Notice( "Your body begins to ache", GAMEMODE.Colors.Red, 5, inc * 2 )
			
			local dmg = math.random(2,5)
			
			ply:AddHealth( dmg * -10 )
		
		elseif rand == 4 then
		
			if math.random(1,2) == 1 then
		
				ply:Notice( "You feel exhausted", GAMEMODE.Colors.Red, 5, inc * 2 )
				ply:AddStamina( -50 )
				
			else
			
				ply:Notice( "+20 Stamina", GAMEMODE.Colors.Green, 5, inc * 2 )
				ply:AddStamina( 20 )
			
			end
		
		elseif rand == 5 then
		
			ply:Notice( "Your legs begin to feel weak", GAMEMODE.Colors.Red, 5, inc * 2 )
			ply:SetWalkSpeed( GAMEMODE.WalkSpeed - 80 )
			ply:SetRunSpeed( GAMEMODE.RunSpeed - 80 )
			
			local legtime = math.random( 20, 40 )
			
			timer.Simple( legtime - 5, function() if IsValid( ply ) and ply:Team() == TEAM_ARMY then ply:Notice( "Your legs start to feel better", GAMEMODE.Colors.Green, 5 ) end end )
			timer.Simple( legtime, function() if IsValid( ply ) and ply:Team() == TEAM_ARMY then ply:SetWalkSpeed( GAMEMODE.WalkSpeed ) ply:SetRunSpeed( GAMEMODE.RunSpeed ) end end )
		
		end
		
		inc = inc + 1
		
	end

end

item.Register( { 
	Name = "Energy Drink", 
	Description = "Restores 50 stamina.",
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
	Description = "Restores 50% of your health.",
	Stackable = true, 
	Type = ITEM_SUPPLY,
	Weight = 1.25, 
	Price = 5,
	Rarity = 0.65,
	Model = "models/radbox/healthpack.mdl",
	Functions = { FUNC_HEAL },
	CamPos = Vector(23,8,3),
	CamOrigin = Vector(0,0,-1)		
} )

item.Register( { 
	Name = "Advanced Medikit", 
	Description = "Restores 100% of your health.",
	Stackable = true, 
	Type = ITEM_SUPPLY,
	Weight = 1.25, 
	Price = 15,
	Rarity = 0.85,
	Model = "models/radbox/healthpack2.mdl",
	Functions = { FUNC_SUPERHEAL },
	CamPos = Vector(23,8,3),
	CamOrigin = Vector(0,0,-1)
} )

item.Register( { 
	Name = "Beta Mutagen", 
	Description = "Prototype drug which cures the infection.",
	Stackable = true, 
	Type = ITEM_SUPPLY,
	Weight = 1.25, 
	Price = 50,
	Rarity = 0.95,
	Model = "models/items/healthkit.mdl",
	Functions = { FUNC_MUTAGEN },
	CamPos = Vector(0,0,35),
	CamOrigin = Vector(4,0,0)
} )

item.Register( { 
	Name = "Bandage", 
	Description = "Stops all bleeding.",
	Stackable = true, 
	Type = ITEM_SUPPLY,
	Weight = 0.35, 
	Price = 5,
	Rarity = 0.50,
	Model = "models/radbox/bandage.mdl",
	Functions = { FUNC_BANDAGE },
	CamPos = Vector(18,10,5),
	CamOrigin = Vector(0,0,0)
} )

