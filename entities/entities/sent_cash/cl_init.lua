
include('shared.lua')

function ENT:Initialize()

end

function ENT:Think()
	
end

function ENT:Draw()

	//self.Entity:SetModelScale( Vector(1,1,1) + Vector(1,1,1) * math.sin( CurTime() * 3 ) * 0.1 )
	self.Entity:DrawModel()
	
end

