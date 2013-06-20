if SERVER then

	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Knife"
	SWEP.IconLetter = "j"
	SWEP.Slot = 1
	SWEP.Slotpos = 0
	
end

SWEP.HoldType = "knife"

SWEP.Base = "rad_base"

SWEP.ViewModel			= "models/weapons/v_knife_t.mdl"
SWEP.WorldModel			= "models/weapons/w_knife_t.mdl"

SWEP.IsSniper = false
SWEP.AmmoType = "Knife"

SWEP.Primary.Hit            = Sound( "Weapon_Knife.HitWall" )
SWEP.Primary.HitFlesh		= Sound( "Weapon_Knife.Hit" )
SWEP.Primary.Sound			= Sound( "Weapon_Knife.Slash" )
SWEP.Primary.Deploy         = Sound( "Weapon_Knife.Deploy" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 35
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 0.950

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= true

function SWEP:GetViewModelPosition( pos, ang )

	return pos, ang
	
end

function SWEP:SecondaryAttack()

end

function SWEP:PrimaryAttack()
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:MeleeTrace( self.Primary.Damage )
	
	if SERVER then
	
		self.Owner:AddStamina( -1 )
	
	end
	
end

function SWEP:Think()	

end

function SWEP:MeleeTrace( dmg )

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	
	if CLIENT then return end
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 64
	
	local line = {}
	line.start = pos
	line.endpos = pos + aim
	line.filter = self.Owner
	
	local linetr = util.TraceLine( line )
	
	local tr = {}
	tr.start = pos + self.Owner:GetAimVector() * -5
	tr.endpos = pos + aim
	tr.filter = self.Owner
	tr.mask = MASK_SHOT_HULL
	tr.mins = Vector(-20,-20,-20)
	tr.maxs = Vector(20,20,20)

	local trace = util.TraceHull( tr )
	local ent = trace.Entity
	local ent2 = linetr.Entity
	
	if not IsValid( ent ) and IsValid( ent2 ) then
	
		ent = ent2
	
	end

	if not IsValid( ent ) then 
		
		self.Owner:EmitSound( self.Primary.Sound, 100, math.random(90,110) )
		return 
		
	elseif not ent:IsWorld() then
	
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
		self.Owner:AddStamina( -2 )
		
		if ent:IsPlayer() then 
			
			ent:EmitSound( self.Primary.HitFlesh, 100, math.random(90,110) )
			
			if ent:Team() != self.Owner:Team() then
		
				ent:TakeDamage( dmg, self.Owner, self.Weapon )
			
				self.Owner:DrawBlood()
			
				local ed = EffectData()
				ed:SetOrigin( trace.HitPos )
				util.Effect( "BloodImpact", ed, true, true )
				
			end
			
		elseif string.find( ent:GetClass(), "npc" ) then
		
			ent:TakeDamage( dmg, self.Owner, self.Weapon )
			ent:EmitSound( self.Primary.HitFlesh, 100, math.random(90,110) )
			
			self.Owner:DrawBlood()
			
			local ed = EffectData()
			ed:SetOrigin( trace.HitPos )
			util.Effect( "BloodImpact", ed, true, true )
		
		elseif !ent:IsPlayer() then 
		
			if string.find( ent:GetClass(), "breakable" ) then
			
				ent:TakeDamage( 50, self.Owner, self.Weapon )
				
				if ent:GetClass() == "func_breakable_surf" then
				
					ent:Fire( "shatter", "1 1 1", 0 )
				
				end
			
			end
		
			ent:EmitSound( self.Primary.Hit, 100, math.random(90,110) )
			
			local phys = ent:GetPhysicsObject()
			
			if IsValid( phys ) then
			
				if ent.IsWooden then
				
					ent:Fire( "break", 0, 0 )
				
				else
				
					ent:SetPhysicsAttacker( self.Owner )
					ent:TakeDamage( 10, self.Owner, self.Weapon )
					
					phys:Wake()
					phys:ApplyForceCenter( self.Owner:GetAimVector() * phys:GetMass() * 200 )
					
				end
				
			end
			
		end
		
	end

end

function SWEP:DrawHUD()
	
end

function SWEP:Deploy()

	if SERVER then
	
		self.Owner:DrawViewModel( true )
		self.Owner:EmitSound( self.Primary.Deploy, 100, math.random(90,110) )
		
	end	

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end  
