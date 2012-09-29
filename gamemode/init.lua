
require( "glon" ) 

include( 'resource.lua' )
include( 'enums.lua' )
include( 'items.lua' )
include( 'events.lua' )
include( 'shared.lua' )
include( 'moddable.lua' )
include( 'ply_extension.lua' )
include( 'tables.lua' )
include( 'boneanimlib.lua' )
include( 'sh_boneanimlib.lua' )
include( 'ply_anims.lua' )

AddCSLuaFile( 'sh_boneanimlib.lua' )
AddCSLuaFile( 'cl_animeditor.lua' )
AddCSLuaFile( 'cl_boneanimlib.lua' )
AddCSLuaFile( 'ply_anims.lua' )
AddCSLuaFile( 'enums.lua' )
AddCSLuaFile( 'items.lua' )
AddCSLuaFile( 'shared.lua' )
AddCSLuaFile( 'moddable.lua' )
AddCSLuaFile( 'cl_notice.lua' )
AddCSLuaFile( 'cl_hudstains.lua' )
AddCSLuaFile( 'cl_targetid.lua' )
AddCSLuaFile( 'cl_spawnmenu.lua' )
AddCSLuaFile( 'cl_inventory.lua' )
AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'cl_postprocess.lua' )
AddCSLuaFile( 'cl_scoreboard.lua' )
AddCSLuaFile( 'tables.lua' )
AddCSLuaFile( 'vgui/vgui_panelbase.lua' )
AddCSLuaFile( 'vgui/vgui_dialogue.lua' )
AddCSLuaFile( 'vgui/vgui_shopmenu.lua' )
AddCSLuaFile( 'vgui/vgui_classpicker.lua' )
AddCSLuaFile( 'vgui/vgui_zombieclasses.lua' )
AddCSLuaFile( 'vgui/vgui_itempanel.lua' )
AddCSLuaFile( 'vgui/vgui_helpmenu.lua' )
AddCSLuaFile( 'vgui/vgui_endgame.lua' )
AddCSLuaFile( 'vgui/vgui_itemdisplay.lua' )
AddCSLuaFile( 'vgui/vgui_playerdisplay.lua' )
AddCSLuaFile( 'vgui/vgui_playerpanel.lua' )
AddCSLuaFile( 'vgui/vgui_panelsheet.lua' )
AddCSLuaFile( 'vgui/vgui_goodmodelpanel.lua' )
AddCSLuaFile( 'vgui/vgui_categorybutton.lua' )
AddCSLuaFile( 'vgui/vgui_sidebutton.lua' )
AddCSLuaFile( 'vgui/vgui_scroller.lua' )

util.AddNetworkString( "InventorySynch" )
util.AddNetworkString( "StashSynch" )
util.AddNetworkString( "StatsSynch" )
util.AddNetworkString( "InventorySynch" )

function GM:Initialize()
	
	GAMEMODE.NextZombieThink = CurTime() + GAMEMODE.WaitTime
	GAMEMODE.RandomLoot = {}
	GAMEMODE.PlayerIDs = {}
	GAMEMODE.Lords = {}
	GAMEMODE.Wave = 1
	GAMEMODE.NextWave = CurTime() + 60 * GetConVar( "sv_redead_wave_length" ):GetInt()
	
	local length = #GAMEMODE.Waves * ( GetConVar( "sv_redead_wave_length" ):GetInt() * 60 ) 
	
	for i=1, #GAMEMODE.Waves - 1 do
	
		local remain = length - i * GetConVar( "sv_redead_wave_length" ):GetInt() * 60
		local num = i * GetConVar( "sv_redead_wave_length" ):GetInt()
		
		timer.Simple( remain, function() for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do v:Notice( num .. " minutes until evac arrives", GAMEMODE.Colors.White, 5 )  end end )
	 
	end
	
	timer.Simple( GAMEMODE.WaitTime, function() for k,v in pairs( player.GetAll() ) do v:Notice( "The undead onslaught has begun", GAMEMODE.Colors.White, 5 ) end end )
	
	timer.Simple( 90, function() GAMEMODE:PickLord() end )
	
	timer.Simple( 110, function() GAMEMODE:PickLord( true ) end )
	
	timer.Simple( length - 60, function() for k,v in pairs( player.GetAll() ) do v:ClientSound( GAMEMODE.LastMinute ) v:Notice( "The evac chopper is en route", GAMEMODE.Colors.White, 5 ) end end )
	
	timer.Simple( length - 40, function() 
									for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do 
										v:Notice( "The evac chopper has arrived", GAMEMODE.Colors.White, 5 ) 
										v:Notice( "You have 45 seconds to reach the evac zone", GAMEMODE.Colors.White, 5, 2 )
										v:Notice( "The location is marked on your radar", GAMEMODE.Colors.White, 5, 4 )
									end 
									if IsValid( GAMEMODE.Antidote ) then
									
										GAMEMODE.Antidote:SetOverride()
									
									end
									GAMEMODE:SpawnEvac() 
								end )
	
	timer.Simple( length + 5, function() GAMEMODE:CheckGameOver( true ) end )
	
end

function GM:InitPostEntity()	

	GAMEMODE.Trader = ents.Create( "info_trader" )
	GAMEMODE.Trader:Spawn()
	
	GAMEMODE.SpecialTrader = ents.Create( "info_trader" )
	GAMEMODE.SpecialTrader:SetSpecial( true )
	GAMEMODE.SpecialTrader:Spawn()

	local badshit = ents.FindByClass( "npc_*" )
	badshit = table.Add( badshit, ents.FindByClass( "weapon_*" ) )
	badshit = table.Add( badshit, ents.FindByClass( "prop_ragdoll" ) )
	badshit = table.Add( badshit, ents.FindByClass( "item_*" ) )
	badshit = table.Add( badshit, ents.FindByClass( "point_servercommand" ) )
	badshit = table.Add( badshit, ents.FindByClass( "env_entity_maker" ) )
	badshit = table.Add( badshit, ents.FindByClass( "point_template" ) )
	
	for k,v in pairs( ents.FindByClass( "prop_phys*" ) ) do
	
		if string.find( v:GetModel(), "explosive" ) or string.find( v:GetModel(), "propane" ) or string.find( v:GetModel(), "gascan" ) then
		
			table.insert( badshit, v )
		
		end
	
	end

	for k,v in pairs( badshit ) do
	
		v:Remove()
	
	end
	
	for k,v in pairs( ents.FindByClass( "prop_phys*" ) ) do
	
		local phys = v:GetPhysicsObject()
		
		if IsValid( phys ) and phys:GetMass() <= 5 then
		
			v:Remove()
		
		end
	
	end
	
	GAMEMODE:LoadAllEnts()
	
	local num = #ents.FindByClass( "point_radiation" )
	
	if num < 5 then return end
	
	for i=1, math.floor( num * GAMEMODE.RadiationAmount ) do
	
		local rad = table.Random( ents.FindByClass( "point_radiation" ) )
		
		while !rad:IsActive() do
		
			rad = table.Random( ents.FindByClass( "point_radiation" ) )
		
		end
		
		rad:SetActive( false )
	
	end
	
end

function GM:SaveAllEnts()

	MsgN( "Saving toxsin entity data..." )

	local enttbl = {
		info_player_zombie = {},
		info_player_army = {},
		info_lootspawn = {},
		info_npcspawn = {},
		info_evac = {},
		point_stash = {},
		point_radiation = {},
		prop_physics = {}
	}
	
	for k,v in pairs( enttbl ) do
	
		for c,d in pairs( ents.FindByClass( k ) ) do
		
			if k == "prop_physics" then
			
				if d.AdminPlaced then
				
					local phys = d:GetPhysicsObject()
					
					if IsValid( phys ) then
				
						table.insert( enttbl[k], { d:GetPos(), d:GetModel(), d:GetAngles(), phys:IsMoveable() } )
						
					end
				
				end
			
			elseif d.AdminPlaced then
		
				table.insert( enttbl[k], d:GetPos() )
				
			end
		
		end
		
	end
	
	file.Write( "toxsin/" .. string.lower( game.GetMap() ) .. ".txt", glon.encode( enttbl ) )

end

function GM:LoadAllEnts()

	MsgN( "Loading stored entity data..." )

	local glondry = glon.decode( file.Read( "redead/" .. string.lower( game.GetMap() ) .. ".txt" ) )
	
	if not glondry then return end
	
	for k,v in pairs( glondry ) do
	
		if v[1] then
		
			if k == "prop_physics" then
			
				for c,d in pairs( v ) do
				
					local function spawnent()
					
						local ent = ents.Create( k )
						ent:SetPos( d[1] )
						ent:SetModel( d[2] )
						ent:SetAngles( d[3] )
						ent:SetSkin( math.random( 0, 6 ) )
						ent:Spawn()
						ent.AdminPlaced = true
						
						local phys = ent:GetPhysicsObject()
						
						if IsValid( phys ) and not d[4] then
						
							phys:EnableMotion( false )
						
						end
						
					end
					
					timer.Simple( c * 0.1, spawnent )
					
				end
			
			else
			
				for c,d in pairs( ents.FindByClass( k ) ) do
					
					d:Remove()
					
				end

				for c,d in pairs( v ) do
				
					if k != "point_radiation" and k != "info_lootspawn" then
				
						local function spawnent()
						
							local ent = ents.Create( k )
							ent:SetPos( d )
							ent:Spawn()
							ent.AdminPlaced = true
						
						end
					
						timer.Simple( c * 0.1, spawnent )
						
					else
					
						local ent = ents.Create( k )
						ent:SetPos( d )
						ent:Spawn()
						ent.AdminPlaced = true
				
					end

				end
				
			end
			
		end
		
	end

end

function GM:AddToZombieList( ply ) 

	if team.NumPlayers( TEAM_ZOMBIES ) > 0 then 
	
		ply:Notice( "You cannot volunteer to be the zombie lord", GAMEMODE.Colors.Red, 5 )
	
		return
	
	end

	if not table.HasValue( GAMEMODE.Lords, ply ) then
	
		table.insert( GAMEMODE.Lords, ply )
		
		ply:Notice( "You have volunteered to be the zombie lord", GAMEMODE.Colors.White, 5 )
		
	end

end

function GM:PickLord( force )

	if team.NumPlayers( TEAM_ZOMBIES ) > 0 then return end

	if team.NumPlayers( TEAM_ARMY ) < 8 then return end
	
	if force then
	
		local ply = table.Random( team.GetPlayers( TEAM_ARMY ) )
	
		if #GAMEMODE.Lords > 0 then
			
			local tbl = {}
			
			for k,v in pairs( GAMEMODE.Lords ) do
			
				if IsValid( v ) then
			
					table.insert( tbl, v )
					
				end
			
			end
			
			if tbl[1] then
		
				ply = table.Random( tbl )
				
			end
		
		end
		
		for k,v in pairs( player.GetAll() ) do
		
			v:Notice( "A zombie lord has been randomly chosen", GAMEMODE.Colors.White, 5 )
		
		end
		
		ply:Notice( "You have been chosen to become the zombie lord", GAMEMODE.Colors.White, 5, 1 )
		
		timer.Simple( 6, function() ply:Gib() ply:SetLord( true ) ply:SetTeam( TEAM_ZOMBIES ) end )
		
		return
	
	end

	for k,v in pairs( player.GetAll() ) do
	
		v:Notice( "Press F4 if you want to be the zombie lord", GAMEMODE.Colors.White, 5 )
	
	end

end

function GM:RespawnAntidote()
	
	if IsValid( ents.FindByClass( "sent_antidote" )[1] ) and ents.FindByClass( "sent_antidote" )[1]:CuresLeft() > 0 then return end
	
	if #ents.FindByClass( "info_lootspawn" ) < 3 then return end

	local ent = table.Random( ents.FindByClass( "info_lootspawn" ) )
	local pos = ent:GetPos()
	local close = true
	
	while close do
	
		ent = table.Random( ents.FindByClass( "info_lootspawn" ) )
		pos = ent:GetPos()
		close = false
		
		for k,v in pairs( ents.FindByClass( "sent_antidote" ) ) do
		
			if v:GetPos():Distance( pos ) < 500 then
			
				close = true
			
			end
		
		end
	
	end
	
	local ant = ents.Create( "sent_antidote" )
	ant:SetPos( pos )
	ant:Spawn()
	
	GAMEMODE.Antidote = ant
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		v:Notice( "An antidote resupply has been marked on the radar", GAMEMODE.Colors.White, 5 )
		v:SetRadarStaticTarget( ent )
	
	end

end

function GM:SpawnEvac()

	local pos = Vector(0,0,0)

	if #ents.FindByClass( "info_evac" ) < 1 then
	
		local loot = ents.FindByClass( "info_lootspawn" )
		
		if #loot < 1 then
		
			print( "Your map is not configured for ToxSin, shithead!" )
			
			return
		
		end
		
		local prop = table.Random( loot )
		
		pos = prop:GetPos()
	
	else
	
		local point = table.Random( ents.FindByClass( "info_evac" ) )
		pos = point:GetPos()
	
	end
	
	local evac = ents.Create( "point_evac" )
	evac:SetPos( pos )
	evac:Spawn()
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		v:SetRadarStaticTarget( evac )
	
	end

end

function GM:GetGeneratedLoot()

	local tbl = {}

	for k,v in pairs( GAMEMODE.RandomLoot ) do
	
		if IsValid( v ) then
		
			table.insert( tbl, v )
		
		end
	
	end
	
	for k,v in pairs( GAMEMODE.RandomLoot ) do
	
		if not IsValid( v ) then
		
			table.remove( tbl, k )
			
			return tbl
		
		end
	
	end
	
	return tbl

end

function GM:LootThink()

	for k,v in pairs( ents.FindByClass( "prop_phys*" ) ) do
	
		if v.Removal and v.Removal < CurTime() and IsValid( v ) then
		
			v:Remove()
		
		end
	
	end

	if #ents.FindByClass( "info_lootspawn" ) < 10 then return end

	local amt = math.floor( GAMEMODE.MaxLoot * #ents.FindByClass( "info_lootspawn" ) )
	local total = 0
	
	local loots = GAMEMODE:GetGeneratedLoot()
	
	local num = amt - #loots
	
	if num > 0 then
	
		local tbl = { ITEM_FOOD, ITEM_SUPPLY, ITEM_LOOT, ITEM_AMMO, ITEM_MISC, ITEM_SPECIAL, ITEM_WPN_COMMON, ITEM_WPN_SPECIAL }
		local chancetbl = { 0.95,    0.70,        0.35,      0.60,     0.50,       0.05,           0.02,           0.01 }
		
		for i=1, num do
			
			local ent = table.Random( ents.FindByClass( "info_lootspawn" ) )
			local pos = ent:GetPos()
			local rnd = math.Rand(0,1)
			local choice = math.random( 1, table.Count( tbl ) ) 
				
			while rnd > chancetbl[ choice ] do
					
				rnd = math.Rand(0,1)
				choice = math.random(1,6)
					
			end
				
			local rand = item.RandomItem( tbl[choice] )
			local proptype = "prop_physics"
				
			if rand.TypeOverride then
				
				proptype = rand.TypeOverride
				
			end
				
			local loot = ents.Create( proptype )
			loot:SetPos( pos + Vector(0,0,5) )
			loot:SetModel( rand.Model )
			loot:Spawn()
			loot.RandomLoot = true
			loot.IsItem = true
				
			if not rand.CollisionOverride then
				
				loot:SetCollisionGroup( COLLISION_GROUP_WEAPON )
			
			end
			
			table.insert( GAMEMODE.RandomLoot, loot )
			
		end
	
	end

end

function GM:EventThink()

	if not GAMEMODE.RandomEvent then
	
		GAMEMODE.RandomEvent = CurTime() + ( 60 * math.Rand( 3.5, 6.5 ) )
	
	end
	
	if GAMEMODE.RandomEvent and GAMEMODE.RandomEvent < CurTime() then
		
		local ev = event.GetRandom()
		ev.Start()
	
		GAMEMODE.Event = ev
		GAMEMODE.RandomEvent = nil
	
	end
	
	if GAMEMODE.Event then
	
		GAMEMODE.Event:Think()
		
		if GAMEMODE.Event:EndThink() then
		
			GAMEMODE.Event:End()
			GAMEMODE.Event = nil
		
		end
	
	end

end

function GM:WaveThink()

	if GAMEMODE.NextWave < CurTime() then
	
		GAMEMODE.NextWave = CurTime() + 60 * GetConVar( "sv_redead_wave_length" ):GetInt()
		GAMEMODE.Wave = GAMEMODE.Wave + 1
		
		if GAMEMODE.Wave > #GAMEMODE.Waves then return end
		
		for k,v in pairs( player.GetAll() ) do
		
			v:Notice( "New undead mutations have been spotted", GAMEMODE.Colors.White, 5 )
			v:ClientSound( table.Random( GAMEMODE.AmbientScream ) )
		
		end
	
	end

end

function GM:GetZombieClass()

	local rand = math.Rand(0,1)
	local class = table.Random( GAMEMODE.Waves[ GAMEMODE.Wave ] or { "npc_zombie_common" } )
	
	while #GAMEMODE.Waves[ GAMEMODE.Wave ] != 1 and rand > GAMEMODE.SpawnChance[ class ] do
	
		rand = math.Rand(0,1)
		class = table.Random( GAMEMODE.Waves[ GAMEMODE.Wave ] or { "npc_zombie_common" } )
	
	end
	
	return class

end

function GM:NPCThink()

	if GAMEMODE.Wave > #GAMEMODE.Waves then return end
	
	if #ents.FindByClass( "npc_zombie*" ) < GetConVar( "sv_redead_max_zombies" ):GetInt() and #ents.FindByClass( "npc_zombie*" ) < GetConVar( "sv_redead_zombies_per_player" ):GetInt() * team.NumPlayers( TEAM_ARMY ) then
	
		local total = GetConVar( "sv_redead_zombies_per_player" ):GetInt() * team.NumPlayers( TEAM_ARMY )
		local num = math.Clamp( total, 1, math.Min( GetConVar( "sv_redead_max_zombies" ):GetInt() - #ents.FindByClass( "npc_zombie*" ), total ) )
		
		for i=1, num do
	
			local tbl = ents.FindByClass( "info_npcspawn" )
			
			if #tbl < 1 then return end
			
			local spawn = table.Random( tbl )
			local vec = VectorRand() * 5
			
			vec.z = 1
			
			local ent = ents.Create( GAMEMODE:GetZombieClass() )
			ent:SetPos( spawn:GetPos() + vec )
			ent:Spawn()
			
		end
	
	end

end

function GM:Think()

	if ( GAMEMODE.NextGameThink or 0 ) < CurTime() then

		if GAMEMODE.NextZombieThink < CurTime() then
		
			GAMEMODE:NPCThink()
			
			GAMEMODE.NextZombieThink = CurTime() + GetConVar( "sv_redead_wave_time" ):GetInt()
			
		end
		
		GAMEMODE:RespawnAntidote()
		GAMEMODE:EventThink()
		GAMEMODE:LootThink()
		GAMEMODE:WaveThink()
		GAMEMODE:CheckGameOver( false )
		GAMEMODE.NextGameThink = CurTime() + 1
		
	end

	for k,v in pairs( player.GetAll() ) do
	
		if v:Team() != TEAM_UNASSIGNED then
		
			v:Think()
		
		end
	
	end

end

function GM:PhysgunPickup( ply, ent )

	if ply:IsAdmin() or ply:IsSuperAdmin() then return true end

	if ent:IsPlayer() then return false end
	
	if not ent.Placer or ent.Placer != ply then return false end
	
	return true 

end

function GM:PlayerDisconnected( pl )

	if pl:Alive() then
	
		pl:DropLoot()
		
	end
	
	if not table.HasValue( GAMEMODE.PlayerIDs, pl:SteamID() ) then
	
		table.insert( GAMEMODE.PlayerIDs, pl:SteamID() )
	
	end
	
end

function GM:PlayerInitialSpawn( pl )

	if table.HasValue( GAMEMODE.PlayerIDs, pl:SteamID() ) then
	
		pl:SetTeam( TEAM_ZOMBIES )
	
	elseif pl:IsBot() then
	
		pl:SetTeam( TEAM_ARMY )
		pl:Spawn()
	
	else
	
		pl:SetTeam( TEAM_UNASSIGNED )
		pl:Spectate( OBS_MODE_ROAMING )
		pl:ClientSound( table.Random( GAMEMODE.OpeningMusic ) )
		
	end
	
end

function GM:PlayerSpawn( pl )

	if pl:Team() == TEAM_UNASSIGNED then
	
		pl:Spectate( OBS_MODE_ROAMING )
		pl:SetPos( pl:GetPos() + Vector( 0, 0, 50 ) )
		
		return
		
	end
	
	GAMEMODE:RespawnAntidote()
	
	pl:NoticeOnce( "Press F1 to view the help menu", GAMEMODE.Colors.Blue, 5, 15 )
	pl:NoticeOnce( "Press F2 to buy items and weapons", GAMEMODE.Colors.Blue, 5, 17 )
	pl:NoticeOnce( "Press F3 to activate the panic button", GAMEMODE.Colors.Blue, 5, 19 )
	pl:SetRadarStaticTarget( GAMEMODE.Antidote or NULL )
	pl:InitializeInventory()
	pl:OnSpawn()
	pl:OnLoadout()

end

function GM:PlayerSetModel( pl )

end

function GM:PlayerLoadout( pl )
	
end

function GM:PlayerJoinTeam( ply, teamid )
	
	local oldteam = ply:Team()
	
	if ply:Alive() and ply:Team() != TEAM_UNASSIGNED then return end
	
	if teamid != TEAM_UNASSIGNED and ply:Team() == TEAM_UNASSIGNED then
	
		ply:UnSpectate()
	
	end
	
	if teamid == TEAM_SPECTATOR or teamid == TEAM_UNASSIGNED then
	
		teamid = TEAM_ARMY
	
	end
	
	ply:SetTeam( teamid )
	
	if ply.NextSpawn and ply.NextSpawn > CurTime() then
	
		ply.NextSpawn = CurTime() + 5
	
	else
	
		ply:Spawn()
	
	end
	
end

function GM:PlayerSwitchFlashlight( ply, on )

	return ply:Team() == TEAM_ARMY
	
end

function GM:GetFallDamage( ply, speed )

	if ply:Team() == TEAM_ZOMBIES then
	
		return 5
	
	end

	local pain = speed * 0.12
	
	ply:AddStamina( math.floor( pain * -0.25 ) )

	return pain
	
end

function GM:PlayerDeathSound()

	return true
	
end

function GM:CanPlayerSuicide( ply )

	return false
	
end

function GM:KeyRelease( ply, key )

	if ply:Team() != TEAM_ARMY then return end

	if key == IN_JUMP then
	
		ply:AddStamina( -2 )
	
	end
	
	if key != IN_USE then return end
	
	local trace = {}
    trace.start = ply:GetShootPos()
    trace.endpos = trace.start + ply:GetAimVector() * 80
    trace.filter = ply
	
	local tr = util.TraceLine( trace )
	
	if IsValid( tr.Entity ) and tr.Entity:GetClass() == "prop_physics" then
        
        if IsValid( ply.Stash ) then
            
            ply.Stash:OnExit( ply )
            
			return true
            
        end
        
        ply:AddToInventory( tr.Entity )
	
		return true
        
    elseif IsValid( tr.Entity ) and tr.Entity:GetClass() == "point_stash" then
        
        if IsValid( ply.Stash ) then
            
            ply.Stash:OnExit( ply )
            
        else
           
            tr.Entity:OnUsed( ply )
            
        end
        
    elseif not IsValid( tr.Entity ) then
        
        if IsValid( ply.Stash ) then
            
            ply.Stash:OnExit( ply )
            
        end
        
    end
    
	return true

end

function GM:PropBreak( att, prop )

	local phys = prop:GetPhysicsObject()
	
	if IsValid( phys ) and prop:GetModel() != "models/props_debris/wood_board04a.mdl" then
	
		if table.HasValue( { "wood", "wood_crate", "wood_furniture", "default" }, phys:GetMaterial() ) and phys:GetMass() > 8 then
		
			local ent = ents.Create( "prop_physics" )
			ent:SetPos( prop:LocalToWorld( prop:OBBCenter() ) )
			ent:SetModel( "models/props_debris/wood_chunk04a.mdl" )
			ent:Spawn()
			ent.IsItem = true
		
		end
	
	end

end 

function GM:AllowPlayerPickup( ply, ent )

	local tbl = item.GetByModel( ent:GetModel() )
	
	if tbl and tbl.AllowPickup then
	
		return true
	
	elseif not tbl then
	
		return true
		
	end

	return false
	
end

function GM:PlayerUse( ply, entity )

	if ply:Team() == TEAM_ARMY and ( ply.LastUse or 0 ) < CurTime() then
	
		if table.HasValue( { "sent_propane_canister", "sent_propane_tank", "sent_fuel_diesel", "sent_fuel_gas" }, entity:GetClass() ) then 
		
			ply.LastUse = CurTime() + 0.5
		
			if not IsValid( ply.HeldObject ) and not IsValid( entity.Holder ) then 
	
				ply:PickupObject( entity )
				ply.HeldObject = entity
				entity.Holder = ply
				
			elseif entity == ply.HeldObject then 
			
				ply:DropObject( entity )
				ply.HeldObject = nil
				entity.Holder = nil
			
			end
	
		end
	
	end
	
	if ply:Team() != TEAM_ZOMBIES then return true end
	
	local trace = {}
    trace.start = ply:GetShootPos()
    trace.endpos = trace.start + ply:GetAimVector() * 80
    trace.filter = ply
	
	local tr = util.TraceLine( trace )
	
	if entity:GetClass() == "prop_door_rotating" or entity:GetClass() == "func_button" then

		return false
		
	end
	
	return true
	
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	if ent:GetClass() == "prop_physics" and ent:IsOnFire() then
	
		ent:Extinguish()
	
	end

	if not ent:IsPlayer() and ent.IsItem then 

		dmginfo:ScaleDamage( 0 )
		
		return
		
	end
	
	if ent:IsPlayer() and ent:Team() == TEAM_ARMY and IsValid( attacker ) and ( attacker:IsNPC() or ( ( attacker:IsPlayer() and attacker:Team() == TEAM_ZOMBIES ) or ( attacker:IsPlayer() and attacker == ent ) ) ) then
	
		if dmginfo:IsDamageType( DMG_BURN ) then
	
			ent:ViewBounce( 30 )
			
		else
		
			ent:ViewBounce( 25 )
			ent:VoiceSound( table.Random( GAMEMODE.Pain ) )
			ent:DrawBlood()
			
			if math.random(1,3) == 1 then
			
				ent:RadioSound( VO_PAIN )
			
			end
		
		end
		
		if ent:GetPlayerClass() == CLASS_COMMANDO then
		
			dmginfo:ScaleDamage( GetConVar( "sv_redead_dmg_scale" ):GetFloat() * 0.8 )
		
		else
		
			dmginfo:ScaleDamage( GetConVar( "sv_redead_dmg_scale" ):GetFloat() ) 
		
		end
		
		if dmginfo:IsExplosionDamage() and attacker:Team() == TEAM_ZOMBIES then
	
			dmginfo:ScaleDamage( 0 )
	
		else
		
			ent:AddStat( "Damage", math.Round( dmginfo:GetDamage() ) )
			
			if attacker:IsPlayer() then
			
				attacker:AddZedDamage( math.Round( dmginfo:GetDamage() ) )
				
			end
		
		end
		
	end
	
	return self.BaseClass:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )
	
end

function GM:ScaleNPCDamage( npc, hitgroup, dmginfo )

	if dmginfo:IsExplosionDamage() then
	
		dmginfo:ScaleDamage( 1.25 )
	
	end

	if hitgroup == HITGROUP_HEAD then
	
		npc:EmitSound( "Player.DamageHeadShot" )
		npc:SetHeadshotter( dmginfo:GetAttacker(), true )
		
		local effectdata = EffectData()
		effectdata:SetOrigin( dmginfo:GetDamagePosition() )
		util.Effect( "headshot", effectdata, true, true )
	
		dmginfo:ScaleDamage( math.Rand( 2.50, 3.00 ) ) 
		dmginfo:GetAttacker():NoticeOnce( "Headshot combos earn you more " .. GAMEMODE.CurrencyName .. "s", GAMEMODE.Colors.Blue, 5 )
		dmginfo:GetAttacker():AddHeadshot()
		
    elseif hitgroup == HITGROUP_CHEST then
	
		dmginfo:ScaleDamage( 1.25 ) 
		
		npc:SetHeadshotter( dmginfo:GetAttacker(), false )
		dmginfo:GetAttacker():ResetHeadshots()
		
	elseif hitgroup == HITGROUP_STOMACH then
	
		dmginfo:ScaleDamage( 0.75 ) 
		
		npc:SetHeadshotter( dmginfo:GetAttacker(), false )
		dmginfo:GetAttacker():ResetHeadshots()
		
	else
	
		dmginfo:ScaleDamage( 0.50 )
		
		npc:SetHeadshotter( dmginfo:GetAttacker(), false )
		dmginfo:GetAttacker():ResetHeadshots()
		
	end
	
	return dmginfo

end 

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	if IsValid( ply.Stash ) then
	
		dmginfo:ScaleDamage( 0.25 )
		
		return
	
	end

	if hitgroup == HITGROUP_HEAD then
	
		ply:EmitSound( "Player.DamageHeadShot" )
		ply:ViewBounce( 25 )
		
		dmginfo:ScaleDamage( 1.75 * GetConVar( "sv_redead_dmg_scale" ):GetFloat() ) 
		
		return
		
    elseif hitgroup == HITGROUP_CHEST then
	
		ply:ViewBounce( 15 )
	
		dmginfo:ScaleDamage( 0.50 * GetConVar( "sv_redead_dmg_scale" ):GetFloat() ) 
		
		return
		
	elseif hitgroup == HITGROUP_STOMACH then
	
		dmginfo:ScaleDamage( 0.25 * GetConVar( "sv_redead_dmg_scale" ):GetFloat() ) 
		
	else
	
		dmginfo:ScaleDamage( 0.10 * GetConVar( "sv_redead_dmg_scale" ):GetFloat() )
		
	end
	
	ply:ViewBounce( ( dmginfo:GetDamage() / 20 ) * 10 )

end 

function GM:PlayerShouldTakeDamage( ply, attacker )

	if ply:Team() == TEAM_UNASSIGNED then return false end
	
	if IsValid( attacker ) and attacker:IsPlayer() and attacker != ply then
	
		return ( ply:Team() != attacker:Team() or GetConVar( "sv_redead_team_dmg" ):GetBool() ) 
	
	end

	return true
	
end

function GM:OnDamagedByExplosion( ply, dmginfo )

	ply:SetBleeding( true )

	ply:SetDSP( 35, false )
	
	umsg.Start( "GrenadeHit", ply )
	umsg.End()
	
end

function GM:PlayerDeathThink( pl )

	if pl.NextSpawn and pl.NextSpawn > CurTime() then return end
	
	if pl:KeyDown( IN_JUMP ) or pl:KeyDown( IN_ATTACK ) or pl:KeyDown( IN_ATTACK2 ) then

		pl:Spawn()
		
	end
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	ply:OnDeath()
	ply:CreateRagdoll()

	if ply:Team() == TEAM_ARMY then
	
		if team.NumPlayers( TEAM_ZOMBIES ) < 1 then
		
			ply:AddStat( "Martyr" )
		
		end
	
		ply:VoiceSound( table.Random( GAMEMODE.Death ) )
		ply:ClientSound( table.Random( GAMEMODE.DeathMusic ) )
		ply:SetTeam( TEAM_ZOMBIES )
		
		if IsValid( attacker ) and attacker:IsPlayer() and attacker != ply then
		
			attacker:AddStat( "ZedKills" )
			attacker:AddZedDamage( 50 )
		
		end
	
	elseif ply:Team() == TEAM_ZOMBIES then

		if IsValid( attacker ) and attacker:IsPlayer() then
	
			attacker:AddCash( 2 )
			attacker:AddFrags( 1 )
			
		end
		
		if ply:IsLord() and ply:GetZedDamage() >= GAMEMODE.RedemptionDamage then
		
			ply:SetTeam( TEAM_ARMY )
			ply:Notice( "Prepare to respawn as a human", GAMEMODE.Colors.Blue, 5, 2 )
		
		end
	
	end

	if dmginfo:IsExplosionDamage() then
	
		ply:SetModel( table.Random( GAMEMODE.Corpses ) )
		
		local ed = EffectData()
		ed:SetOrigin( ply:GetPos() )
		util.Effect( "gore_explosion", ed, true, true )
	
	end
	
end

function GM:SynchStats()

	net.Start( "StatsSynch" )
	net.WriteInt( table.Count( player.GetAll() ), 8 )

	for k,v in pairs( player.GetAll() ) do
	
		net.WriteEntity( v )
		net.WriteTable( v:GetStats() )
	
	end
	
	net.Broadcast()

end

function GM:EndGame( winner )

	GAMEMODE:SynchStats()

	SetGlobalBool( "GameOver", true )
	SetGlobalInt( "WinningTeam", winner )
	
	for k,v in pairs( player.GetAll() ) do
	
		if winner == TEAM_ZOMBIES then
		
			v:NoticeOnce( "The undead have overwhelmed " .. team.GetName( TEAM_ARMY ) , GAMEMODE.Colors.White, 5, 2 )
		
		elseif team.NumPlayers( TEAM_ARMY ) > 0 then
		
			v:NoticeOnce( team.GetName( TEAM_ARMY ) .. " has successfully evacuated", GAMEMODE.Colors.White, 5, 2 )
		
		end
	
		if v:Team() == winner and winner == TEAM_ARMY then
		
			v:ClientSound( table.Random( GAMEMODE.WinMusic ) )
			v:GodEnable()
			
		else
		
			v:ClientSound( table.Random( GAMEMODE.LoseMusic ) )
			
		end
		
		v:NoticeOnce( "Next map: " .. game.GetMapNext() , GAMEMODE.Colors.White, 3, 4 )
	
	end
	
	timer.Simple( 45, function() game.LoadNextMap() end )

end

function GM:CheckGameOver( canend )

	if GetGlobalBool( "GameOver", false ) then return end

	if team.NumPlayers( TEAM_ARMY ) < 1 and team.NumPlayers( TEAM_ZOMBIES ) > 0 then
	
		GAMEMODE:EndGame( TEAM_ZOMBIES )
	
	elseif GAMEMODE.Wave > #GAMEMODE.Waves and canend then
	
		for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		
			if not v:IsEvacuated() then
			
				v:Notice( "The evac chopper left without you", GAMEMODE.Colors.Red, 5 )
				v:SetTeam( TEAM_ZOMBIES )
			 
			end
		
		end
	
		GAMEMODE:EndGame( TEAM_ARMY )
	
	end

end

function GM:ShowHelp( ply )

	//ply:SendLua( "GAMEMODE:ShowHelp()" ) - obsolete?

end

function GM:ShowTeam( ply )

	if ply:Team() == TEAM_ZOMBIES then
	
		ply:SendLua( "GAMEMODE:ShowZombieClasses()" )
		
		return
	
	end
	
	if not ply:Alive() then return end
	
	if ply:IsIndoors() then
	
		ply:Notice( "You cannot use your radio indoors", GAMEMODE.Colors.Red )
	
	else
	
		if ply:GetPlayerClass() == CLASS_SPECIALIST then
	
			if IsValid( ply.Stash ) then
			
				GAMEMODE.SpecialTrader:OnExit( ply )
			
			else
		
				GAMEMODE.SpecialTrader:OnUsed( ply )
				
			end
			
		else
		
			if IsValid( ply.Stash ) then
			
				GAMEMODE.Trader:OnExit( ply )
			
			else
		
				GAMEMODE.Trader:OnUsed( ply )
				
			end
		
		end
	
	end

end

function GM:ShowSpare1( ply )

	GAMEMODE:PanicButton( ply )

end

function GM:ShowSpare2( ply )

	GAMEMODE:AddToZombieList( ply )

end

function GM:PanicButton( ply )

	if ( ply.Panic or 0 ) > CurTime() or ply:Team() == TEAM_ZOMBIES then return end
	
	ply.Panic = CurTime() + 0.5

	local panic = { { ply:IsBleeding(), { "Bandage" }, "bleeding" },
	{ ply:GetRadiation() > 0, { "Vodka", "Moonshine Vodka", "Anti-Rad" }, "irradiated" },
	{ ply:Health() < 50, { "Advanced Medikit", "Basic Medikit", "Canned Meat" }, "severely wounded" },
	{ ply:Health() < 100, { "Basic Medikit", "Canned Meat" }, "wounded" },
	{ ply:GetStamina() < 20, { "Energy Drink" }, "exhausted" },
	{ ply:GetStamina() < 50, { "Water" }, "fatigued" } }

	for k,v in pairs( panic ) do
	
		if v[1] then
		
			for c,d in pairs( v[2] ) do
			
				local tbl = item.GetByName( d )
			
				if tbl and ply:HasItem( tbl.ID ) then
                
					tbl.Functions[ 1 ]( ply, tbl.ID )
					
					ply:Notice( "Panic button detected that you were " .. v[3], GAMEMODE.Colors.Blue )
					
					return

				end
			
			end
		
		end
	
	end
	
	ply:Notice( "Panic button didn't detect any ailments", GAMEMODE.Colors.Red )
	ply:ClientSound( "items/suitchargeno1.wav" )

end

function DropItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = math.Clamp( tonumber( args[2] ), 1, 100 )
	
	if not ply:HasItem( id ) then return end
	
	local tbl = item.GetByID( id )
	
	if count == 1 then
	
		if ply:HasItem( id ) then
		
			local makeprop = true
		
			if tbl.DropFunction then
			
				makeprop = tbl.DropFunction( ply, id, true )
			
			end
			
			if makeprop then
		
				local prop = ents.Create( "prop_physics" )
				prop:SetPos( ply:GetItemDropPos() )
				prop:SetAngles( ply:GetAimVector():Angle() )
				prop:SetModel( tbl.Model ) 
				prop:SetCollisionGroup( COLLISION_GROUP_WEAPON )
				prop:Spawn()
				prop.IsItem = true
				prop.Removal = CurTime() + 5 * 60
				
			end
			
			ply:RemoveFromInventory( id, true )
			ply:EmitSound( Sound( "items/ammopickup.wav" ) )
		
		end
		
		return
	
	end
	
	local items = {}
	local itemcount = math.min( ply:GetItemCount( id ), count )
	local loot = ents.Create( "sent_lootbag" )
	
	for i=1, itemcount do
	
		loot:AddItem( v )
	
	end
	
	loot:SetAngles( ply:GetAimVector():Angle() )
	loot:SetPos( ply:GetItemDropPos() )
	loot:SetRemoval( 60 * 5 )
	loot:Spawn()
	
	ply:EmitSound( Sound( "items/ammopickup.wav" ) )
	ply:RemoveMultipleFromInventory( items )
	
	if tbl.DropFunction then
		
		tbl.DropFunction( ply, id )
		
	end

end

concommand.Add( "inv_drop", DropItem )

function UseItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local pos = tonumber( args[2] )
	
	if ply:HasItem( id ) then
	
		local tbl = item.GetByID( id )
		
		if not tbl.Functions[pos] then return end
		
		tbl.Functions[pos]( ply, id )
	
	end

end

concommand.Add( "inv_action", UseItem )

function TakeItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = math.Clamp( tonumber( args[2] ), 1, 100 )
	
	if not IsValid( ply.Stash ) or not table.HasValue( ply.Stash:GetItems(), id ) or string.find( ply.Stash:GetClass(), "npc" ) then return end
	
	local tbl = item.GetByID( id )
	
	if count == 1 then
		
		ply:AddIDToInventory( id )
		ply.Stash:RemoveItem( id )
		
		return
	
	end
	
	local items = {}
	
	if IsValid( ply.Stash ) then
	
		for i=1, count do
	
			if table.HasValue( ply.Stash:GetItems(), id ) then
			
				table.insert( items, id )
				ply.Stash:RemoveItem( id )
			
			end
			
		end
		
		ply:AddMultipleToInventory( items )
		ply:EmitSound( Sound( "items/itempickup.wav" ) )
	
	end

end

concommand.Add( "inv_take", TakeItem )

function StoreItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = math.Clamp( tonumber( args[2] ), 1, 100 )
	
	if not IsValid( ply.Stash ) or not ply:HasItem( id ) then return end
	
	local tbl = item.GetByID( id )
	
	if count == 1 then

		ply.Stash:AddItem( id )
		
		ply:RemoveFromInventory( id )
		ply:EmitSound( Sound( "c4.disarmfinish" ) )
		
		if tbl.DropFunction then
			
			tbl.DropFunction( ply, id )
			
		end
		
		return
	
	end
	
	local items = {}
	
	for i=1, count do
	
		if ply:HasItem( id ) then
	
			table.insert( items, id )
			ply.Stash:AddItem( id )
			
		end
	
	end
	
	ply:RemoveMultipleFromInventory( items )
	ply:EmitSound( Sound( "c4.disarmfinish" ) )
	
	if tbl.DropFunction then
		
		tbl.DropFunction( ply, id )
		
	end

end

concommand.Add( "inv_store", StoreItem )

function SellItem( ply, cmd, args )

	if IsValid( ply ) then return end

	local id = tonumber( args[1] )
	local count = math.Clamp( tonumber( args[2] ), 1, 100 )
	
	if not IsValid( ply.Stash ) or not string.find( ply.Stash:GetClass(), "npc" ) or not ply:HasItem( id ) then return end
	
	local tbl = item.GetByID( id )
	local cash = math.Round( ply.Stash:GetBuybackScale() * tbl.Price )
	
	if count == 1 then
	
		ply:RemoveFromInventory( id )
		ply:AddCash( cash )
		
		if tbl.DropFunction then
			
			tbl.DropFunction( ply, id )
			
		end
		
		return
	
	end
	
	local items = {}
	local cashamt = 0
	
	for i=1, math.Clamp( count, 1, ply:GetItemCount( id ) ) do
	
		if ply:HasItem( id ) then
			
			table.insert( items, id )
			cashamt = cashamt + cash
			
		end
	
	end
	
	ply:AddCash( cashamt )
	ply:RemoveMultipleFromInventory( items )
	
	if tbl.DropFunction then
		
		tbl.DropFunction( ply, id )
		
	end

end

concommand.Add( "inv_sell", SellItem )

function OrderShipment( ply, cmd, args )

	ply:SendShipment()

end

concommand.Add( "ordershipment", OrderShipment )

function BuyItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = tonumber( args[2] )
	
	if not IsValid( ply.Stash ) or not ply.Stash:GetClass() == "info_trader" or not table.HasValue( ply.Stash:GetItems(), id ) or count < 0 then return end
	
	local tbl = item.GetByID( id )
	
	if tbl.Price > ply:GetCash() then 
		
		return 
		
	end 
	
	if tbl.Price > ply:GetStat( "Pricey" ) then
	
		ply:SetStat( "Pricey", tbl.Price )
	
	end
	
	if count == 1 then
		
		ply:AddToShipment( { id } )
		ply:AddCash( -tbl.Price )
		
		return
	
	end
	
	if ( tbl.Price * count ) > ply:GetCash() then 
		
		return 
		
	end 
	
	local items = {}
	
	for i=1, count do
		
		table.insert( items, id )
	
	end
	
	ply:AddToShipment( items )
	ply:AddCash( -tbl.Price * count )
	
end

concommand.Add( "inv_buy", BuyItem )

function DropCash( ply, cmd, args )

	local amt = tonumber( args[1] )
	
	if amt > ply:GetCash() or amt < 5 then return end
	
	ply:AddCash( -amt )
	
	local money = ents.Create( "sent_cash" )
	money:SetPos( ply:GetItemDropPos() )
	money:Spawn()
	money:SetCash( amt )

end

concommand.Add( "cash_drop", DropCash )

function StashCash( ply, cmd, args )

	local amt = tonumber( args[1] )
	
	if not IsValid( ply.Stash ) or amt > ply:GetCash() or amt < 5 or string.find( ply.Stash:GetClass(), "npc" ) then return end
	
	ply:AddCash( -amt )
	ply:SynchCash( ply.Stash:GetCash() + amt )
	ply.Stash:SetCash( ply.Stash:GetCash() + amt )

end

concommand.Add( "cash_stash", StashCash )

function TakeCash( ply, cmd, args )

	local amt = tonumber( args[1] )
	
	if not IsValid( ply.Stash ) or amt > ply.Stash:GetCash() or amt < 5 or string.find( ply.Stash:GetClass(), "npc" ) then return end
	
	ply:AddCash( amt )
	ply:SynchCash( ply.Stash:GetCash() - amt )
	ply.Stash:SetCash( ply.Stash:GetCash() - amt )

end

concommand.Add( "cash_take", TakeCash )

function SetPlyClass( ply, cmd, args )

	local class = tonumber( args[1] )
	
	if not GAMEMODE.ClassLogos[ class ] then return end
	
	if ply:Team() == TEAM_ARMY then return end
	
	if ply:Team() == TEAM_ZOMBIES then
	
		ply.NextClass = class
		
	else
	
		ply:SetPlayerClass( class )
	
	end
	
end

concommand.Add( "changeclass", SetPlyClass )

function SaveGameItems( ply, cmd, args )

	if ( !ply:IsAdmin() or !ply:IsSuperAdmin() ) then return end
	
	GAMEMODE:SaveAllEnts()
	
end

concommand.Add( "sv_redead_save_map_config", SaveGameItems )

function MapSetupMode( ply, cmd, args )

	if not IsValid( ply ) then 
	
		for k, ply in pairs( player.GetAll() ) do
		
			if ply:IsAdmin() or ply:IsSuperAdmin() then
	
				ply:Give( "rad_itemplacer" )
				ply:Give( "rad_propplacer" )
				ply:Give( "weapon_physgun" )
			
			end
		
		end
		
		return
		
	end

	if ply:IsAdmin() or ply:IsSuperAdmin() then
	
		ply:Give( "rad_itemplacer" )
		ply:Give( "rad_propplacer" )
		ply:Give( "weapon_physgun" )
	
	end

end

concommand.Add( "sv_redead_dev_mode", MapSetupMode )

function ItemListing( ply, cmd, args )

	if IsValid( ply ) and ply:IsAdmin() then
	
		local itemlist = item.GetList()
		
		for k,v in pairs( itemlist ) do
		
			print( v.ID .. ": " .. v.Name )
		
		end
	
	end

end

concommand.Add( "sv_redead_dev_itemlist", ItemListing )

function TestItem( ply, cmd, args )

	if IsValid( ply ) and ply:IsAdmin() then
	
		local id = tonumber( args[1] )
		local tbl = item.GetByID( id )
		
		if tbl then
		
			ply:AddIDToInventory( id )
		
		end
	
	end

end

concommand.Add( "sv_redead_dev_give", TestItem )