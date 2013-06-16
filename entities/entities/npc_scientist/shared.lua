
AddCSLuaFile()

ENT.Base = "base_nextbot"

// Moddable

ENT.AnimSpeed = 0.65
ENT.HealDistance = 96
ENT.AttackTime = 1.5
ENT.BaseHealth = 100
ENT.MoveSpeed = 175
ENT.MoveAnim = ACT_RUN

ENT.Models = { Model( "models/characters/hostage_04.mdl" ), Model( "models/kleiner.mdl" ) } 
ENT.Legs = Model( "models/zombie/classic_legs.mdl" )

ENT.Pain = { "vo/k_lab/kl_ahhhh.wav", 
"vo/k_lab/kl_dearme.wav", 
"vo/k_lab/kl_getoutrun02.wav",
"vo/k_lab/kl_interference.wav",
"vo/k_lab/kl_mygoodness01.wav",
"vo/k_lab/kl_ohdear.wav" }

ENT.Death = { "vo/k_lab/kl_ahhhh.wav", 
"vo/k_lab/kl_getoutrun03.wav",
"vo/k_lab/kl_hedyno03.wav",
"vo/k_lab2/kl_greatscott.wav",
"vo/trainyard/kl_morewarn01.wav" }

ENT.Happy = { "vo/k_lab/kl_excellent.wav",
"vo/k_lab/kl_moduli02.wav",
"vo/k_lab/kl_mygoodness03.wav",
"vo/k_lab/kl_relieved.wav",
"vo/k_lab2/kl_givenuphope.wav",
"vo/k_lab2/kl_howandwhen02.wav",
"vo/k_lab2/kl_notallhopeless_b.wav",
"vo/k_lab2/kl_slowteleport01.wav",
"vo/k_lab2/kl_slowteleport02.wav",
"vo/k_lab/kl_nownow02.wav" }

ENT.Alert = { "vo/k_lab/kl_getoutrun02.wav",
"vo/k_lab/kl_getoutrun03.wav",
"vo/k_lab2/kl_greatscott.wav",
"vo/trainyard/kl_morewarn01.wav",
"vo/k_lab/kl_ohdear.wav" }

// Other stuff

ENT.HeadshotNoise = Sound( "Player.DamageHeadShot" )

ENT.NextBot = true
ENT.ShouldDrawPath = false
ENT.FireDamageTime = 0
ENT.FireTime = 0
ENT.HealTime = 0
ENT.DmgTable = {}

function ENT:Initialize()

	local model = table.Random( self.Models )
	self.Entity:SetModel( model )
	
	self.Entity:SetHealth( self.BaseHealth )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_NPC )
	self.Entity:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) ) 
	
	self.loco:SetDeathDropHeight( 1000 )	
	self.loco:SetAcceleration( 500 )	
	
	self.LastPos = self.Entity:GetPos()
	self.Stuck = CurTime() + 10
	
end

function ENT:Heal( ply )

	self.Entity:VoiceSound( self.Happy )

	ply:EmitSound( "HealthVial.Touch", 50, 120 )
	ply:AddHealth( 20 )
	ply:Notice( "+20 Health", GAMEMODE.Colors.Green )

end

function ENT:Think()
	
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
	
	if ( self.ZombieTimer or 0 ) < CurTime() then
	
		self.ZombieTimer = CurTime() + 10
		
		if self.Entity:NearZombie() then
		
			self.Entity:VoiceSound( self.Alert )
		
		end
	
	end
	
	if self.CurAttack and self.CurAttack < CurTime() then
	
		self.CurAttack = nil
		
		if IsValid( self.CurEnemy ) and self.Entity:CanAttack( self.CurEnemy ) then
		
			self.Entity:Heal( self.CurEnemy )
		
		end
	
	end

end

function ENT:NearZombie()

	for k,v in pairs( ents.FindByClass( "npc_nb*" ) ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < 300 then
		
			return v
		
		end
	
	end

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

	if not IsValid( self.Entity ) then return end

	if hitgroup == HITGROUP_HEAD then
	
		self.Entity:EmitSound( self.HeadshotNoise, 80, math.random( 100, 120 ) )
		self.Entity:SetHeadshotter( dmginfo:GetAttacker(), true )
		
		local effectdata = EffectData()
		effectdata:SetOrigin( dmginfo:GetDamagePosition() )
		util.Effect( "headshot", effectdata, true, true )
	
		dmginfo:ScaleDamage( 2.75 ) 
		
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

	self.Entity:AddDamageTaken( dmginfo:GetAttacker(), dmginfo:GetDamage() )
	
	if self.Entity:Health() > 0 and math.random(1,2) == 1 then
	
		self.Entity:VoiceSound( self.Pain )
		
	end
	
	local att = dmginfo:GetAttacker()
	
	if IsValid( att ) and att.NextBot then
	
		//self.Entity:OnKilled( dmginfo )
	
	end
	
end 

function ENT:SpawnRagdoll( dmginfo, model, pos, override )

	timer.Simple( 0.2, function() if IsValid( self.Entity ) then self.Entity:Remove() end end )

	if not model then
		
		self.Entity:BecomeRagdoll( dmginfo )
		
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
	self.Entity:SetNWBool( "Dead", true )
	
	if dmginfo then
		
		local ent1 = self.Entity:GetHighestDamager()
		
		if IsValid( ent1 ) then
			
			if dmginfo:IsExplosionDamage() then
			
				local snd = table.Random( GAMEMODE.GoreSplash )
				self.Entity:EmitSound( snd, 90, math.random( 60, 80 ) )
				
				local effectdata = EffectData()
				effectdata:SetOrigin( self.Entity:GetPos() + Vector(0,0,20) )
				util.Effect( "body_gib", effectdata, true, true )
				
				local ed = EffectData()
				ed:SetOrigin( self.Entity:GetPos() )
				util.Effect( "gore_explosion", ed, true, true )
				
				local corpse = table.Random( GAMEMODE.Corpses )
				self.Entity:SpawnRagdoll( dmginfo, corpse )
			
			elseif ent1:HasShotgun() and ent1:GetPos():Distance( self.Entity:GetPos() ) < 100 then
			
				local snd = table.Random( GAMEMODE.GoreSplash )
				self.Entity:EmitSound( snd, 90, math.random( 60, 80 ) )
				
				local effectdata = EffectData()
				effectdata:SetOrigin( self.Entity:GetPos() + Vector(0,0,20) )
				util.Effect( "body_gib", effectdata, true, true )
				
				self.Entity:SpawnRagdoll( dmginfo, self.Legs )
				
			elseif ent1:HasMelee() then
				
				self.Entity:VoiceSound( self.Death )
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
			
				self.Entity:VoiceSound( self.Death )
				self.Entity:SpawnRagdoll( dmginfo )
				
				if self.Entity:OnFire() then
				
					umsg.Start( "Burned" )
					umsg.Vector( self.Entity:GetPos() )
					umsg.End()
				
				end
			
			end
		
		else
		
			self.Entity:SpawnRagdoll( dmginfo )
		
		end
	
	end
	
end

function ENT:OnDeath( dmginfo )

	for i=1, math.random(1,3) do
	
		local tbl = item.RandomItem( ITEM_SUPPLY )
	
		local prop = ents.Create( "prop_physics" )
		prop:SetPos( self.Entity:GetPos() + Vector(0,0,30) + VectorRand() * 5 )
		prop:SetModel( tbl.Model )
		prop:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		prop:Spawn()
	
	end
	
	if math.random(1,4) != 1 then
	
		local model = table.Random{ "models/healthvial.mdl", "models/items/healthkit.mdl" }
	
		local prop = ents.Create( "prop_physics" )
		prop:SetPos( self.Entity:GetPos() + Vector(0,0,30) + VectorRand() * 5 )
		prop:SetModel( model )
		prop:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		prop:Spawn()
	
	end

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

function ENT:VoiceSound( tbl )

	if ( self.VoiceTime or 0 ) > CurTime() then return end

	self.VoiceTime = CurTime() + 1.5
	
	local snd = table.Random( tbl )
	sound.Play( snd, self.Entity:GetPos() + Vector(0,0,50), 75, 100, 0.7 )
	
end

function ENT:StartAttack( enemy )

	self.CurAttack = CurTime() + self.AttackTime
	self.CurEnemy = enemy

end

function ENT:OnHitEnemy( enemy )

	enemy:TakeDamage( self.Damage, self.Entity )

end

function ENT:BehaveAct() // what does this do?

end

function ENT:IsZombie()

	return false

end

function ENT:CanTarget( v )

	return ( v:Alive() and v:GetObserverMode() == OBS_MODE_NONE and v:Team() == TEAM_ARMY )

end

function ENT:FindHuman()

	local tbl = team.GetPlayers( TEAM_ARMY )
	
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

	return IsValid( ent ) and self.Entity:CanTarget( ent ) and ent:GetPos():Distance( self.Entity:GetPos() ) <= self.HealDistance 

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

function ENT:OnStuck()
	
	//self.loco:ClearStuck()
	self.Entity:VoiceSound( self.Alert )

end

function ENT:OnUnStuck()

	//self.Obstructed = false

end

function ENT:StartAttack( enemy )

	self.CurAttack = CurTime() + self.AttackTime
	self.CurEnemy = enemy

end

function ENT:EnemyRoutine()

	local closest = self.Entity:CanAttackEnemy( enemy )
			
	while IsValid( closest ) do
				
		self.Entity:StartAttack( closest )
		self.Entity:PlaySequenceAndWait( "open_door_away", self.AnimSpeed )
		
		coroutine.wait( 1.0 )
				
		closest = self.Entity:CanAttackEnemy( closest )
				
	end

end

function ENT:RunBehaviour()

    while true do
	
        self.Entity:StartActivity( self.MoveAnim )    
        self.loco:SetDesiredSpeed( self.MoveSpeed )
		
		local enemy = self.Entity:FindHuman()
		
		if not IsValid( enemy ) then
		
			self.Entity:MoveToPos( self.Entity:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 500 )
			self.Entity:StartActivity( ACT_IDLE ) 
		
		else
		
			local opts = { draw = self.ShouldDrawPath, maxage = 1, tolerance = self.HealDistance }
		
			self.Entity:MoveToPos( enemy:GetPos(), opts ) 
			
			self.Entity:StartActivity( ACT_IDLE ) 
			
			self.Entity:EnemyRoutine()
			
			self.Entity:StartActivity( ACT_IDLE ) 
			
		end
		
        coroutine.yield()
		
    end
	
end
