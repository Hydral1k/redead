
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.HitSound = Sound( "Canister.ImpactHard" )
ENT.DieSound = Sound( "PropaneTank.Burst" )
ENT.Model = Model( "models/props_junk/propane_tank001a.mdl" )
ENT.Damage = 180
ENT.Radius = 350

function ENT:Initialize()

	self.Entity:SetModel( self.Model )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	//self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()
	
	end
	
end

function ENT:SetSpeed( num )

	self.Speed = num

end

function ENT:Think()

end

function ENT:Explode()

	if self.Exploded then return end
	
	self.Exploded = true

	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "Explosion", ed, true, true )
	
	local trace = {}
	trace.start = self.Entity:GetPos() + Vector(0,0,20)
	trace.endpos = trace.start + Vector( 0, 0, -200 )
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )

	if tr.HitWorld then
	
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		ed:SetMagnitude( 0.8 )
		util.Effect( "smoke_crater", ed, true, true )
		
		util.Decal( "Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
	
	end

	if IsValid( self.Entity:GetOwner() ) then
	
		util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), self.Radius, self.Damage )
		
	end
	
	self.Entity:EmitSound( self.DieSound, 100, math.random(90,110) )
	self.Entity:Remove()

end

function ENT:Use( ply, caller )
	
	ply:AddToInventory( self.Entity )

end

function ENT:OnRemove()

end

function ENT:OnTakeDamage( dmginfo )

	if dmginfo:IsBulletDamage() and IsValid( dmginfo:GetAttacker() ) and dmginfo:GetAttacker():IsPlayer() then
	
		self.Entity:SetOwner( dmginfo:GetAttacker() )
		self.Entity:Explode()
	
	end
	
end

function ENT:PhysicsCollide( data, phys )

	if data.Speed > 50 and data.DeltaTime > 0.15 then
	
		self.Entity:EmitSound( self.HitSound )
		
	end
	
end

