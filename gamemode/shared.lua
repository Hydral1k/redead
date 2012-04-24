
GM.Name 		= "ReDead"  
GM.Author 		= "twoski"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= true

CreateConVar( "sv_redead_max_zombies", "45", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls the amount of zombie NPCs that can be spawned at any time. (def 45)" )
CreateConVar( "sv_redead_zombies_per_player", "5", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls the amount of zombie NPCs that spawn per player. (def 5)" )
CreateConVar( "sv_redead_wave_length", "4", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls how long each wave is. (def 4 minutes)" )
CreateConVar( "sv_redead_wave_time", "25", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls the delay between zombie group spawning. (def 25 seconds)" )
CreateConVar( "sv_redead_team_dmg", "0", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether teammates can hurt eachother. (def 0)" )
CreateConVar( "sv_redead_dmg_scale", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls bullet damage scaling. (def 1.0)" )

function GM:CreateTeams()
	
	team.SetUp( TEAM_ARMY, GAMEMODE.ArmyTeamName, Color( 80, 80, 255 ), true )
	team.SetSpawnPoint( TEAM_ARMY, "info_player_army" ) 
	
	team.SetUp( TEAM_ZOMBIES, GAMEMODE.ZombieTeamName, Color( 255, 80, 80 ), true )
	team.SetSpawnPoint( TEAM_ZOMBIES, "info_player_zombie" ) 

end

function GM:Move( ply, mv )

	if ply:Team() == TEAM_ARMY then

		if ply:GetNWFloat( "Weight", 0 ) > GAMEMODE.MaxWeight then
		
			local scale = 1 - ( math.Clamp( ply:GetNWFloat( "Weight", 0 ), GAMEMODE.MaxWeight, GAMEMODE.WeightCap ) - GAMEMODE.MaxWeight ) / ( GAMEMODE.WeightCap - GAMEMODE.MaxWeight )
			
			mv:SetMaxSpeed( 100 + math.Round( scale * 100 ) )
			
			return self.BaseClass:Move( ply, mv )
			
		end
		
		if ply:GetNWFloat( "Stamina", 0 ) < 5 then
		
			mv:SetMaxSpeed( 110 )
		
		end
	
	end
	
	return self.BaseClass:Move( ply, mv )

end

function GM:PlayerNoClip( pl, on )
	
	if ( SinglePlayer() ) then return true end
	
	if pl:IsAdmin() or pl:IsSuperAdmin() then return true end
	
	return false
	
end

function IncludeItems()
	
	local folder = string.Replace( GM.Folder, "gamemodes/", "" )

	for c,d in pairs( file.Find( folder.."/gamemode/items/*.lua", LUA_PATH ) ) do 
	
		include( folder.."/gamemode/items/"..d )
		
		if SERVER then
		
			AddCSLuaFile( folder.."/gamemode/items/"..d )
			
		end
		
	end

end

IncludeItems()