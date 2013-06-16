
function EFFECT:Init( data )

	self.DieTime = CurTime() + 5
	self.SmokeTime = 0
	self.Ent = data:GetEntity()
	
	if not IsValid( self.Ent ) then self.DieTime = 0 return end
	
	self.Emitter = ParticleEmitter( self.Ent:GetPos() )
	
	if LocalPlayer() != self.Ent then return end
	
	LocalPlayer():EmitSound( "ambient/fire/ignite.wav", 100, 80 )
	
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

	local pos
	
	for i=1, 3 do
	
		pos = self.Ent:GetPos() + Vector(0,0,math.random(1,50)) + Vector(math.random(-10,10),math.random(-10,10),0)
	
		local particle = self.Emitter:Add( "effects/muzzleflash" .. math.random(1,4), pos )
		particle:SetVelocity( Vector(0,0,80) )
		particle:SetDieTime( math.Rand( 0.2, 0.4 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random(5,15) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.random(-180,180) )
		particle:SetColor( 255, 200, 200 )
		particle:SetGravity( Vector( 0, 0, 500 ) )
		
	end
	
	if self.SmokeTime < CurTime() then
	
		self.SmokeTime = CurTime() + 0.02
		
		local particle = self.Emitter:Add( "particles/smokey", pos )
		particle:SetVelocity( Vector(0,0,30) )
		particle:SetDieTime( math.Rand( 1.0, 2.5 ) )
		particle:SetStartAlpha( 50 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 5, 10 ) )
		particle:SetEndSize( math.random( 25, 50 ) )
		particle:SetRoll( 0 )
		particle:SetColor( 50, 50, 50 )
		particle:SetGravity( Vector( 0, 0, 30 ) )
	
	end

	return true
	
end

function EFFECT:Render()
	
end




