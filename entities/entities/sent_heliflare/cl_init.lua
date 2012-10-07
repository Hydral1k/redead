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
		particle:SetVelocity( VectorRand() * 8 + WindVector )
		particle:SetDieTime( math.Rand( 4.0, 8.0 ) )
		particle:SetStartAlpha( 100 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 1 )
		particle:SetEndSize( math.random( 50, 150 ) )
		particle:SetGravity( Vector( 0, 0, 25 ) + WindVector * 1.5 )
		
		local col = math.random( 50, 100 )
		particle:SetColor( col + 150, col, col )
		
	end
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = self.Entity:GetPos()
		dlight.r = 255
		dlight.g = 50
		dlight.b = 50
		dlight.Brightness = 3
		dlight.Decay = 0
		dlight.size = 256
		dlight.DieTime = CurTime() + 0.1
		
	end
	
	if not LocalPlayer():Alive() then return end
	
	local dist = LocalPlayer():GetPos():Distance( self.Entity:GetPos() )
		
	if dist < 300 then
		
		local scale = math.Clamp( 1 - ( math.Clamp( dist, 1, 300 ) / 300 ), 0, 1 )
			
		Sharpen = scale * 5
		ColorModify[ "$pp_colour_contrast" ] = 1 + ( scale * 0.6 )
		
	end
	
end

local matFlare = Material( "sprites/flareglow" )

function ENT:Draw()

	self.Entity:DrawModel()

	if self.Entity:GetNWFloat( "BurnDelay", 9000 ) > CurTime() then return end
	
	render.SetMaterial( matFlare )
	render.DrawSprite( self.Entity:GetPos(), 170, 170, Color( 255, 50, 50, 255 ) ) 
	
end

