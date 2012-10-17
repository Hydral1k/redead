
include('shared.lua')

function ENT:Initialize()

	GAMEMODE.ClientAntidote = self.Entity

end

function ENT:Think()
	
end

local matLight = Material( "toxsin/allyvision" )

function ENT:Draw()

	self.Entity:DrawModel()
	
end
	
--[[local scale = ( math.Clamp( self.Entity:GetPos():Distance( LocalPlayer():GetPos() ), 500, 3000 ) - 500 ) / 2500
	
	local eyenorm = self.Entity:GetPos() - EyePos()
	local dist = eyenorm:Length()
	eyenorm:Normalize()
	
	local pos = EyePos() + eyenorm * dist * 0.01
	
	cam.Start3D( pos, EyeAngles() )
		
		render.SetColorModulation( 0, 1.0, 0.5 )
		render.SetBlend( scale )
		render.MaterialOverride( matLight )
		
			self.Entity:DrawModel()
		
		render.SetColorModulation( 1, 1, 1 )
		render.SetBlend( 1 )
		render.MaterialOverride( 0 )
		
	cam.End3D()
	
end]]