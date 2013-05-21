
local EVENT = {}

EVENT.Type = EVENT_BAD
EVENT.TimeText = { "30 seconds", "1 minute", "90 seconds" }  
EVENT.Times = { 30, 60, 90 }  

function EVENT:Start()
	
	local num = math.random(1,4)
	
	GAMEMODE.RadioBlock = CurTime() + EVENT.Times[ num ]
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		
		v:Notice( "Radio communications will be down for " .. EVENT.TimeText[ num ], GAMEMODE.Colors.Red, 5 )
		v:Notice( "Radio communications are back online", GAMEMODE.Colors.White, 5, EVENT.Times[ num ] )
		
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
