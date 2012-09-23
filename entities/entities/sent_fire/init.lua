
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.BurnSound = Sound( "fire_large" )
ENT.LifeTime = 10

function ENT:Initialize()
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
	
	self.Entity:SetCollisionBounds( Vector( -60, -60, -60 ), Vector( 60, 60, 60 ) )
	self.Entity:PhysicsInitBox( Vector( -60, -60, -60 ), Vector( 60, 60, 60 ) )
	
	self.DieTime = CurTime() + self.LifeTime
	
	self.Entity:EmitSound( self.BurnSound )
	
end

function ENT:SetLifeTime( num )

	self.LifeTime = num

end

function ENT:OnRemove()

	self.Entity:StopSound( self.BurnSound )

end

function ENT:Think()

	if self.DieTime < CurTime() then
	
		self.Entity:Remove()
		
	end

end

function ENT:Touch( ent ) 

	if not IsValid( self.Entity:GetOwner() ) then return end
	
	//if ent:IsPlayer() and ent:Team() == self.Entity:GetOwner():Team() then return end
	
	if not ent:IsNPC() and not ent:IsPlayer() then return end
	
	ent:DoIgnite( self.Entity:GetOwner() )
	
end 

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end
