
function EFFECT:Init( data )

	self.Entity:SetModel( table.Random( GAMEMODE.BarrelGibs ) )

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	//self.Entity:SetMaterial( "models/flesh" )
	
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
		phys:SetVelocity( vec * math.Rand( 100, 200 ) )
	
	end
	
	self.LifeTime = CurTime() + 15
	
end

function EFFECT:Think( )

	return self.LifeTime > CurTime()
	
end

function EFFECT:Render()

	self.Entity:DrawModel()

end

