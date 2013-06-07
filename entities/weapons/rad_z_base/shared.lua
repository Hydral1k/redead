if SERVER then

	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Claws"
	SWEP.IconLetter = "C"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	killicon.AddFont( "rad_z_common", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "slam"

SWEP.Base = "rad_base"

SWEP.ViewModel = "models/zed/weapons/v_undead.mdl"

SWEP.IsSniper = false
SWEP.AmmoType = "Knife"
SWEP.ThinkTime = 0

SWEP.Primary.Door           = Sound( "Wood_Plank.Break" )
SWEP.Primary.Hit            = Sound( "npc/zombie/claw_strike1.wav" )
SWEP.Primary.HitFlesh		= Sound( "npc/zombie/claw_strike2.wav" )
SWEP.Primary.Sound			= Sound( "npc/fast_zombie/idle1.wav" )
SWEP.Primary.Miss           = Sound( "npc/zombie/claw_miss1.wav" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 35
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 1.500

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= true

function SWEP:GetViewModelPosition( pos, ang )

	return pos, ang
	
end

function SWEP:NoobHelp()

	self.Owner:NoticeOnce( "Hit people to infect them", GAMEMODE.Colors.Blue, 5, 10 )

end

function SWEP:Deploy()

	self.Owner:DrawWorldModel( false )
	
	if SERVER then
	
		self.Weapon:NoobHelp()
	
	end
	
	return true

end

function SWEP:Holster()

	if SERVER then
	
		self.Owner:EmitSound( table.Random( self.Die ), 100, math.random(90,110) ) 
	
	end
	
	return true

end

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 2.5 )
	
	if SERVER then
	
		self.Owner:VoiceSound( table.Random( self.Taunt ), 100, math.random( 90, 100 ) )
	
	end

end

function SWEP:PrimaryAttack()
	
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(90,110) )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.ThinkTime = CurTime() + ( self.Primary.Delay * 0.3 )
	
end

function SWEP:Think()	

	if self.ThinkTime != 0 and self.ThinkTime < CurTime() then
	
		self.Weapon:MeleeTrace( self.Primary.Damage )
		
		self.ThinkTime = 0
	
	end

end

function SWEP:OnHitHuman( ent, dmg )

	if not ent:IsInfected() then
			
		ent:SetInfected( true )
		
		self.Owner:Notice( "You infected a human", GAMEMODE.Colors.Green )
		self.Owner:AddZedDamage( 15 )
				
	end
	
	self.Owner:AddZedDamage( dmg )
	self.Owner:DrawBlood( 3 )
	
end

function SWEP:MeleeTrace( dmg )
	
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	
	if CLIENT then return end
	
	self.Weapon:SetNWString( "CurrentAnim", "zattack" .. math.random(1,3) )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 80
	
	local line = {}
	line.start = pos
	line.endpos = pos + aim
	line.filter = self.Owner
	
	local linetr = util.TraceLine( line )
	
	local tr = {}
	tr.start = pos + self.Owner:GetAimVector() * -5
	tr.endpos = pos + aim
	tr.filter = self.Owner
	tr.mins = Vector(-16,-16,-16)
	tr.maxs = Vector(16,16,16)

	local trace = util.TraceHull( tr )
	local ent = trace.Entity
	local ent2 = linetr.Entity
	
	if not IsValid( ent ) and IsValid( ent2 ) then
	
		ent = ent2
	
	end

	if not IsValid( ent ) then 
		
		self.Owner:EmitSound( self.Primary.Miss, 100, math.random(90,110) )
		
		return 
		
	elseif not ent:IsWorld() then
		
		if ent:IsPlayer() and ent:Team() == TEAM_ARMY then
		
			ent:TakeDamage( dmg, self.Owner, self.Weapon )
			ent:EmitSound( self.Primary.HitFlesh, 100, math.random(90,110) )
			
			self.Weapon:OnHitHuman( ent, dmg )
			
		elseif string.find( ent:GetClass(), "npc" ) then
		
			ent:TakeDamage( 20, self.Owner, self.Weapon )
			ent:EmitSound( self.Primary.HitFlesh, 100, math.random(90,110) )
		
		elseif !ent:IsPlayer() then 
		
			if ent:GetClass() == "prop_door_rotating" then
			
				if not ent.Hits then
			
					ent.Hits = 1
					ent.MaxHits = math.random(5,10)
					
					ent:EmitSound( Sound( "Wood_Plank.Break" ) )
				
				else
				
					ent.Hits = ent.Hits + 1
					
					if ent.Hits > ent.MaxHits then
					
						local prop = ents.Create( "prop_physics" )
						prop:SetPos( ent:GetPos() )
						prop:SetAngles( ent:GetAngles() + Angle(10,0,2) )
						prop:SetModel( ent:GetModel() )
						prop:SetSkin( ent:GetSkin() )
						prop:SetCollisionGroup( COLLISION_GROUP_WEAPON )
						prop:Spawn()
						
						local dir = ent:GetPos() - self.Owner:GetShootPos() 
						dir:Normalize()
						
						local phys = prop:GetPhysicsObject()
						
						if IsValid( phys ) then
						
							phys:ApplyForceCenter( dir * phys:GetMass() * 800 )

						end
						
						ent:EmitSound( Sound( "Wood_Crate.Break" ) )
						ent:Remove()
						
						return
					
					else
					
						ent:EmitSound( Sound( "Wood_Plank.Break" ) )
					
					end
				
				end
		
			elseif string.find( ent:GetClass(), "breakable" ) then
			
				ent:TakeDamage( 50, self.Owner, self.Weapon )
				ent:EmitSound( self.Primary.Hit, 100, math.random(90,110) )
				
				if ent:GetClass() == "func_breakable_surf" then
				
					ent:Fire( "shatter", "1 1 1", 0 )
					
					return
				
				end
			
			end
			
			local phys = ent:GetPhysicsObject()
			
			if IsValid( phys ) then
			
				ent:SetPhysicsAttacker( self.Owner )
				ent:EmitSound( self.Primary.Hit, 100, math.random(90,110) )
				
				if ent.IsWood then
				
					ent:TakeDamage( 75, self.Owner, self.Weapon )
					ent:EmitSound( self.Primary.Door )
				
				else
				
					ent:TakeDamage( 25, self.Owner, self.Weapon )
				
				end
				
				phys:Wake()
				phys:ApplyForceCenter( self.Owner:GetAimVector() * phys:GetMass() * 400 )
				
			end
			
		end
		
	end

end

function SWEP:DrawHUD()
	
end
