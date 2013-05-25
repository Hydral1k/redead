
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

TEAM_ARMY = 1
TEAM_ZOMBIES = 2

function GM:CreateTeams()
	
	team.SetUp( TEAM_ARMY, GAMEMODE.ArmyTeamName, Color( 80, 80, 255 ), true )
	team.SetSpawnPoint( TEAM_ARMY, "info_player_army" ) 
	
	team.SetUp( TEAM_ZOMBIES, GAMEMODE.ZombieTeamName, Color( 255, 80, 80 ), true )
	team.SetSpawnPoint( TEAM_ZOMBIES, "info_player_zombie" ) 

end

function GM:Move( ply, mv )

	if ply:Team() == TEAM_ARMY then

		--[[if ply:GetNWFloat( "Weight", 0 ) > GAMEMODE.MaxWeight then
		
			local scale = 1 - ( math.Clamp( ply:GetNWFloat( "Weight", 0 ), GAMEMODE.MaxWeight, GAMEMODE.WeightCap ) - GAMEMODE.MaxWeight ) / ( GAMEMODE.WeightCap - GAMEMODE.MaxWeight )
			
			mv:SetMaxSpeed( 100 + math.Round( scale * 100 ) )
			
			return self.BaseClass:Move( ply, mv )
			
		end]]
		
		if ply:GetNWFloat( "Stamina", 0 ) <= 5 then
		
			mv:SetMaxSpeed( 110 )
		
		end
	
	elseif ply:GetModel() == "models/zombie/fast.mdl" or ply:GetModel() == "models/player/zombie_classic.mdl" then
	
		mv:SetSideSpeed( 0 )
	
	end
	
	return self.BaseClass:Move( ply, mv )

end

function GM:PlayerNoClip( pl, on )
	
	if ( game.SinglePlayer() ) then return true end
	
	if pl:IsAdmin() or pl:IsSuperAdmin() then return true end
	
	return false
	
end

// this is fucking up player anims

--[[function GM:CalcMainActivity( ply, vel )

	if ply:Team() == TEAM_ZOMBIES and ply:GetModel() == "models/zombie/fast.mdl" then
	
		local act = ACT_IDLE
		
		if ply:GetVelocity():Length() > 0 then

			act = ACT_RUN

		end
		
		if not ply:OnGround() then

			act = ACT_JUMP //ACT_MELEE_ATTACK1

		end

		return act, -1
	
	end

    self.BaseClass:CalcMainActivity( ply, vel )
	
end

function GM:UpdateAnimation( ply, vel, speed )

	if ply:Team() == TEAM_ZOMBIES and ply:GetModel() == "models/zombie/fast.mdl" then

		if CLIENT then

			if ply:GetPoseParameter( "aim_yaw" ) == 0 then

				local ang = ply:EyeAngles()

				ply:SetRenderAngles( ang )

			end

		end
		
		if ply:OnGround() then

			if ply:KeyDown( IN_BACK ) then

				ply:SetPlaybackRate( -1.0 )

			else

				ply:SetPlaybackRate( 1.0 )

			end

		else

			ply:SetPlaybackRate( 0.2 )

		end
		
		if ply:GetVelocity():Length() > 0 then return end
		
	end

	self.BaseClass:UpdateAnimation( ply, vel, speed )

end]] 

function IncludeItems()
	
	local folder = string.Replace( GM.Folder, "gamemodes/", "" )

	for c,d in pairs( file.Find( folder.."/gamemode/items/*.lua", "LUA" ) ) do 
	
		include( folder.."/gamemode/items/"..d )
		
		if SERVER then
		
			AddCSLuaFile( folder.."/gamemode/items/"..d )
			
		end
		
	end

end

IncludeItems()

function IncludeEvents()
	
	local folder = string.Replace( GM.Folder, "gamemodes/", "" )

	for c,d in pairs( file.Find( folder.."/gamemode/events/*.lua", "LUA" ) ) do 
	
		if SERVER then
	
			include( folder.."/gamemode/events/"..d )
			
		end
		
	end

end

IncludeEvents()