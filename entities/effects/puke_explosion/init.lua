
EFFECT.Color = Color(100,50,0)

function EFFECT:Init( data )

	self.DieTime = CurTime() + 1.5
	self.SoundTime = 0
	
	local pos = data:GetOrigin() + Vector(0,0,50)
	local emitter = ParticleEmitter( pos )
	
	self.Pos = pos
	
	local particle = emitter:Add( "effects/blood_core", pos )
	particle:SetDieTime( math.Rand( 0.5, 1.0 ) )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.Rand( 5, 10 ) )
	particle:SetEndSize( math.Rand( 100, 150 ) )
	particle:SetRoll( math.Rand( -360, 360 ) )
	particle:SetColor( self.Color.r, self.Color.g, 0 )
	
	for i=1, math.random(4,8) do
	
		local particle = emitter:Add( "effects/blood", pos )
		particle:SetVelocity( VectorRand() * 100 + Vector(0,math.random(-25,25),50) )
		particle:SetDieTime( 1.0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 20, 40 ) )
		particle:SetEndSize( math.Rand( 50, 150 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( self.Color.r, self.Color.g, 0 )
		particle:SetGravity( Vector( 0, 0, -300 ) )
	
	end
	
	for i=1, 8 do
	
		local vec = VectorRand()
		vec.z = math.Rand( -0.2, 1.0 )
	
		local particle = emitter:Add( "toxsin/gore" .. math.random(1,2), pos )
		particle:SetVelocity( vec * 250 )
		particle:SetDieTime( math.Rand( 0.8, 1.0 ) )
		particle:SetStartAlpha( 200 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 10, 20 ) )
		particle:SetEndSize( math.Rand( 150, 200 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( self.Color.r, self.Color.g + math.random(0,20), 0 )
		particle:SetGravity( Vector( 0, 0, -300 ) )
	
	end
	
	for i=1, math.random(3,5) do
	
		local vec = VectorRand()
		vec.z = math.Rand( -0.1, 1.0 )
	
		local particle = emitter:Add( "toxsin/gore" .. math.random(1,2), pos + Vector(0,0,math.random(-10,10)) )
		particle:SetVelocity( vec * 450 )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( 1.0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 10 )
		particle:SetEndSize( 5 )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( self.Color.r, self.Color.g, 0 )
		
		particle:SetGravity( Vector( 0, 0, -500 ) )
		particle:SetCollide( true )
		
		particle:SetThinkFunction( GobThink )
		particle:SetNextThink( CurTime() + 0.1 )
		particle.Color = self.Color
	
	end

	emitter:Finish()
	
	for i=1, 10 do
	
		local ed = EffectData()
		ed:SetOrigin( pos + Vector(0,0,math.random(0,30)) )
		
		if i < 5 then
			ed:SetScale( 1 )
		else
			ed:SetScale( 2 )
		end
		
		util.Effect( "player_gib", ed, true, true )
	
	end
	
end

function EFFECT:Think()

	if self.SoundTime < CurTime() then
	
		WorldSound( table.Random( GAMEMODE.GoreSplat ), self.Pos, 100, math.random(90,110) )
		
		self.SoundTime = CurTime() + 0.5
	
	end

	return self.DieTime > CurTime()
	
end

function EFFECT:Render()
	
end

function GobThink( part )

	part:SetNextThink( CurTime() + 0.1 )

	local scale = 1 - part:GetLifeTime()
	local pos = part:GetPos()
	local emitter = ParticleEmitter( pos )
	
	local particle = emitter:Add( "toxsin/gore" .. math.random(1,2), pos  )
	particle:SetVelocity( Vector(0,0,-80) * scale )
	particle:SetDieTime( 3.0 + scale * 1.0 )
	particle:SetStartAlpha( 200 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( 2 + scale * 8 )
	particle:SetEndSize( 4 + scale * 8 )
	particle:SetRoll( math.Rand( -180, 180 ) )
	particle:SetColor( part.Color.r, part.Color.g + math.random(0,20), 0 )
	
	particle:SetGravity( Vector( 0, 0, -500 ) )
	particle:SetCollide( true )
	
	emitter:Finish()

end


