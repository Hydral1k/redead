
include('shared.lua')

function ENT:Initialize()

	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	self.DieTime = CurTime() + 30
	self.LightTime = 0

end

function ENT:Think()

	self.Scale = ( self.DieTime - CurTime() ) / 30
	
	if self.LightTime < CurTime() then
	
		self.LightTime = CurTime() + 0.1
	
		local dlight = DynamicLight( self.Entity:EntIndex() )
	
		if dlight then
		
			dlight.Pos = self.Entity:GetPos()
			dlight.r = 150
			dlight.g = 255
			dlight.b = 50
			dlight.Brightness = 2
			dlight.Decay = 0
			dlight.size = self.Scale * self.Entity:GetNWInt( "Distance", 300 ) 
			dlight.DieTime = CurTime() + 1
			
		end
	
	end

end

function ENT:OnRemove()

	if self.Emitter then
	
		self.Emitter:Finish()
	
	end

end

function ENT:Draw()
	
end

