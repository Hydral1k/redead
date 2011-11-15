
local function DrawBlood()
	
	if #BloodTable < 1 then return end

	for i=1, #BloodTable do
	
		if BloodTable[i] then
		
			local scale = math.Clamp( ( BloodTable[i].DieTime - CurTime() ) / BloodTable[i].Die, 0, 1 )
		
			if scale == 0 then
			
				BloodTable[i].Remove = true
				
			else
			
				local alpha = math.floor( BloodTable[i].Alpha * scale )
				
				surface.SetTexture( surface.GetTextureID( BloodTable[i].Mat ) )
				surface.SetDrawColor( 250, 10, 10, alpha )
				surface.DrawTexturedRectRotated( BloodTable[i].X, BloodTable[i].Y, BloodTable[i].W, BloodTable[i].H, BloodTable[i].Rot )
				
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

StainMats = { "toxsin/Blood1",
"toxsin/Blood2",
"toxsin/Blood3",
"toxsin/Blood4",
"toxsin/Blood5",
"toxsin/Blood6",
"toxsin/Blood7",
"toxsin/Blood8" }

BloodTable = {}

function AddStain( msg )

	local num = 1

	if msg then 
	
		num = msg:ReadShort()
		
	end
	
	for i=1, num do

		local count = #BloodTable + 1
		
		local RandomH = ScrH() * math.Rand(0.4,0.6)
		local RandomW = ScrW() * math.Rand(0.4,0.6)
		local RandomX = ScrW() * math.Rand(-0.2,1)
		local RandomY = ScrH() * math.Rand(-0.2,1)
		local rand = math.Rand(3.0,6.0)
		
		BloodTable[count] = { H = RandomH, W = RandomW, X = RandomX, Y = RandomY, Mat = table.Random( StainMats ), Die = rand, DieTime = CurTime() + rand, Rot = math.random(0,360), Alpha = math.random(100,200) }
		
	end
	
end
usermessage.Hook( "BloodStain", AddStain ) 

