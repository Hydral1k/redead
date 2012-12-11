
function EFFECT:Init( data )

	local scale = data:GetScale()

	if scale < 2 then
		self.Entity:SetModel( table.Random( GAMEMODE.SmallGibs ) )
	else
		self.Entity:SetModel( table.Random( GAMEMODE.BigGibs ) ) 
	end

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMaterial( "models/flesh" )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
	self.Entity:SetAngles( Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360) ) )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		local vec = VectorRand()
		vec.z = math.Clamp( vec.z, -0.4, 0.8 )
	
		phys:Wake()
		phys:SetMass( 100 )
		phys:AddAngleVelocity( VectorRand() * 500 )
		phys:SetMaterial( "gmod_silent" )
		
		if scale < 2 then
		
			phys:SetVelocity( vec * math.Rand( 100, 200 ) )
		
		else
		
			phys:SetVelocity( vec * math.Rand( 300, 600 ) )
		
		end
	
	end
	
	self.LifeTime = CurTime() + 15
	
end

function EFFECT:Think( )

	return self.LifeTime > CurTime()
	
end

function EFFECT:Render()

	self.Entity:DrawModel()

end

