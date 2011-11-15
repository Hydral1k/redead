

function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	local emitter = ParticleEmitter( pos )
	
	local particle = emitter:Add( "effects/blood_core", pos )
	particle:SetDieTime( 0.3 )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.random( 5, 10 ) )
	particle:SetEndSize( math.random( 50, 100 ) )
	particle:SetRoll( math.random( -360, 360 ) )
	particle:SetColor( 50, 0, 0 )
	
	local particle = emitter:Add( "particles/smokey", pos )
	particle:SetDieTime( math.Rand( 10, 20 ) )
	particle:SetStartAlpha( math.random( 20, 40 ) )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.random( 20, 40 ) )
	particle:SetEndSize( 10 )
	particle:SetRoll( math.random( -360, 360 ) )
	particle:SetColor( 50, 0, 0 )
	
	for i=1, math.random(2,4) do
	
		local particle = emitter:Add( "effects/blood", pos )
		particle:SetVelocity( VectorRand() * 100 + Vector(0,math.random(-25,25),50) )
		particle:SetDieTime( 1.0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 2, 4 ) )
		particle:SetEndSize( math.random( 10, 20 ) )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetColor( 50, 0, 0 )
		particle:SetGravity( Vector( 0, 0, -300 ) )
	
	end

	emitter:Finish()
	
	if LocalPlayer():GetPos():Distance( pos ) <= 100 then
		
		local frac = 1 - ( LocalPlayer():GetPos():Distance( pos ) / 100 )
		
		for i=1, math.Round( frac * 3 ) do
			
			AddStain()
			
		end
	
	end
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()
	
end

