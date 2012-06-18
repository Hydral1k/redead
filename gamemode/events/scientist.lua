
local EVENT = {}

function EVENT:Start()
	
	local evac = table.Random( ents.FindByClass( "point_evac" ) )
	
	local ent = ents.Create( "npc_scientist" )
	ent:SetPos( evac:GetPos() )
	ent:Spawn()
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		
		v:Notice( "A surviving field researcher has been sighted", GAMEMODE.Colors.White, 5 )
		
	end
	
end
	
function EVENT:Think()

end

function EVENT:EndThink()

	return true // true ends this immediately

end

function EVENT:End()

end

event.Register( EVENT )
