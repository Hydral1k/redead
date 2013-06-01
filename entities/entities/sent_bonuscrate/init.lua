
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Bang = Sound( "Wood.ImpactHard" )
ENT.Open = Sound( "Wood.Strain" )
ENT.Model = Model( "models/items/ammocrate_smg1.mdl" )

function ENT:Initialize()
	
	self.Entity:SetModel( self.Model )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()
		phys:SetDamping( 0, 200 )

	end

	self.Removing = false
	self.Contents = { 1 }
	self.Users = {}
	self.Uses = math.random( 1, 5 ) 

end

function ENT:Think() 
	
end 

function ENT:GenerateContents()

	self.Contents = {}
	
	local tbl = { ITEM_WPN_COMMON, ITEM_AMMO, ITEM_AMMO }
	
	if math.random( 1, 50 ) == 1 then
	
		tbl = { ITEM_WPN_SPECIAL, ITEM_AMMO, ITEM_AMMO }
	
	end

	for k,v in pairs( tbl ) do
	
		local tbl = item.RandomItem( v )
		local id = tbl.ID
		
		table.insert( self.Contents, id )
	
	end

end

function ENT:AddUser( ply )

	table.insert( self.Users, ply )

end

function ENT:Use( ply, caller )

	if not IsValid( ply ) or table.HasValue( self.Users, ply ) or ply:Team() != TEAM_ARMY or self.Removing then return end

	self.Entity:EmitSound( self.Open )
	self.Entity:GenerateContents()
	
	ply:AddMultipleToInventory( self.Contents )
	
	table.insert( self.Users, ply )
	
	if table.Count( self.Users ) == self.Uses then	

		self.Entity:Remove()
		
	end

end

function ENT:PhysicsCollide( data, phys )

	if data.Speed > 50 and data.DeltaTime > 0.15 then
	
		self.Entity:EmitSound( self.Bang )
		
	end
	
end

