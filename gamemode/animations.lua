
function GM:UpdateAnimation( ply, velocity, maxseqgroundspeed )

	if ply:Team() == TEAM_UNASSIGNED then return end

	player_manager.RunClass( ply, "UpdateAnimation", velocity, maxseqgroundspeed )
	
end

function GM:CalcMainActivity( ply, velocity )

	if ply:Team() == TEAM_UNASSIGNED then return end

	return player_manager.RunClass( ply, "CalcMainActivity", velocity )
	
end

function GM:TranslateActivity( ply, act )

	if ply:Team() == TEAM_UNASSIGNED then return end

	return player_manager.RunClass( ply, "TranslateActivity", act )
	
end

function GM:DoAnimationEvent( ply, event, data )

	if ply:Team() == TEAM_UNASSIGNED then return end

	return player_manager.RunClass( ply, "DoAnimationEvent", event, data )
	
end