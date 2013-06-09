

function EFFECT:Init( data )

	self.DieTime = CurTime() + 1.5
	
	local pos = data:GetOrigin() + Vector(0,0,50)
	local emitter = ParticleEmitter( pos )
	
	local particle = emitter:Add( "effects/blood_core", pos )
	particle:SetDieTime( math.Rand( 0.5, 1.0 ) )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( 10 )
	particle:SetEndSize( math.random( 150, 200 ) )
	particle:SetRoll( math.Rand( -360, 360 ) )
	particle:SetColor( 50, 0, 0 )
	
	local particle = emitter:Add( "effects/blood_core", pos )
	particle:SetDieTime( math.Rand( 6.0, 8.0 ) )
	particle:SetStartAlpha( 50 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.random( 100, 250 ) )
	particle:SetEndSize( 200 )
	particle:SetRoll( math.Rand( -360, 360 ) )
	particle:SetColor( 50, 0, 0 )
	particle:SetGravity( Vector( 0, 0, -5 ) )
	
	for i=1, math.random(4,8) do
	
		local particle = emitter:Add( "effects/blood", pos )
		particle:SetVelocity( VectorRand() * 100 + Vector(0,math.random(-25,25),50) )
		particle:SetDieTime( 1.0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 20, 40 ) )
		particle:SetEndSize( math.random( 50, 150 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( 50, 0, 0 )
		particle:SetGravity( Vector( 0, 0, -300 ) )
	
	end
	
	for i=1, 12 do
	
		local vec = VectorRand()
		vec.z = math.Rand( -0.2, 1.0 )
	
		local particle = emitter:Add( "nuke/gore" .. math.random(1,2), pos )
		particle:SetVelocity( vec * 250 + Vector(0,0,50) )
		particle:SetDieTime( math.Rand( 0.8, 1.0 ) )
		particle:SetStartAlpha( 200 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 10, 20 ) )
		particle:SetEndSize( math.random( 50, 100 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( 50, 0, 0 )
		particle:SetGravity( Vector( 0, 0, -300 ) )
	
	end
	
	for i=1, math.random(3,6) do
	
		local vec = VectorRand()
		vec.z = math.Rand( -0.2, 1.0 )
	
		local particle = emitter:Add( "nuke/gore" .. math.random(1,2), pos + Vector(0,0,math.random(-10,10)) )
		particle:SetVelocity( vec * 300 )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( math.Rand( 2.0, 4.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 255 )
		particle:SetStartSize( math.random( 8, 12 ) )
		particle:SetEndSize( 1 )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( 40, 0, 0 )
		
		particle:SetGravity( Vector( 0, 0, -500 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.5 )
		
		particle:SetCollideCallback( function( part, pos, normal )
   
			util.Decal( "Blood", pos + normal, pos - normal )
   
		end )
	
	end

	emitter:Finish()
	
	for i=1, 15 do
	
		local ed = EffectData()
		ed:SetOrigin( pos + Vector(0,0,math.random(0,30)) )
		
		if i < 5 then
			ed:SetScale( 1 )
		else
			ed:SetScale( 2 )
		end
		
		util.Effect( "player_gib", ed, true, true )
	
	end
	
	if LocalPlayer():GetPos():Distance( pos ) <= 300 then
		
		local frac = 1 - ( LocalPlayer():GetPos():Distance( pos ) / 300 )
		
		for i=1, math.Round( frac * 12 ) do
			
			AddStain()
			
		end
	
	end
	
end

function EFFECT:Think( )

	return self.DieTime > CurTime()
	
end

function EFFECT:Render()
	
end
