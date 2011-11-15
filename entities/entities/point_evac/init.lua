
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Heli = Sound( "ambient/machines/heli_pass2.wav" )

ENT.EvacDist = 350

function ENT:Initialize()
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
	
	self.Entity:SetCollisionBounds( Vector( -150, -150, -150 ), Vector( 150, 150, 150 ) )
	self.Entity:PhysicsInitBox( Vector( -150, -150, -150 ), Vector( 150, 150, 150 ) )
	
	self.DieTime = CurTime() + 44
	self.SoundTime = CurTime() + 43
	
	self.Players = {}
	
	local flare = ents.Create( "sent_heliflare" )
	flare:SetPos( self.Entity:GetPos() )
	flare:Spawn()
	
	self.Entity:EmitSound( self.Heli, 150 )
	
	local trace = {}
	trace.start = self.Entity:GetPos() + Vector(0,0,10)
	trace.endpos = trace.start + Vector(0,0,800)
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )
	
	if tr.HitPos:Distance( self.Entity:GetPos() ) < 400 then return end
	
	local heli = ents.Create( "prop_dynamic" )
	heli:SetModel( "models/combine_helicopter.mdl" )
	heli:SetPos( tr.HitPos + Vector(0,0,-150) )
	heli:Spawn()
	heli:Fire( "SetAnimation", "idle", 1 )
	
end

function ENT:Think()

	if self.SoundTime and self.SoundTime < CurTime() then
	
		self.Entity:EmitSound( self.Heli, 150 )
		
		self.SoundTime = nil
	
	end

	if self.DieTime < CurTime() then
	
		self.Entity:Evac()
		self.Entity:Remove()
		
		for k,v in pairs( team.GetPlayers( TEAM_ZOMBIES ) ) do
		
			v:Notice( "The chopper has left the evac zone", GAMEMODE.Colors.White, 5 )
		
		end
		
	end

end

function ENT:Evac()

	for k,v in pairs( self.Players ) do
	
		if ValidEntity( v ) and v:Alive() and v:Team() == TEAM_ARMY and v:GetPos():Distance( self.Entity:GetPos() ) < self.EvacDist then
		
			v:Evac()
		
		end
	
	end

end

function ENT:Touch( ent ) 

	if not ent:IsPlayer() then return end
	
	if ent:Team() != TEAM_ARMY then return end
	
	if table.HasValue( self.Players, ent ) then return end
	
	table.insert( self.Players, ent )
	
	if not self.FirstEvac then
	
		self.FirstEvac = true
		
		ent:AddStat( "Evac" )
	
	end
	
	ent:Notice( "You made it to the evac zone", GAMEMODE.Colors.Green, 5 )
	ent:Notice( "The helicopter will take off shortly", GAMEMODE.Colors.Blue, 5, 2 )
	
end 

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end
