
local BloodTable = {}

local function DrawBlood()
	
	if #BloodTable < 1 then return end

	for i=1, #BloodTable do
	
		if BloodTable[i] then
		
			local scale = math.Clamp( ( BloodTable[i].DieTime - CurTime() ) / BloodTable[i].Die, 0, 1 )
		
			if scale == 0 then
			
				BloodTable[i].Remove = true
				
			else
			
				local alpha = math.floor( BloodTable[i].Alpha * scale )
				
				surface.SetTexture( BloodTable[i].Mat )
				//surface.SetDrawColor( 250, 10, 10, alpha )
				surface.SetDrawColor( 175, 10, 10, alpha )
				surface.DrawTexturedRect( BloodTable[i].X, BloodTable[i].Y, BloodTable[i].Size, BloodTable[i].Size )//, BloodTable[i].Rot )
				
			end
			
		end
		
	end
	
	for k,v in pairs( BloodTable ) do
	
		if v.Remove then
		
			table.remove( BloodTable, k )
			
			break
			
		end
		
	end
	
end
hook.Add( "HUDPaint", "BloodPaint", DrawBlood )

StainMats = { "nuke/blood/Blood1",
"nuke/blood/Blood2",
"nuke/blood/Blood3",
"nuke/blood/Blood4",
"nuke/blood/Blood5",
"nuke/blood/Blood6",
"nuke/blood/Blood7" } 

function AddStain( msg )

	local num = 1

	if msg then 
	
		num = msg:ReadShort()
		
	end
	
	for i=1, num do

		local count = #BloodTable + 1
		
		local size = math.random( 256, 1024 )
		local x = math.random( size * -0.5, ScrW() - ( size * 0.5 ) )
		local y = math.random( size * -0.5, ScrH() - ( size * 0.5 ) )
		local rand = math.Rand( 3.5, 6.5 )
		
		BloodTable[count] = { Size = size, X = x, Y = y, Mat = surface.GetTextureID( table.Random( StainMats ) ), Die = rand, DieTime = CurTime() + rand, Alpha = math.random( 150, 250 ) }
		
	end
	
end

usermessage.Hook( "BloodStain", AddStain ) 
