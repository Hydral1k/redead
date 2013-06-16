
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.HitSound = Sound( "Metal_Barrel.ImpactSoft" )
ENT.DieSound = Sound( "Breakable.Metal" )
ENT.Model = Model(  "models/props/de_train/barrel.mdl" )
ENT.Damage = 60
ENT.Radius = 300
ENT.Skins = {2,4,5,6}

function ENT:Initialize()

	local skin = table.Random( self.Skins )

	self.Entity:SetModel( self.Model )
	self.Entity:SetSkin( skin )
	
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
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < 200 and not v:IsInfected() and v:Alive() then
		
			v:SetInfected( true )
		
		end
	
	end
	
	for i=1, math.random( 2, 4 ) do
	
		local ed = EffectData()
		ed:SetOrigin( self.Entity:GetPos() )
		util.Effect( "barrel_gib", ed, true, true )
	
	end
	
	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "biohazard", ed, true, true )
	
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

