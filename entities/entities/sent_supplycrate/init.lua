
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Bang = Sound( "Wood.ImpactHard" )
ENT.Open = Sound( "Wood.Strain" )
ENT.Model = Model( "models/Items/item_item_crate.mdl" )

function ENT:Initialize()
	
	self.Entity:SetModel( self.Model )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()

	end
	
	self.Entity:SetColor( Color( 255, 200, 150, 255 ) )

	self.Removing = false
	self.Contents = { 1 }

end

function ENT:Think() 
	
	if IsValid( self.User ) and self.User:Alive() and self.User:Team() == TEAM_ARMY then return end
	
	self.Entity:SetColor( Color( 255, 255, 150, 255 ) )
	
end 

function ENT:SetContents( tbl )

	self.Contents = tbl

end

function ENT:SetUser( ply )

	self.User = ply

end

function ENT:Use( ply, caller )

	if IsValid( self.User ) and self.User:Alive() and self.User:Team() == TEAM_ARMY and ply != self.User then return end
	
	if ply:Team() != TEAM_ARMY then return end

	if self.Removing then return end

	ply:AddMultipleToInventory( self.Contents )

	self.Entity:EmitSound( self.Open )
	self.Entity:Remove()

end

function ENT:PhysicsCollide( data, phys )

	if data.Speed > 50 and data.DeltaTime > 0.15 then
	
		self.Entity:EmitSound( self.Bang )
		
	end
	
end

