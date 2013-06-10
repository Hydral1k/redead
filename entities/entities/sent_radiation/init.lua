
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Scale = 1
ENT.Distance = 300

function ENT:Initialize()
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
	
	self.Entity:SetCollisionBounds( Vector( -60, -60, -60 ), Vector( 60, 60, 60 ) )
	self.Entity:PhysicsInitBox( Vector( -60, -60, -60 ), Vector( 60, 60, 60 ) )
	
	self.Entity:SetNWInt( "Distance", self.Distance )
	
	self.DieTime = CurTime() + 30
	
end

function ENT:SetDistance( num )

	self.Distance = num

end

function ENT:SetLifeTime( num )

	self.LifeTime = num

end

function ENT:OnRemove()

end

function ENT:Think()

	if self.DieTime < CurTime() then
	
		self.Entity:Remove()
		
	end
	
	self.Scale = ( self.DieTime - CurTime() ) / 30
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		local dist = v:GetPos():Distance( self.Entity:GetPos() )
		
		if dist < ( self.Distance * self.Scale ) + 100 then
		
			if dist < ( self.Distance * self.Scale ) then
		
				if ( v.RadAddTime or 0 ) < CurTime() then
			
					v.RadAddTime = CurTime() + 8
					v:AddRadiation( 1 )
					
				end
		
			end
		
			if ( v.NextRadSound or 0 ) < CurTime() then
			
				local scale = math.Clamp( (  ( self.Distance * self.Scale ) + 100 - dist ) / (  ( self.Distance * self.Scale ) ), 0.1, 1.0 )
			
				v.NextRadSound = CurTime() + 1 - scale 
				v:EmitSound( table.Random( GAMEMODE.Geiger ), 100, math.random( 80, 90 ) + scale * 20 )
				v:NoticeOnce( "A radioactive deposit is nearby", GAMEMODE.Colors.Blue )
				
			end
		
		end
	
	end

end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end
