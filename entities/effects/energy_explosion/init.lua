

function EFFECT:Init( data )

	self.DieTime = CurTime() + 1.5
	
	local pos = data:GetOrigin()
	local normal = data:GetNormal()
	local emitter = ParticleEmitter( pos )
	
	for i=1, 20 do
	
		local particle = emitter:Add( "effects/muzzleflash"..math.random(1,4), pos )
		particle:SetVelocity( VectorRand() * 100 )
		particle:SetDieTime( math.Rand( 0.3, 0.6 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 5, 10 ) )
		particle:SetEndSize( math.Rand( 40, 80 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( 50, 100, 250 )
	
	end
	
	for i=1, math.random(3,6) do
	
		local vec = normal * math.random( 150, 200 )+ VectorRand() * 50
		local normalized = vec:GetNormal():Angle()
	
		local particle = emitter:Add( "effects/yellowflare", pos )
		particle:SetVelocity( normal * math.random(150,200) + VectorRand() * 50 )
		particle:SetAngles( normalized )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( math.Rand( 0.8, 1.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 10 )
		particle:SetEndSize( 0 )
		particle:SetEndLength( 20 )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( 50, 100, 200 )
		
		particle:SetGravity( Vector( 0, 0, -300 ) )
	
	end
	
	for i=1, math.random(3,6) do
	
		local vec = VectorRand() * 500
		local normalized = vec:GetNormal():Angle()
	
		local particle = emitter:Add( "effects/yellowflare", pos )
		particle:SetVelocity( vec )
		particle:SetAngles( normalized )
		particle:SetDieTime( math.Rand( 2.0, 4.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 10 )
		particle:SetEndSize( 0 )
		particle:SetEndLength( 20 )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( 50, 100, 200 )
		
		particle:SetGravity( Vector( 0, 0, -500 ) )
		particle:SetCollide( true )
		particle:SetBounce( 1.0 )
	
	end

	emitter:Finish()
	
end

function EFFECT:Think( )

	return self.DieTime > CurTime()
	
end

function EFFECT:Render()
	
end
