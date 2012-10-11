
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.HitSound = Sound( "Metal_Box.ImpactHard" )
ENT.Model = Model( "models/props_phx/misc/potato_launcher_explosive.mdl" )
ENT.Damage = 150
ENT.Radius = 350
ENT.Speed = 3500

function ENT:Initialize()

	self.Entity:SetModel( self.Model )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()
		phys:ApplyForceCenter( self.Entity:GetAngles():Forward() * self.Speed )
	
	end
	
end

function ENT:SetSpeed( num )

	self.Speed = num

end

function ENT:Think()

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
	
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		ed:SetMagnitude( 0.8 )
		util.Effect( "smoke_crater", ed, true, true )
		
		util.Decal( "Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
	
	end

	if IsValid( self.Entity:GetOwner() ) then
	
		util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), self.Radius, self.Damage )
		
	end
	
	for k,v in pairs( player.GetAll() ) do
	
		if v:Team() != self.Entity:GetOwner():Team() and v:GetPos():Distance( self.Entity:GetPos() ) < self.Radius then
		
			v:SetBleeding( true )
		
		end
	
	end
	
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
	
		self.Entity:EmitSound( self.HitSound, 100, 120 )
		
	end
	
end

