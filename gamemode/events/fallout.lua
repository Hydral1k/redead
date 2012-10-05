
local EVENT = {}

EVENT.Type = EVENT_BAD
EVENT.TimeText = { "30 seconds", "1 minute" }  
EVENT.Times = { 30, 60 }  

function EVENT:Start()
	
	local num = math.random(1,2)
	
	EVENT.Delay = CurTime() + 15
	EVENT.RadTime = CurTime() + EVENT.Times[ num ] + 15
	EVENT.RadDelay = 0
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		
		v:Notice( "Nuclear fallout contamination is imminent", GAMEMODE.Colors.Red, 5 )
		v:Notice( "Enter a building to avoid radiation poisoning", GAMEMODE.Colors.Red, 5, 2 )
		v:Notice( "The atmospheric fallout will subside in " .. EVENT.TimeText[ num ], GAMEMODE.Colors.Red, 5, 15 )
		v:Notice( "Atmospheric radioactivity levels are now safe", GAMEMODE.Colors.Green, 5, EVENT.Times[ num ] + 15 )
		
	end
	
end
	
function EVENT:Think()

	if EVENT.Delay < CurTime() then
	
		if EVENT.RadDelay < CurTime() then
		
			EVENT.RadDelay = CurTime() + 1
			
			for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
			
				if not v:IsIndoors() then
					
					if math.random(1,2) == 1 then

						v:EmitSound( table.Random( GAMEMODE.Geiger ), 100, math.random(90,110) )
					
					end					
					
					if math.random(1,5) == 1 then
					
						v:AddRadiation( 1 )
					
					end
					
				end
			
			end
			
		end
	
	end

end

function EVENT:EndThink()

	return EVENT.RadTime < CurTime() 

end

function EVENT:End()

end

event.Register( EVENT )
