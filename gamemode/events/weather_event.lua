
local EVENT = {}

EVENT.Type = EVENT_WEATHER

EVENT.Types = {}
EVENT.Types[1] = "rain"
EVENT.Types[2] = "thunder"
EVENT.Types[3] = "lightning"
EVENT.Types[4] = "wind"

function EVENT:Start()

	local tbl = GAMEMODE:RandomizeWeather( true )
	local tbl2 = {}
	local str = ""
	
	for k,v in pairs( tbl ) do
	
		if v > 0 then
		
			table.insert( tbl2, EVENT.Types[k] )
		
		end
	
	end

	if table.Count( tbl2 ) > 1 then
	
		for k,v in pairs( tbl2 ) do
		
			if k < table.Count( tbl2 ) - 1 then
		
				str = str .. v .. ", "
				
			elseif k == table.Count( tbl2 ) then
			
				str = str .. v
			
			else
			
				str = v .. " and "
			
			end
		
		end
	
	end
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		
		v:Notice( "The weather conditions are changing", GAMEMODE.Colors.White, 5 )
		v:Notice( "Immediate forecast: " .. str, GAMEMODE.Colors.White, 5, 2 )
		
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
