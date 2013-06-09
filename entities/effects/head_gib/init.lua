

function EFFECT:Init( data )
	
	local pos = data:GetOrigin() 
	local emitter = ParticleEmitter( pos )
	
	local particle = emitter:Add( "effects/blood_core", pos )
	particle:SetDieTime( 0.5 )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.random( 5, 10 ) )
	particle:SetEndSize( math.random( 50, 100 ) )
	particle:SetRoll( math.random( -360, 360 ) )
	particle:SetColor( 50, 0, 0 )
	
	local particle = emitter:Add( "effects/blood_core", pos )
	particle:SetDieTime( math.Rand( 5.0, 7.0 ) )
	particle:SetStartAlpha( 50 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.random( 40, 80 ) )
	particle:SetEndSize( 200 )
	particle:SetRoll( math.Rand( -360, 360 ) )
	particle:SetColor( 50, 0, 0 )
	particle:SetGravity( Vector( 0, 0, -5 ) )
	
	for i=1, math.random(5,10) do
	
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
	
	for i=1, 6 do
	
		local particle = emitter:Add( "nuke/gore" .. math.random(1,2), pos )
		particle:SetVelocity( VectorRand() * 100 + Vector(0,0,75) )
		particle:SetDieTime( 0.5 )
		particle:SetStartAlpha( 200 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 5, 10 ) )
		particle:SetEndSize( math.random( 30, 60 ) )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetColor( 50, 0, 0 )
		particle:SetGravity( Vector( 0, 0, -300 ) )
	
	end

	emitter:Finish()
	
	for i=1, 3 do
	
		local ed = EffectData()
		ed:SetOrigin( pos )
		ed:SetScale( 1 )
		util.Effect( "player_gib", ed, true, true )
	
	end
	
	if LocalPlayer():GetPos():Distance( pos ) <= 100 then
		
		local frac = 1 - ( LocalPlayer():GetPos():Distance( pos ) / 100 )
		
		for i=1, math.Round( frac * 6 ) do
			
			AddStain()
		
		end
	
	end
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()
	
end

