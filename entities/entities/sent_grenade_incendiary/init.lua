
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.HitSound = Sound( "physics/metal/metal_grenade_impact_hard2.wav" )
ENT.DieSound = Sound( "ambient/fire/ignite.wav" )
ENT.Damage = 30
ENT.Radius = 200
ENT.Speed = 3500

function ENT:Initialize()

	self.Entity:SetModel( Model( "models/weapons/w_eq_flashbang.mdl" ) )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:DrawShadow( false )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()
		phys:SetDamping( 0, 5 )
		phys:ApplyForceCenter( self.Entity:GetAngles():Forward() * self.Speed )
	
	end
	
	self.Delay = CurTime() + 3.5
	
end

function ENT:SetSpeed( num )

	self.Speed = num

end

function ENT:Think()

	if self.Delay < CurTime() then
	
		self.Entity:Explode()
	
	end

end

function ENT:Explode()

	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "Explosion", ed, true, true )
	
	local trace = {}
	trace.start = self.Entity:GetPos() + Vector(0,0,20)
	trace.endpos = trace.start + Vector( 0, 0, -200 )
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )

	if tr.HitWorld then
		
		util.Decal( "Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
	
	end

	if IsValid( self.Entity:GetOwner() ) and self.Entity:GetOwner():Team() == TEAM_ARMY then
	
		util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), self.Radius, self.Damage )
		
	end
	
	local fire = ents.Create( "sent_fire" )
	fire:SetPos( self.Entity:GetPos() )
	fire:SetOwner( self.Entity:GetOwner() )
	fire:SetLifeTime( 8 )
	fire:Spawn()
	
	--[[for k,v in pairs( player.GetAll() ) do
	
		if v:Team() != self.Entity:GetOwner():Team() and v:GetPos():Distance( self.Entity:GetPos() ) < self.Radius then
		
			v:SetBleeding( true )
		
		end
	
	end]]
	
	self.Entity:EmitSound( self.DieSound, 100, math.random(90,110) )
	self.Entity:Remove()

end

function ENT:OnRemove()

end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:PhysicsCollide( data, phys )

	if data.Speed > 50 and data.DeltaTime > 0.15 then
	
		self.Entity:EmitSound( self.HitSound, 50, math.random(120,140) )
		
	end
	
end

