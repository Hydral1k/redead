
function EFFECT:Init( data )

	self.DieTime = CurTime() + 5
	self.PartTime = 0
	self.Ent = data:GetEntity()
	
	if not IsValid( self.Ent ) then self.DieTime = 0 return end
	
	self.Emitter = ParticleEmitter( self.Ent:GetPos() )
	
end

function EFFECT:Think()

	if IsValid( self.Ent ) then
	
		if self.Ent:IsPlayer() and ( !self.Ent:Alive() or self.Ent == LocalPlayer() ) then
	
			self.DieTime = 0
			
		end
	
	end

	if self.DieTime < CurTime() or not IsValid( self.Ent ) then
	
		if self.Emitter then
		
			self.Emitter:Finish()
		
		end
	
		return false
	
	end

	if self.PartTime < CurTime() then
	
		self.PartTime = CurTime() + math.Rand( 0.2, 0.4 )
	
		local pos = self.Ent:GetPos() + Vector(0,0,math.random(1,40)) + Vector(math.random(-10,10),math.random(-10,10),0)
		
		local particle = self.Emitter:Add( "effects/yellowflare", pos )
		particle:SetVelocity( VectorRand() * 5 )
		particle:SetDieTime( math.Rand( 2.0, 4.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 1, 3 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.random( -180, 180 ) )
		particle:SetColor( 100, 200, 0 )
		particle:SetGravity( Vector( 0, 0, -500 ) )
		
		particle:SetCollide( true )
		particle:SetBounce( math.Rand( 0, 0.2 ) )
		
	end

	return true
	
end

function EFFECT:Render()
	
end




