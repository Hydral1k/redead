include('shared.lua')

function ENT:Initialize()

	self.Emitter = ParticleEmitter( self.Entity:GetPos() ) 
	self.Smoke = 0
	
end

function ENT:OnRemove()

	if self.Emitter then
	
		self.Emitter:Finish()
		
	end

end

function ENT:Think()

	if self.Entity:GetNWFloat( "BurnDelay", 9000 ) > CurTime() then return end
	
	if self.Smoke < CurTime() then
	
		self.Smoke = CurTime() + 0.2
	
		local particle = self.Emitter:Add( "particles/smokey", self.Entity:GetPos() + self.Entity:GetRight() * 5 )
		particle:SetVelocity( VectorRand() * 5 + WindVector + Vector(0,0,10) )
		particle:SetDieTime( math.Rand( 2.5, 5.0 ) )
		particle:SetStartAlpha( 100 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 3, 6 ) )
		particle:SetEndSize( math.random( 25, 50 ) )
		particle:SetGravity( Vector( 0, 0, 10 ) )
			
		local col = math.random( 100, 150 )
		particle:SetColor( col, col + 50, col )
		
	end
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = self.Entity:GetPos()
		dlight.r = 50
		dlight.g = 255
		dlight.b = 50
		dlight.Brightness = 3
		dlight.Decay = 2048
		dlight.size = 256 * math.Rand( 0.5, 1.0 )
		dlight.DieTime = CurTime() + 1
		
	end
	
end

local matFlare = Material( "effects/blueflare1" )

function ENT:Draw()

	self.Entity:DrawModel()

	if self.Entity:GetNWFloat( "BurnDelay", CurTime() + 1 ) > CurTime() then return end
	
	local size = math.Rand( 5, 25 )
	
	render.SetMaterial( matFlare )
	render.DrawSprite( self.Entity:GetPos() + self.Entity:GetRight() * 5, size, size, Color( 50, 255, 50, 255 ) ) 
	
end

