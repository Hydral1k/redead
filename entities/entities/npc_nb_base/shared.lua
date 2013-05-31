
AddCSLuaFile()

ENT.Base = "base_nextbot"

// Moddable

ENT.Skins = 0
ENT.AttackAnims = nil
ENT.AnimSpeed = 0.8
ENT.AttackTime = 0.5
ENT.MeleeDistance = 64
ENT.BreakableDistance = 96
ENT.Damage = 35
ENT.BaseHealth = 100
ENT.MoveSpeed = 225
ENT.JumpHeight = 80
ENT.BumpSpeed = 500
ENT.MoveAnim = ACT_RUN

ENT.Models = nil
ENT.Legs = Model( "models/zombie/classic_legs.mdl" )
ENT.Model = Model( "models/zombie/classic.mdl" ) 

ENT.WoodHit = Sound( "Wood_Plank.Break" )
ENT.WoodBust = Sound( "Wood_Crate.Break" ) 

ENT.ClawHit = { Sound( "npc/zombie/claw_strike1.wav" ),
Sound( "npc/zombie/claw_strike2.wav" ),
Sound( "npc/zombie/claw_strike3.wav" ) }

ENT.ClawMiss = { Sound( "npc/zombie/claw_miss1.wav" ),
Sound( "npc/zombie/claw_miss2.wav" ) }

ENT.VoiceSounds = {}

// Other stuff

ENT.NextBot = true
ENT.ShouldDrawPath = false
ENT.Obstructed = false
ENT.FireDamageTime = 0
ENT.FireTime = 0

ENT.DoorHit = Sound( "npc/zombie/zombie_hit.wav" )

function ENT:Initialize()

	if self.Models then

		local model = table.Random( self.Models )
		self.Entity:SetModel( model )
		
	else
	
		self.Entity:SetModel( self.Model )
	
	end
	
	self.Entity:SetHealth( self.BaseHealth )
	//self.Entity:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE_DEBRIS )
	self.Entity:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) ) // nice fat shaming
	self.Entity:SetSkin( math.random( 0, self.Skins ) )
	
	self.loco:SetDeathDropHeight( 1000 )	
	self.loco:SetAcceleration( 500 )	
	self.loco:SetJumpHeight( self.JumpHeight )
	
	self.DmgTable = {}
	self.LastPos = self.Entity:GetPos()
	self.Stuck = CurTime() + 10
	
end

function ENT:Think()

	self.Entity:OnThink()
	
	if ( self.IdleTalk or 0 ) < CurTime() then
	
		self.Entity:VoiceSound( self.VoiceSounds.Taunt )
		self.IdleTalk = CurTime() + math.Rand(10,20)
		
	end
	
	if ( self.Stuck or 0 ) < CurTime() then
	
		self.Entity:StuckThink()
	
		self.Stuck = CurTime() + 10
		self.LastPos = self.Entity:GetPos() 
		
	end
	
	if self.Entity:OnFire() and self.FireDamageTime < CurTime() then
	
		self.FireDamageTime = CurTime() + 0.25
		
		self.Entity:TakeDamage( 10, self.FireAttacker )
	
	elseif self.FireSound and not self.Entity:OnFire() then
	
		self.Entity:StopFireSounds()
	
	end

	if self.CurAttack and self.CurAttack < CurTime() then
	
		self.CurAttack = nil
		
		if IsValid( self.CurEnemy ) then
		
			if self.CurEnemy:IsPlayer() then
			
				local enemy = self.Entity:CanAttackEnemy( self.CurEnemy )
				
				if IsValid( enemy ) then
				
					local snd = table.Random( self.ClawHit )
					self.Entity:EmitSound( snd, 100, math.random(90,110) )
					self.Entity:OnHitEnemy( enemy )
				
				else
				
					local snd = table.Random( self.ClawMiss )
					self.Entity:EmitSound( snd, 100, math.random(90,110) )
				
				end
			
			elseif self.CurEnemy:GetPos():Distance( self.Entity:GetPos() ) <= self.BreakableDistance or self.CurEnemy:GetClass() == "func_breakable_surf" then // todo: add case for npcs
			
				self.Entity:EmitSound( self.DoorHit, 100, math.random(90,110) )
				self.Entity:OnHitBreakable( self.CurEnemy )
			
			end
			
		else
		
			local snd = table.Random( self.ClawMiss )
			self.Entity:EmitSound( snd, 100, math.random(90,110) )
		
		end
	
	end

end

function ENT:OnThink()

end

function ENT:StuckThink()

	if self.LastPos:Distance( self.Entity:GetPos() ) < 50 then
	
		self.Entity:Respawn()
	
	end

end

function ENT:Respawn()

	for k,v in pairs( GAMEMODE.NPCSpawns ) do
	
		if IsValid( v ) then
	
			local box = ents.FindInBox( v:GetPos() + Vector( -32, -32, 0 ), v:GetPos() + Vector( 32, 32, 64 ) )
			local can = true
			
			for k,v in pairs( box ) do
			
				if v.NextBot then
				
					can = false
				
				end
			
			end
			
			if can then 
			
				self.Entity:SetPos( v:GetPos() )
				return
			
			end
			
		end
		
	end

end

function ENT:OnLimbHit( hitgroup, dmginfo )

	if hitgroup == HITGROUP_HEAD then
	
		self.Entity:EmitSound( "Player.DamageHeadShot" )
		self.Entity:SetHeadshotter( dmginfo:GetAttacker(), true )
		
		local effectdata = EffectData()
		effectdata:SetOrigin( dmginfo:GetDamagePosition() )
		util.Effect( "headshot", effectdata, true, true )
	
		dmginfo:ScaleDamage( 2.75 ) 
		dmginfo:GetAttacker():NoticeOnce( "Headshot combos earn you more " .. GAMEMODE.CurrencyName .. "s", GAMEMODE.Colors.Blue, 5 )
		dmginfo:GetAttacker():AddHeadshot()
		
    elseif hitgroup == HITGROUP_CHEST then
	
		dmginfo:ScaleDamage( 1.25 ) 
		
		self.Entity:SetHeadshotter( dmginfo:GetAttacker(), false )
		dmginfo:GetAttacker():ResetHeadshots()
		
	elseif hitgroup == HITGROUP_STOMACH then
	
		dmginfo:ScaleDamage( 0.75 ) 
		
		self.Entity:SetHeadshotter( dmginfo:GetAttacker(), false )
		dmginfo:GetAttacker():ResetHeadshots()
		
	else
	
		dmginfo:ScaleDamage( 0.50 )
		
		self.Entity:SetHeadshotter( dmginfo:GetAttacker(), false )
		dmginfo:GetAttacker():ResetHeadshots()
		
	end

end

function ENT:OnInjured( dmginfo )

	if dmginfo:IsExplosionDamage() then
	
		dmginfo:ScaleDamage( 1.75 )
	
	elseif not self.Entity:OnFire() then
	
		local snd = table.Random( GAMEMODE.GoreBullet )
		sound.Play( snd, self.Entity:GetPos() + Vector(0,0,50), 75, math.random( 90, 110 ), 1.0 )
	
	end
	
	//self.Entity:SetHealth( math.Clamp( self.Entity:Health() - dmginfo:GetDamage(), 0, 1000 ) )
	self.Entity:AddDamageTaken( dmginfo:GetAttacker(), dmginfo:GetDamage() )
	
	if self.Entity:Health() > 0 and math.random(1,2) == 1 then
	
		self.Entity:VoiceSound( self.VoiceSounds.Pain )
		
	end
	
end 

function ENT:SpawnRagdoll( damageinfo, model, pos, override )

	if not model then
	
		--[[umsg.Start( "Ragdoll" )
		umsg.Vector( self.Entity:GetPos() )
		
		if self.Entity:OnFire() then
		
			umsg.Short(2)
		
		else
		
			umsg.Short(1)
		
		end
		
		umsg.Short( self.Entity:EntIndex() )
		umsg.End()
		
		//self:Fire( "BecomeRagdoll", "", 0 ) ]]
		
		self.Entity:BecomeRagdoll( damageinfo )
		
	else
	
		local ang = self.Entity:GetAngles()
	
		local shooter = ents.Create( "env_shooter" )
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
		
		if not override then
		
			self.Entity:Remove()
			
		end
	
	end

end

function ENT:OnKilled( dmginfo )

	if self.Dying then return end
	
	self.Dying = true
	
	self.Entity:OnDeath( dmginfo )
	
	if dmginfo then
		
		local ent1 = self.Entity:GetHighestDamager()
		local tbl = self.Entity:GetHighestDamagers()
		
		if tbl then
		
			for k,v in pairs( tbl ) do
			
				if IsValid( v ) and v != ent1 then
				
					v:AddCash( GAMEMODE.AssistValues[ self.Entity:GetClass() ] )
					v:AddStat( "Assist" )
				
				end
			
			end
		
		end
		
		if IsValid( ent1 ) then
		
			if math.random(1,40) == 1 then
		
				ent1:RadioSound( VO_TAUNT )
				
			end
			
			ent1:AddCash( GAMEMODE.KillValues[ self.Entity:GetClass() ] )
			ent1:AddFrags( 1 )
			
			local dist = math.floor( ent1:GetPos():Distance( self.Entity:GetPos() ) / 8 )
			
			if dist > ent1:GetStat( "Longshot" ) then
			
				ent1:SetStat( "Longshot", dist )
			
			end
			
			if dmginfo:IsExplosionDamage() then
			
				local snd = table.Random( GAMEMODE.GoreSplash )
				self.Entity:EmitSound( snd, 90, math.random( 60, 80 ) )
				
				local effectdata = EffectData()
				effectdata:SetOrigin( self.Entity:GetPos() + Vector(0,0,20) )
				util.Effect( "body_gib", effectdata, true, true )
				
				local ed = EffectData()
				ed:SetOrigin( self.Entity:GetPos() )
				util.Effect( "gore_explosion", ed, true, true )
				
				ent1:AddStat( "Explode" )
				
				local corpse = table.Random( GAMEMODE.Corpses )
				self.Entity:SpawnRagdoll( dmginfo, corpse )
			
			elseif ent1:HasShotgun() and ent1:GetPos():Distance( self.Entity:GetPos() ) < 100 then
			
				local snd = table.Random( GAMEMODE.GoreSplash )
				self.Entity:EmitSound( snd, 90, math.random( 60, 80 ) )
				
				local effectdata = EffectData()
				effectdata:SetOrigin( self.Entity:GetPos() + Vector(0,0,20) )
				util.Effect( "body_gib", effectdata, true, true )
				
				ent1:AddStat( "Meat" )
				
				self.Entity:SpawnRagdoll( dmginfo, self.Legs )
				
			elseif ent1:HasMelee() then
				
				ent1:AddStat( "Knife" )
				
				self.Entity:VoiceSound( self.VoiceSounds.Death )
				self.Entity:SpawnRagdoll( dmginfo )
				
				if self.Entity:OnFire() then
				
					umsg.Start( "Burned" )
					umsg.Vector( self.Entity:GetPos() )
					umsg.End()
				
				end
			
			elseif self.Entity:GetHeadshotter( ent1 ) then //self.HeadshotEffects
			
				local snd = table.Random( GAMEMODE.GoreSplash )
				self.Entity:EmitSound( snd, 90, math.random( 90, 110 ) )
				
				local effectdata = EffectData()
				effectdata:SetOrigin( self.Entity:GetPos() + Vector(0,0,40) )
				util.Effect( "head_gib", effectdata, true, true )
				
				umsg.Start( "Headless" )
				umsg.Vector( self.Entity:GetPos() )
				umsg.End()
				
				if self.Entity:OnFire() then
				
					umsg.Start( "Burned" )
					umsg.Vector( self.Entity:GetPos() )
					umsg.End()
				
				end
				
				self.Entity:SpawnRagdoll( dmginfo )
			
			else
			
				self.Entity:VoiceSound( self.VoiceSounds.Death )
				self.Entity:SpawnRagdoll( dmginfo )
				
				if self.Entity:OnFire() then
				
					umsg.Start( "Burned" )
					umsg.Vector( self.Entity:GetPos() )
					umsg.End()
				
				end
			
			end
		
		end
	
	end
	
end

function ENT:OnDeath( dmginfo ) // override this 

end

function ENT:OnFire()

	return self.FireTime > CurTime()

end

function ENT:DoIgnite( att )

	if self.Entity:OnFire() then return end
	
	if IsValid( att ) and att:IsPlayer() and att:Team() == TEAM_ARMY then
	
		att:AddStat( "Igniter" )
	
	end
	
	self.FireTime = CurTime() + 5
	self.FireAttacker = att
	self.FireSound = true
	
	local ed = EffectData()
	ed:SetEntity( self.Entity )
	util.Effect( "immolate", ed, true, true )
	
	self.Entity:EmitSound( table.Random( GAMEMODE.Burning ), 100, 80 )
	self.Entity:EmitSound( GAMEMODE.BurnFlesh )

end

function ENT:StopFireSounds()

	self.Entity:StopSound( GAMEMODE.BurnFlesh )

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
	
		if IsValid( k ) and v.Dmg and v.Dmg > high then
			
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
	
		if IsValid( k ) and k:IsPlayer() then

			table.insert( tbl, k )
		
		end
	
	end

	return tbl
	
end

function ENT:VoiceSound( tbl )

	if ( self.VoiceTime or 0 ) > CurTime() then return end

	self.VoiceTime = CurTime() + 1.5
	
	local snd = table.Random( tbl )
	sound.Play( snd, self.Entity:GetPos() + Vector(0,0,50), 75, ( self.SoundOverride or math.random( 90, 100 ) ), 0.7 )
	
end

function ENT:StartAttack( enemy )

	self.CurAttack = CurTime() + self.AttackTime
	self.CurEnemy = enemy
	
	self.Entity:VoiceSound( self.VoiceSounds.Attack )

end

function ENT:OnHitEnemy( enemy )

	enemy:TakeDamage( self.Damage, self.Entity )

end

function ENT:OnHitBreakable( ent )

	if not IsValid( ent ) then return end

	if string.find( ent:GetClass(), "func_breakable" ) then
			
		ent:TakeDamage( 25, self.Entity, self.Entity )
				
		if ent:GetClass() == "func_breakable_surf" then
			
			ent:Fire( "shatter", "1 1 1", 0 )

		end
			
	elseif string.find( ent:GetClass(), "func_door" ) then
				
		ent:Remove()
			
	else
		
		if not ent.Hits then
				
			ent.Hits = 1
			ent.MaxHits = math.random(10,20)
					
			ent:EmitSound( self.WoodHit )
				
		else
				
			ent.Hits = ent.Hits + 1
					
			if ent.Hits > ent.MaxHits then
					
				if ent:GetModel() != "models/props_debris/wood_board04a.mdl" then
					
					local prop = ents.Create( "prop_physics" )
					prop:SetModel( ent:GetModel() )
					prop:SetPos( ent:GetPos() )
					prop:SetAngles( ent:GetAngles() + Angle( math.random(-10,10), math.random(-5,5), math.random(-5,5) ) )
					prop:SetSkin( ent:GetSkin() )
					prop:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
					prop:Spawn()
							
					local dir = ( ent:GetPos() - self.Entity:GetPos() ):Normalize()
					local phys = prop:GetPhysicsObject()
							
					if IsValid( phys ) and dir then
							
						phys:ApplyForceCenter( dir * phys:GetMass() * 800 )
						phys:AddAngleVelocity( VectorRand() * 200 )

					end
							
					ent:EmitSound( self.WoodBust )
					ent:Remove()
							
				else
						
					ent:Fire( "break", "", 0 )
						
				end

			else
					
				ent:EmitSound( self.WoodHit )
					
			end
				
		end
		
	end

end

function ENT:BehaveAct() // what does this do?

end

function ENT:IsZombie()

	return true

end

function ENT:CanTarget( v )

	return ( ( v:IsPlayer() and v:Alive() and v:GetObserverMode() == OBS_MODE_NONE and v:Team() == TEAM_ARMY ) or ( v:IsNPC() and not v:IsZombie() ) )

end

function ENT:FindEnemy()

	local tbl = team.GetPlayers( TEAM_ARMY )
	tbl = table.Add( tbl, ents.FindByClass( "npc_scientist" ) )
	
	self.EnemyTable = tbl

	if #tbl < 1 then
		
		return NULL
		
	else
	
		local enemy = NULL
		local dist = 99999
		
		for k,v in pairs( tbl ) do
		
			local compare = v:GetPos():Distance( self.Entity:GetPos() )
			
			if compare < dist and self.Entity:CanTarget( v ) then
			
				enemy = v
				dist = compare
				
			end
			
		end
		
		return enemy
		
	end
	
end

function ENT:CanAttack( ent )

	return IsValid( ent ) and self.Entity:CanTarget( ent ) and ent:GetPos():Distance( self.Entity:GetPos() ) <= self.MeleeDistance and self.Entity:MeleeTrace( ent )

end

function ENT:MeleeTrace( ent )

	local trace = {}
	trace.start = self.Entity:GetPos() + Vector(0,0,40)
	trace.endpos = ent:GetPos() + Vector(0,0,40)
	trace.filter = { ent, self.Entity }
	
	local tr = util.TraceLine( trace )
	
	if not tr.Hit then
	
		return true
	
	end
	
	if tr.HitWorld or tr.Entity:GetClass() == "prop_door_rotating" or tr.Entity:GetClass() == "func_breakable" or tr.Entity:GetClass() == "func_breakable_surf"	then
	
		return false
	
	end
	
	return true

end

function ENT:CanAttackEnemy( ent )

	if self.Entity:CanAttack( ent ) then
		
		return ent
		
	end

	if #self.EnemyTable < 1 then return end

	for k,v in pairs( self.EnemyTable ) do
	
		if self.Entity:CanAttack( v ) then
		
			return v
		
		end
	
	end

end

function ENT:GetBreakable()

	local tbl = ents.FindByModel( "models/props_debris/wood_board04a.mdl" ) 
	tbl = table.Add( tbl, table.Copy( GAMEMODE.Breakables ) )
	
	local remove 

	for k,v in pairs( tbl ) do
	
		if IsValid( v ) and v:GetPos():Distance( self.Entity:GetPos() ) <= self.BreakableDistance then
		
			return v
		
		end
	
	end
	
	local trace = {}
	trace.start = self.Entity:GetPos() + Vector(0,0,50)
	trace.endpos = trace.start + self.Entity:GetForward() * self.BreakableDistance
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )
	
	if table.HasValue( GAMEMODE.Breakables, tr.Entity ) then
	
		return tr.Entity
	
	end
	
	return NULL

end

function ENT:OnStuck()

	local ent = self.Entity:GetBreakable()
	
	if IsValid( ent ) then
	
		self.Obstructed = true
	
	else
	
		self.Obstructed = false
		
		self.loco:SetDesiredSpeed( self.BumpSpeed )
		self.loco:Jump()
		self.loco:SetDesiredSpeed( self.BumpSpeed )
	
	end
	
	self.loco:ClearStuck()

end

function ENT:OnUnStuck()

	self.Obstructed = false

end

function ENT:BreakableRoutine()

	local ent = self.Entity:GetBreakable()
			
	while IsValid( ent ) do
			
		local anim = table.Random( self.AttackAnims )
				
		self.Entity:StartAttack( ent )
		self.Entity:PlaySequenceAndWait( anim, self.AnimSpeed )
				
		ent = self.Entity:GetBreakable()
			
	end

end

function ENT:EnemyRoutine()

	local closest = self.Entity:CanAttackEnemy( enemy )
			
	while IsValid( closest ) do
			
		local anim = table.Random( self.AttackAnims )
				
		self.Entity:StartAttack( closest )
		self.Entity:PlaySequenceAndWait( anim, self.AnimSpeed )
		//self.Entity:StartActivity( ACT_MELEE_ATTACK1 )
				
		closest = self.Entity:CanAttackEnemy( closest )
				
	end

end

function ENT:RunBehaviour()

    while true do
	
        self.Entity:StartActivity( self.MoveAnim )    
        self.loco:SetDesiredSpeed( self.MoveSpeed )
		
		local enemy = self.Entity:FindEnemy()
		
		if not IsValid( enemy ) then
		
			self.Entity:MoveToPos( self.Entity:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 500 )
			self.Entity:StartActivity( ACT_IDLE ) 
		
		else
		
			if self.Obstructed then
			
				self.Entity:BreakableRoutine()
				
				coroutine.yield()
			
			end
		
			local opts = { draw = self.ShouldDrawPath, maxage = 1, tolerance = self.MeleeDistance }
		
			self.Entity:MoveToPos( enemy:GetPos(), opts ) 
			
			self.Entity:StartActivity( ACT_IDLE ) 
			
			self.Entity:BreakableRoutine()
			self.Entity:EnemyRoutine()
			
			self.Entity:StartActivity( ACT_IDLE ) 
			
		end
		
        coroutine.yield()
		
    end
	
end
