include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()

	if self.Ragdolled then return end

	self.Entity:DrawModel()
	
end

