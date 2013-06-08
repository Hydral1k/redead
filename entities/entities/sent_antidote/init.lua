
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Cure = Sound( "ItemBattery.Touch" )
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
	
	self.Entity:SetColor( Color( 150, 255, 200, 255 ) )
	
	self.CureCount = math.max( team.NumPlayers( TEAM_ARMY ) / 2, 1 )

end

function ENT:Think() 
	
end 

function ENT:SetOverride()

	self.Override = true

end

function ENT:SetCures( num )

	self.CureCount = num

end

function ENT:CuresLeft()

	return self.CureCount

end

function ENT:Use( ply, caller )

	if self.Removing then return end

	if ply:IsInfected() then
	
		ply:SetInfected( false )
		ply:AddStamina( 20 )
		ply:EmitSound( self.Cure )
		ply:Notice( "Your infection has been cured", GAMEMODE.Colors.Green )

		if not self.Override then
		
			self.CureCount = self.CureCount - 1
			
		end
	
	end
	
	if self.CureCount < 1 then
	
		self.Entity:Remove()
	
	end

end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end
