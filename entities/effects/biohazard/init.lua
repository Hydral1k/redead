
EFFECT.Color = Color(100,80,0)

function EFFECT:Init( data )

	self.DieTime = CurTime() + 1.5
	self.SoundTime = 0
	
	local pos = data:GetOrigin() + Vector(0,0,10)
	local emitter = ParticleEmitter( pos )
	
	self.Pos = pos
	
	for i=1, math.random(4,8) do
	
		local particle = emitter:Add( "effects/blood", pos )
		particle:SetVelocity( VectorRand() * 100 + Vector(0,math.random(-25,25),50) )
		particle:SetDieTime( 1.0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 20, 40 ) )
		particle:SetEndSize( math.random( 50, 150 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( self.Color.r, self.Color.g, 0 )
		particle:SetGravity( Vector( 0, 0, -300 ) )
	
	end
	
	for i=1, 10 do
	
		local vec = VectorRand()
		vec.z = math.Rand( -0.2, 1.0 )
	
		local particle = emitter:Add( "nuke/gore" .. math.random(1,2), pos )
		particle:SetVelocity( vec * 250 )
		particle:SetDieTime( math.Rand( 0.8, 1.0 ) )
		particle:SetStartAlpha( 200 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 10, 20 ) )
		particle:SetEndSize( math.random( 100, 150 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( self.Color.r, self.Color.g + math.random(0,20), 0 )
		particle:SetGravity( Vector( 0, 0, -400 ) )
	
	end
	
	for i=1, math.random(3,6) do
	
		local vec = VectorRand()
		vec.z = math.Rand( -0.2, 1.0 )
	
		local particle = emitter:Add( "nuke/gore" .. math.random( 1, 2 ), pos + Vector( 0, 0, math.random( -10, 10 ) ) )
		particle:SetVelocity( vec * 300 )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( math.Rand( 2.0, 4.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 255 )
		particle:SetStartSize( math.random( 8, 12 ) )
		particle:SetEndSize( 1 )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetColor( self.Color.r, self.Color.g, 0 )
		
		particle:SetGravity( Vector( 0, 0, -500 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.5 )
		
		particle:SetCollideCallback( function( part, pos, normal )
   
			util.Decal( "yellowblood", pos + normal, pos - normal )
   
		end )
	
	end

	emitter:Finish()
	
end

function EFFECT:Think()

	if self.SoundTime < CurTime() then
	
		sound.Play( table.Random( GAMEMODE.GoreSplat ), self.Pos, 100, math.random(90,110) )
		
		self.SoundTime = CurTime() + 0.5
	
	end

	return self.DieTime > CurTime()
	
end

function EFFECT:Render()
	
end
