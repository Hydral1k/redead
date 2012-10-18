
include('shared.lua')

function ENT:Initialize()

	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	
	self.SmokeTime = 0
	self.LightTime = 0
	
	self.Entity:DoTraces()

end

function ENT:DoTraces()

	if self.Entity:GetPos() == Vector(0,0,0) then return end
	
	self.PosTbl = {}

	for i=-30,30 do
	
		for j=-30,30 do
	
			local trace = {}
			trace.start = self.Entity:GetPos() + Vector( i * 2, j * 2, 10 )
			trace.endpos = trace.start + Vector(0,0,200)
			
			local tr = util.TraceLine( trace )
	
			trace.start = tr.HitPos
			trace.endpos = trace.start + Vector( 0, 0, -2000 )
			
			local tr2 = util.TraceLine( trace )
			
			table.insert( self.PosTbl, { Pos = tr2.HitPos, Scale = ( ( 30 - math.abs( i ) ) + ( 30 - math.abs( j ) ) ) / 60 } )
			
		end
		
	end

end

function ENT:Think()

	if not self.PosTbl then
	
		self.Entity:DoTraces()
		
		if not self.PosTbl then return end
	
	end

	local tbl = table.Random( self.PosTbl )
	
	local particle = self.Emitter:Add( "effects/muzzleflash" .. math.random(1,4), tbl.Pos + ( VectorRand() * 2 ) )
	particle:SetVelocity( Vector(0,0,80) )
	particle:SetDieTime( math.Rand( 0.2, 0.4 ) + math.Rand( 0.3, 0.6 ) * tbl.Scale )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.random(15,25) + ( math.random(25,50) * tbl.Scale ) )
	particle:SetEndSize( 0 )
	particle:SetRoll( math.random(-180,180) )
	particle:SetColor( 255, 200, 200 )
	particle:SetGravity( Vector( 0, 0, 400 + ( tbl.Scale * 100 ) ) )
	
	if self.SmokeTime < CurTime() then
	
		self.SmokeTime = CurTime() + 0.02
		
		local particle = self.Emitter:Add( "particles/smokey", tbl.Pos + ( VectorRand() * 2 ) + Vector(0,0,50) )
		particle:SetVelocity( Vector( 0, 0, 30 + tbl.Scale * 10 ) )
		particle:SetDieTime( math.Rand( 0.5, 1.0 ) + ( tbl.Scale * math.Rand( 2.5, 3.5 ) ) )
		particle:SetStartAlpha( 50 + tbl.Scale * 75 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random(10,20) )
		particle:SetEndSize( math.random(30,60) + ( math.random(40,80) * tbl.Scale ) )
		particle:SetRoll( 0 )
		particle:SetColor( 10, 10, 10 )
		particle:SetGravity( Vector( 0, 0, 30 ) )
	
	end
	
	if self.LightTime < CurTime() then
	
		self.LightTime = CurTime() + 0.05
	
		local dlight = DynamicLight( self.Entity:EntIndex() )
	
		if dlight then
		
			dlight.Pos = self.Entity:GetPos()
			dlight.r = 255
			dlight.g = 120
			dlight.b = 50
			dlight.Brightness = 4
			dlight.Decay = 2048
			dlight.size = 256 * math.Rand( 0.8, 1.2 )
			dlight.DieTime = CurTime() + 1
			
		end
	
	end

end

function ENT:OnRemove()

	if self.Emitter then
	
		self.Emitter:Finish()
	
	end

end

function ENT:Draw()
	
end

