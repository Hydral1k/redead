if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Claws"
	SWEP.IconLetter = "C"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	killicon.AddFont( "rad_z_banshee", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.Base = "rad_z_base"

SWEP.ViewModel = "models/Zed/weapons/v_banshee.mdl"

SWEP.Taunt = Sound( "npc/stalker/go_alert2a.wav" )

SWEP.Die = { "npc/headcrab_poison/ph_scream1.wav",
"npc/headcrab_poison/ph_scream2.wav",
"npc/headcrab_poison/ph_scream3.wav"}

SWEP.Primary.Hit            = Sound( "npc/antlion/shell_impact3.wav" )
SWEP.Primary.HitFlesh		= Sound( "npc/antlion/foot4.wav" )
SWEP.Primary.Sound			= Sound( "npc/zombie/zo_attack1.wav" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 1.800

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= true

function SWEP:NoobHelp()

	self.Owner:NoticeOnce( "Right click to use your scream ability", GAMEMODE.Colors.Blue, 5, 10 )
	self.Owner:NoticeOnce( "Your scream will disorient nearby people", GAMEMODE.Colors.Blue, 5, 12 )

end

function SWEP:Holster()

	if SERVER then
	
		self.Owner:EmitSound( table.Random( self.Die ), 100, math.random(40,60) )
	
	end
	
	return true

end

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 8 )
	
	if SERVER then
	
		self.Owner:VoiceSound( self.Taunt, 100, math.random( 90, 100 ) )
		
		local hit = false
		
		for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		
			local dist = v:GetPos():Distance( self.Owner:GetPos() )
			
			if dist <= 400 then
			
				local scale = 1 - ( dist / 400 )
				local count = math.Round( scale * 4 )
				
				umsg.Start( "Drunk", v )
				umsg.Short( count )
				umsg.End()

				umsg.Start( "ScreamHit", v )
				umsg.End()
				
				v:TakeDamage( scale * 25, self.Owner, self.Weapon )
				v:SetDSP( 34, false )
				
				self.Owner:AddZedDamage( 25 )
				
				hit = true
			
			end
		
		end
		
		if hit then
		
			self.Owner:Notice( "You disoriented a human", GAMEMODE.Colors.Green )
		
		end
	
	end

end

function SWEP:PrimaryAttack()
	
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(130,150) )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.ThinkTime = CurTime() + ( self.Primary.Delay * 0.3 )
	
end

function SWEP:MeleeTrace( dmg )
	
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	
	if CLIENT then return end
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
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
			ent:AddRadiation( 1 )
			ent:EmitSound( self.Primary.HitFlesh, 100, math.random(90,110) )
			
			self.Owner:AddZedDamage( 25 )
			
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
						
						local dir = ent:GetPos() - self.Owner:GetPos()
						dir:Normalize()
						
						local phys = prop:GetPhysicsObject()
						
						if IsValid( phys ) then
						
							phys:ApplyForceCenter( dir * phys:GetMass() * 800 )

						end
						
						ent:EmitSound( Sound( "Wood_Crate.Break" ) )
						ent:Remove()
						ent = nil
						
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
				ent:TakeDamage( 25, self.Owner, self.Weapon )
				ent:EmitSound( self.Primary.Hit, 100, math.random(90,110) )
				
				phys:Wake()
				phys:ApplyForceCenter( self.Owner:GetAimVector() * phys:GetMass() * 300 )
				
			end
			
		end
		
	end

end

function SWEP:DrawHUD()
	
end
