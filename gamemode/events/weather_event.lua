
local EVENT = {}

EVENT.Chance = 0.95
EVENT.Type = EVENT_WEATHER

EVENT.Types = {}
EVENT.Types[1] = "rain"
EVENT.Types[2] = "thunder"
EVENT.Types[3] = "lightning"
EVENT.Types[4] = "strong winds"

function EVENT:Start()

	GAMEMODE:RandomizeWeather( true )
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		
		v:Notice( "The weather conditions are worsening", GAMEMODE.Colors.White, 5 )
		
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
