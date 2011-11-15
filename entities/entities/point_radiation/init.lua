
ENT.Type 			= "point"
ENT.Base 			= "base_point"

function ENT:Initialize()
	
	self.Active = true
	self.Radius = 400
	self.SoundRadius = 800
	self.Pos = self.Entity:GetPos()
	
end

function ENT:SetArtifact( ent )

	self.Artifact = ent

end

function ENT:GetArtifact()

	return self.Artifact or NULL

end

function ENT:SetActive( bool )

	self.Active = bool

end

function ENT:IsActive()

	return self.Active

end

function ENT:KeyValue( key, value )

	if key == "radius" then
	
		self.Radius = math.Clamp( tonumber( value ), 100, 5000 )
		self.SoundRadius = self.Radius * 1.4
	
	elseif key == "randomradius" then
	
		self.Radius = math.random( 100, math.Clamp( tonumber( value ), 500, 5000 ) )
		self.SoundRadius = self.Radius * 1.4
	
	end

end

function ENT:GetRadiationRadius()

	return self.Radius

end

function ENT:Think()

	if not self.Active then return end
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		local dist = v:GetPos():Distance( self.Pos )
		
		if dist < self.SoundRadius then
		
			if dist < self.Radius then
		
				if ( v.RadAddTime or 0 ) < CurTime() then
			
					v.RadAddTime = CurTime() + 10
					v:AddRadiation( 1 )
					
				end
		
			end
		
			if ( v.NextRadSound or 0 ) < CurTime() then
			
				local scale = math.Clamp( ( self.SoundRadius - dist ) / ( self.SoundRadius - self.Radius ), 0.1, 1.0 )
			
				v.NextRadSound = CurTime() + 1 - scale 
				v:EmitSound( table.Random( GAMEMODE.Geiger ), 100, math.random( 80, 90 ) + scale * 20 )
				
			end
		
		end
	
	end
	
end
