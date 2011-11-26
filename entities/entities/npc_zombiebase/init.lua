AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Legs = Model( "models/zombie/classic_legs.mdl" )

ENT.ClawHit = {"npc/zombie/claw_strike1.wav",
"npc/zombie/claw_strike2.wav",
"npc/zombie/claw_strike3.wav"}

ENT.ClawMiss = {"npc/zombie/claw_miss1.wav",
"npc/zombie/claw_miss2.wav"}

ENT.DoorHit = Sound("npc/zombie/zombie_hit.wav")

function ENT:Initialize()

	self.Entity:SetModel( "models/zombie/classic.mdl" )
	
	self.Entity:SetHullSizeNormal()
	self.Entity:SetHullType( HULL_HUMAN )
	
	self.Entity:SetSolid( SOLID_BBOX ) 
	self.Entity:SetMoveType( MOVETYPE_STEP )
	self.Entity:CapabilitiesAdd( CAP_MOVE_GROUND | CAP_INNATE_MELEE_ATTACK1 ) 
	
	self.Entity:SetMaxYawSpeed( 5000 )
	self.Entity:SetHealth( 100 )
	
	self.Entity:DropToFloor()
	
	self.Entity:UpdateEnemy( self.Entity:FindEnemy() )
	
	self.NextUpdate = 0
	self.DmgTable = {}

end

function ENT:VoiceSound( tbl )

	if ( self.VoiceTime or 0 ) > CurTime() then return end

	self.VoiceTime = CurTime() + 1.5
	
	self.Entity:EmitSound( Sound( table.Random( tbl ) ), 100, math.random( 90, 100 ) )
	
end

function ENT:SpawnRagdoll( model, pos )

	if not model then
	
		self:Fire( "BecomeRagdoll", "", 0 )
		
	else
	
		local ang = self.Entity:GetAngles()
	
		local shooter = ents.Create("env_shooter")
        shooter:SetPos( pos or self.Entity:GetPos() )
        shooter:SetKeyValue( "m_iGibs", "1" )
        shooter:SetKeyValue( "shootsounds", "3" )
        shooter:SetKeyValue( "gibangles", ang.p.." "..ang.y.." "..ang.r )
        shooter:SetKeyValue( "angles", ang.p.." "..ang.y.." "..ang.r )
        shooter:SetKeyValue( "shootmodel", model ) 
        shooter:SetKeyValue( "simulation", "2" )
        shooter:SetKeyValue( "gibanglevelocity", math.random(-50,50).." "..math.random(-150,150).." "..math.random(-150,150) )
        shooter:SetKeyValue( "m_flVelocity", tostring( math.Rand( -20, 20 ) ) )
        shooter:SetKeyValue( "m_flVariance", tostring( math.Rand( -2, 2 ) ) )
        
        shooter:Spawn()
        
        shooter:Fire( "shoot", 0, 0 )
        shooter:Fire( "kill", 0.1, 0.1 )
	
	end

end

function ENT:OnDeath( dmginfo )

end

function ENT:DoDeath( dmginfo )

	if self.Dying then return end
	
	self.Dying = true
	
	self.Entity:SetNPCState( NPC_STATE_DEAD )
	//self.Entity:SetSchedule( SCHED_DIE_RAGDOLL )
	
	self.Entity:OnDeath( dmginfo )
	
	if dmginfo and dmginfo:IsExplosionDamage() then	
	
		self.Entity:SetModel( table.Random( GAMEMODE.Corpses ) )
		self.Entity:EmitSound( table.Random( GAMEMODE.GoreSplash ), 90, math.random( 40, 60 ) )
		
		local ed = EffectData()
		ed:SetOrigin( self.Entity:GetPos() )
		util.Effect( "gore_explosion", ed, true, true )
		
	end
	
	if dmginfo then
	
		if dmginfo:IsExplosionDamage() and ValidEntity( dmginfo:GetAttacker() ) and dmginfo:GetAttacker():IsPlayer() then
		
			dmginfo:GetAttacker():AddStat( "Explode" )
		
		end
		
		local ent1 = self.Entity:GetHighestDamager()
		local tbl = self.Entity:GetHighestDamagers()
		
		if ValidEntity( ent1 ) then
			
			ent1:AddCash( 2 )
			ent1:AddFrags( 1 )
			
			local dist = math.floor( ent1:GetPos():Distance( self.Entity:GetPos() ) / 8 )
			
			if dist > ent1:GetStat( "Longshot" ) then
			
				ent1:SetStat( "Longshot", dist )
			
			end
			
			self.RemoveTimer = CurTime()
			
			if ent1:HasShotgun() and ent1:GetPos():Distance( self.Entity:GetPos() ) < 100 then
			
				self.Entity:EmitSound( table.Random( GAMEMODE.GoreSplash ), 90, math.random( 60, 80 ) )
				
				local effectdata = EffectData()
				effectdata:SetOrigin( self.Entity:GetPos() + Vector(0,0,20) )
				util.Effect( "body_gib", effectdata, true, true )
				
				self.Entity:SpawnRagdoll( self.Legs )
				
				ent1:AddStat( "Meat" )
			
			elseif self.HeadshotEffects and self.Entity:GetHeadshotter( ent1 ) then
			
				self.Entity:EmitSound( table.Random( GAMEMODE.GoreSplash ), 90, math.random( 90, 110 ) )
			
				umsg.Start( "Headless" )
				umsg.Vector( self.Entity:GetPos() )
				umsg.End()
				
				local effectdata = EffectData()
				effectdata:SetOrigin( self.Entity:GetPos() + Vector(0,0,40) )
				util.Effect( "head_gib", effectdata, true, true )
				
				self.Entity:SpawnRagdoll()
				
				self.RemoveTimer = CurTime() + 0.1
			
			else
			
				self.Entity:VoiceSound( self.VoiceSounds.Death )
			
			end
		
		end
		
		if tbl then
		
			for k,v in pairs( tbl ) do
			
				if ValidEntity( v ) and v != ent1 then
				
					v:AddCash( 1 )
					v:AddStat( "Assist" )
				
				end
			
			end
		
		end
	
	end
	
end

function ENT:GetHeadshotter( attacker )

	if not self.DmgTable[ attacker ] then return false end
	
	return self.DmgTable[ attacker ].Headshot

end

function ENT:SetHeadshotter( attacker, head )

	if not self.DmgTable[ attacker ] then
	
		self.DmgTable[ attacker ] = {}
	
	end
	
	self.DmgTable[ attacker ].Headshot = head

end

function ENT:GetHighestDamager()

	local ent1 = NULL
	local high = 0

	for k,v in pairs( self.DmgTable ) do
	
		if ValidEntity( k ) and v.Dmg and v.Dmg > high then
			
			high = v.Dmg
			ent1 = k
		
		end
	
	end

	return ent1
	
end

function ENT:GetHighestDamagers()

	local high = 0
	local tbl = {}

	for k,v in pairs( self.DmgTable ) do
	
		if ValidEntity( k ) then

			table.insert( tbl, k )
		
		end
	
	end

	return tbl
	
end

function ENT:AddDamageTaken( attacker, dmg )

	if not attacker:IsPlayer() then return end

	if not self.DmgTable[ attacker ] then
	
		self.DmgTable[ attacker ] = {}
		self.DmgTable[ attacker ].Dmg = dmg
	
	elseif not self.DmgTable[ attacker ].Dmg then
	
		self.DmgTable[ attacker ].Dmg = dmg
	
	else
	
		self.DmgTable[ attacker ].Dmg = self.DmgTable[ attacker ].Dmg + dmg
	
	end

end

function ENT:OnTakeDamage( dmginfo )
	
	self.Entity:SetHealth( math.Clamp( self.Entity:Health() - dmginfo:GetDamage(), 0, 1000 ) )
	self.Entity:AddDamageTaken( dmginfo:GetAttacker(), dmginfo:GetDamage() )
	
	if self.Entity:Health() <= 0 then
	
		self.Entity:DoDeath( dmginfo )
		
	elseif math.random(1,3) == 1 then
	
		self.Entity:VoiceSound( self.VoiceSounds.Pain )
		
	end
	
end 

function ENT:FindEnemy()

	local tbl = team.GetPlayers( TEAM_ARMY )

	if #tbl < 1 then
		
		return NULL
		
	else
	
		local enemy = NULL
		local dist = 99999
		
		for k,v in pairs( tbl ) do
		
			local compare = v:GetPos():Distance( self.Entity:GetPos() )
			
			if compare < dist and v:Alive() and v:GetObserverMode() == OBS_MODE_NONE then
			
				enemy = v
				dist = compare
				
			end
			
		end
		
		return enemy
		
	end
	
end

function ENT:UpdateEnemy( enemy )

	if ValidEntity( enemy ) and enemy:Alive() and enemy:GetObserverMode() == OBS_MODE_NONE then
		
		self:SetEnemy( enemy, true ) 
		self:UpdateEnemyMemory( enemy, enemy:GetPos() ) 
		
	else
		
		self:SetEnemy( NULL )
		
	end

end

function ENT:CloseDoor()

	local tbl = ents.FindByClass( "prop_door_rotating" )
	tbl = table.Add( tbl, ents.FindByClass( "func_breakabl*" ) )
	tbl = table.Add( tbl, ents.FindByClass( "func_door*" ) )
	tbl = table.Add( tbl, ents.FindByModel( "models/props_debris/wood_board04a.mdl" ) )

	for k,v in pairs( tbl ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < 100 then
		
			return v
		
		end
	
	end
	
	return NULL

end

function ENT:OnThink()

end

function ENT:Think()

	self.Entity:OnThink()

	if self.RemoveTimer and self.RemoveTimer < CurTime() then
	
		self.Entity:Remove()
	
	end
	
	if ( self.DoorFindTime or 0 ) < CurTime() then
	
		self.DoorFindTime = CurTime() + 3
		
		local door = self.Entity:CloseDoor()
		
		if ValidEntity( door ) then
		
			self.AttackDoor = door
			
			self.Entity:SelectSchedule()
		
		else
		
			self.AttackDoor = nil
		
		end
	
	end

	if ( self.RemoveTime or 0 ) < CurTime() then
	
		if self.Entity:GetPos() == ( self.RemovePos or Vector(0,0,0) ) then

			self.Entity:Remove()
			
		end
		
		self.RemoveTime = CurTime() + 20
		self.RemovePos = self.Entity:GetPos()
	
	end

	if ( self.IdleTalk or 0 ) < CurTime() then
	
		self.Entity:VoiceSound( self.VoiceSounds.Taunt )
		self.IdleTalk = CurTime() + math.random(15,30)
		
	end
	
	if self.AttackTime and self.AttackTime < CurTime() then
	
		self.AttackTime = nil
		local enemy = self.Entity:GetEnemy()
		
		if ValidEntity( enemy ) and enemy:GetPos():Distance( self.Entity:GetPos() ) < 64 then
		
			enemy:TakeDamage( self.Damage, self.Entity )
			
			if enemy:IsPlayer() then
			
				self.Entity:OnDamageEnemy( enemy )
				
			end
			
			local sound = table.Random( self.ClawHit )
			self.Entity:EmitSound( Sound( sound ), 100, math.random(90,110) )

		elseif ValidEntity( self.AttackDoor ) and self.AttackDoor:GetPos():Distance( self.Entity:GetPos() ) < 100 then
		
			if string.find( self.AttackDoor:GetClass(), "func_breakable" ) then
			
				self.AttackDoor:TakeDamage( 25, self.Entity, self.Entity )
				self.Entity:EmitSound( self.DoorHit, 100, math.random(90,110) )
				
				if self.AttackDoor:GetClass() == "func_breakable_surf" then
			
					self.AttackDoor:Fire( "shatter", "1 1 1", 0 )

				end
			
			elseif string.find( self.AttackDoor:GetClass(), "func_door" ) then
			
				self.Entity:EmitSound( self.DoorHit, 100, math.random(90,110) )
				
				self.AttackDoor:Remove()
				self.AttackDoor = nil
			
			else
		
				if not self.AttackDoor.Hits then
				
					self.AttackDoor.Hits = 1
					self.AttackDoor.MaxHits = math.random(5,10)
					
					self.Entity:EmitSound( self.DoorHit, 100, math.random(90,110) )
					
					self.AttackDoor:EmitSound( Sound( "Wood_Plank.Break" ) )
				
				else
				
					self.AttackDoor.Hits = self.AttackDoor.Hits + 1
					
					if self.AttackDoor.Hits > self.AttackDoor.MaxHits then
					
						if self.AttackDoor:GetModel() != "models/props_debris/wood_board04a.mdl" then
					
							local prop = ents.Create( "prop_physics" )
							prop:SetModel( self.AttackDoor:GetModel() )
							prop:SetPos( self.AttackDoor:GetPos() )
							prop:SetAngles( self.AttackDoor:GetAngles() + Angle(10,0,2) )
							prop:SetSkin( self.AttackDoor:GetSkin() )
							prop:SetCollisionGroup( COLLISION_GROUP_WEAPON )
							prop:Spawn()
							
							local dir = ( self.AttackDoor:GetPos() - self.Entity:GetPos() ):Normalize()
							local phys = prop:GetPhysicsObject()
							
							if ValidEntity( phys ) then
							
								phys:ApplyForceCenter( dir * phys:GetMass() * 800 )

							end
							
							self.AttackDoor:EmitSound( Sound( "Wood_Crate.Break" ) )
							self.AttackDoor:Remove()
							
							self.AttackDoor = nil
							
						else
						
							self.AttackDoor:Fire( "break", "", 0 )
						
						end
						
						self.Entity:EmitSound( self.DoorHit, 100, math.random(90,110) )

					else
					
						self.Entity:EmitSound( self.DoorHit, 100, math.random(90,110) )
					
						self.AttackDoor:EmitSound( Sound( "Wood_Plank.Break" ) )
					
					end
				
				end
		
			end
		
		else
		
			local sound = table.Random( self.ClawMiss )
			self.Entity:EmitSound( Sound( sound ), 100, math.random(90,110) )
		
		end
	
	end
	
end

function ENT:OnDamageEnemy( enemy )

end

function ENT:GetRelationship( entity )

	if ValidEntity( entity ) and ( entity:IsPlayer() and entity:Team() == TEAM_ARMY ) then return D_HT end
	
	return D_LI
	
end

function ENT:SelectSchedule()

	if GetGlobalBool( "GameOver", false ) then
	
		self.Entity:SetSchedule( SCHED_CHASE_ENEMY )
		
		return
	
	end

	local enemy = self.Entity:GetEnemy()
	local sched = SCHED_IDLE_WANDER 
	
	if ValidEntity( enemy ) or ValidEntity( self.AttackDoor ) then
	
		if self.Entity:HasCondition( 23 ) or ValidEntity( self.AttackDoor ) then  
		
			sched = SCHED_MELEE_ATTACK1
			self.AttackTime = CurTime() + 0.5
			self.Entity:VoiceSound( self.VoiceSounds.Attack )
			
		else
		
			sched = SCHED_CHASE_ENEMY
			
			if ( self.NextUpdate or 0 ) < CurTime() then
			
				self.Entity:UpdateEnemy( enemy )
				self.NextUpdate = CurTime() + 1
			
			end
			
		end
		
	else
	
		self.Entity:UpdateEnemy( self.Entity:FindEnemy() )
		
	end

	self.Entity:SetSchedule( sched ) 

end
