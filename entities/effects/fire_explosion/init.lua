

function EFFECT:Init( data )

	self.DieTime = CurTime() + 1.5
	
	local pos = data:GetOrigin()
	local normal = data:GetNormal()
	local emitter = ParticleEmitter( pos )
	
	local particle = emitter:Add( "effects/blood_core", pos )
	particle:SetDieTime( math.Rand( 1.0, 1.5 ) )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( 10 )
	particle:SetEndSize( math.random( 50, 100 ) )
	particle:SetRoll( math.Rand( -360, 360 ) )
	particle:SetColor( 50, 50, 50 )
	
	for i=1, 10 do
	
		local particle = emitter:Add( "effects/muzzleflash"..math.random(1,4), pos )
		particle:SetVelocity( VectorRand() * 50 + normal * 50 )
		particle:SetDieTime( math.Rand( 0.3, 0.6 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 5, 10 ) )
		particle:SetEndSize( math.Rand( 30, 60 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( 200, 150, 100 )
	
	end
	
	for i=1, math.random(5,10) do
	
		local vec = normal * math.random( 150, 200 ) + VectorRand() * 50
		local normalized = vec:GetNormal():Angle()
	
		local particle = emitter:Add( "effects/yellowflare", pos )
		particle:SetVelocity( normal * math.random(150,200) + VectorRand() * 50 )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( math.Rand( 1.5, 3.5 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 4, 8 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( 200, 100, 50 )
		
		particle:SetGravity( Vector( 0, 0, -500 ) )
		particle:SetCollide( true )
		particle:SetBounce( math.Rand( 0, 0.2 ) )
	
	end

	emitter:Finish()
	
	local dlight = DynamicLight( self:EntIndex() )
	
	if dlight then
	
		dlight.Pos = pos
		dlight.r = 255
		dlight.g = 150
		dlight.b = 50
		dlight.Brightness = 3
		dlight.Decay = 512
		dlight.size = 256 * math.Rand( 0.5, 1.0 )
		dlight.DieTime = CurTime() + 5
		
	end
	
end

function EFFECT:Think( )

	return self.DieTime > CurTime()
	
end

function EFFECT:Render()
	
end
