
local EVENT = {}

EVENT.Chance = 0.75
EVENT.Type = EVENT_BONUS

function EVENT:Start()
	
	local spawns = ents.FindByClass( "info_evac" )
	local evac = table.Random( spawns )
	
	local ent = ents.Create( "npc_scientist" )
	ent:SetPos( evac:GetPos() + Vector(0,0,10) )
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
