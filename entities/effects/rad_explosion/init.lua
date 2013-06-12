
function EFFECT:Init( data )
	
	local pos = data:GetOrigin() + Vector(0,0,40)
	local emitter = ParticleEmitter( pos )
	
	for i=1, math.random(4,8) do
	
		local particle = emitter:Add( "effects/blood", pos )
		particle:SetVelocity( VectorRand() * 100 + Vector(0,math.random(-25,25),50) )
		particle:SetDieTime( 1.0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 5, 10 ) )
		particle:SetEndSize( math.random( 20, 40 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( 100, 200, 0 )
		particle:SetGravity( Vector( 0, 0, -300 ) )
	
	end
	
	for i=1, 20 do
	
		local vec = VectorRand()
		vec.z = math.Rand( -0.2, 1.0 )
	
		local particle = emitter:Add( "effects/yellowflare", pos )
		particle:SetVelocity( vec * 300 )
		particle:SetDieTime( math.Rand( 2.5, 3.5 ) )
		particle:SetStartAlpha( 200 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 2, 4 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetColor( 100, 200, 0 )
		particle:SetGravity( Vector( 0, 0, -300 ) )
		
		particle:SetCollide( true )
		particle:SetBounce( math.Rand( 0.1, 0.5 ) )
	
	end

	emitter:Finish()
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()
	
end
