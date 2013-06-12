
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	if string.find( self.Entity:GetModel(), "hammer" ) or string.find( self.Entity:GetModel(), "axe" ) then

		local model = self.Entity:GetModel()
	
		self.Entity:SetModel( "models/props_canal/mattpipe.mdl" )
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetModel( model )
	
		//self.Entity:PhysicsInitBox( Vector(-5,-5,-5), Vector(5,5,5) )

	else
	
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
	
	end
	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()

	end

end

function ENT:Think() 
	
end 

function ENT:Use( ply, caller )

	if ply:Team() != TEAM_ARMY then return end
	
	ply:AddToInventory( self.Entity )

end
