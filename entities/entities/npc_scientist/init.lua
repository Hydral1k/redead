AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.FireTime = 0
ENT.FireDamageTime = 0
ENT.HealTime = 0

ENT.Pain = { "vo/k_lab/kl_ahhhh.wav", 
"vo/k_lab/kl_dearme.wav", 
"vo/k_lab/kl_getoutrun02.wav",
"vo/k_lab/kl_interference.wav",
"vo/k_lab/kl_mygoodness01.wav",
"vo/k_lab/kl_ohdear.wav" }

ENT.Die = { "vo/k_lab/kl_ahhhh.wav", 
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

ENT.Models = { Model( "models/characters/hostage_04.mdl" ), Model( "models/kleiner.mdl" ) } 

function ENT:Initialize()

	self.Entity:SetModel( table.Random( self.Models ) )
	
	self.Entity:SetHullSizeNormal()
	self.Entity:SetHullType( HULL_HUMAN )
	
	self.Entity:SetSolid( SOLID_BBOX ) 
	self.Entity:SetMoveType( MOVETYPE_STEP )
	self.Entity:CapabilitiesAdd( CAP_MOVE_GROUND ) 
	
	self.Entity:SetMaxYawSpeed( 5000 )
	self.Entity:SetHealth( 100 )
	
	self.Entity:DropToFloor()
	self.Entity:UpdateEnemy()
	
	self.NextUpdate = 0
	self.LastPos = Vector(0,0,0)
	self.DmgTable = {}

end

function ENT:VoiceSound( tbl )

	if ( self.VoiceTime or 0 ) > CurTime() then return end

	self.VoiceTime = CurTime() + 2
	
	self.Entity:EmitSound( Sound( table.Random( tbl ) ) )
	
end

function ENT:SpawnRagdoll( model, pos )

	if not model then
	
		umsg.Start( "Ragdoll" )
		umsg.Vector( self.Entity:GetPos() )
		
		if self.Entity:OnFire() then
		
			umsg.Short(2)
		
		else
		
			umsg.Short(1)
		
		end
		
		umsg.Short( self.Entity:EntIndex() )
		umsg.End()
		
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
		
		self.Entity:Remove()
	
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

end

function ENT:Heal( ply )

	self.Entity:VoiceSound( self.Happy )

	ply:EmitSound( "HealthVial.Touch", 50, 120 )
	ply:AddHealth( 25 )
	ply:Notice( "+25 Health", GAMEMODE.Colors.Green )

end

function ENT:IsZombie()

	return false

end

function ENT:DoDeath( dmginfo )

	if self.Dying then return end
	
	self.Dying = true
	self.RemoveTimer = CurTime() + 0.3
	
	self.Entity:SetNPCState( NPC_STATE_DEAD )
	//self.Entity:SetSchedule( SCHED_DIE_RAGDOLL )
	
	self.Entity:OnDeath( dmginfo )
	
	if dmginfo then

		if dmginfo:IsExplosionDamage() then
			
			self.Entity:SetModel( table.Random( GAMEMODE.Corpses ) )
			self.Entity:EmitSound( table.Random( GAMEMODE.GoreSplash ), 90, math.random( 60, 80 ) )
				
			local effectdata = EffectData()
			effectdata:SetOrigin( self.Entity:GetPos() + Vector(0,0,20) )
			util.Effect( "body_gib", effectdata, true, true )
				
			local ed = EffectData()
			ed:SetOrigin( self.Entity:GetPos() )
			util.Effect( "gore_explosion", ed, true, true )
				
			self.Entity:SpawnRagdoll()
			
		else
			
			self.Entity:VoiceSound( self.Die )
				
			self.Entity:SpawnRagdoll()
		
		end
	
	end
	
end

function ENT:SetHeadshotter()

end

function ENT:OnTakeDamage( dmginfo )

	if dmginfo:IsExplosionDamage() then
	
		dmginfo:ScaleDamage( 1.75 )
	
	end
	
	self.Entity:SetHealth( math.Clamp( self.Entity:Health() - dmginfo:GetDamage(), 0, 1000 ) )
	
	if self.Entity:Health() <= 0 then
	
		self.Entity:DoDeath( dmginfo )
		
	elseif math.random(1,3) == 1 then
	
		self.Entity:VoiceSound( self.Pain )
		
	end
	
end 

function ENT:OnThink()

	if ( self.ZombieTimer or 0 ) < CurTime() then
	
		self.ZombieTimer = CurTime() + 10
		
		if self.Entity:NearZombie() then
		
			self.Entity:VoiceSound( self.Alert )
		
		end
	
	end

end

function ENT:DoIgnite( att )

	if self.Entity:OnFire() then return end
	
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

function ENT:OnFire()

	return self.FireTime > CurTime()

end

function ENT:Think()

	if self.RemoveTimer then
	
		self.Entity:StopFireSounds()

		if self.RemoveTimer < CurTime() then
	
			self.Entity:Remove()
		
		end
	
	end
	
	if self.Dying then return end
	
	self.Entity:OnThink()
	
	if self.Entity:OnFire() and self.FireDamageTime < CurTime() then
	
		self.FireDamageTime = CurTime() + 0.25
		
		self.Entity:TakeDamage( 10, self.FireAttacker )
	
	elseif self.FireSound and not self.Entity:OnFire() then
	
		self.Entity:StopFireSounds()
	
	end
	
	if ( self.PosCheck or 0 ) < CurTime() then
	
		self.PosCheck = CurTime() + 10
	
		if self.LastPos == self.Entity:GetPos() then
		
			local ent = ents.Create( "npc_scientist" )
			ent:SetPos( self.Entity:GetPos() )
			ent:Spawn()
		
			self.Entity:Remove()
		
		end
		
		self.LastPos = self.Entity:GetPos()
	
	end
	
end

function ENT:GetRelationship( entity )

	return D_HT
	
end

function ENT:FindFriend()

	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		if v:Alive() and v:GetPos():Distance( self.Entity:GetPos() ) < 500 then
		
			return v
		
		end
	
	end

end

function ENT:NearZombie()

	for k,v in pairs( ents.FindByClass( "npc_zombie*" ) ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < 300 then
		
			return v
		
		end
	
	end

end

function ENT:UpdateEnemy( enemy )

	if ValidEntity( enemy ) and ( ( enemy:IsPlayer() and enemy:Alive() and enemy:GetObserverMode() == OBS_MODE_NONE ) or enemy:IsNPC() ) then
		
		self:SetEnemy( enemy, true ) 
		self:UpdateEnemyMemory( enemy, enemy:GetPos() ) 
		
	else
		
		self:SetEnemy( NULL )
		
	end

end

function ENT:SelectSchedule()

	if GetGlobalBool( "GameOver", false ) or self.Dying then
	
		self.Entity:SetSchedule( SCHED_IDLE_WANDER )
		
		return
	
	end

	local sched = SCHED_RUN_RANDOM 
	local friend = self.Entity:FindFriend()
	local enemy = self.Entity:NearZombie()
	
	if ValidEntity( friend ) then

		sched = SCHED_CHASE_ENEMY
			
		if ( self.NextUpdate or 0 ) < CurTime() then
			
			self.Entity:UpdateEnemy( friend )
			self.NextUpdate = CurTime() + 1
			
		end
		
		if friend:GetPos():Distance( self.Entity:GetPos() ) < 50 and self.HealTime < CurTime() then
		
			local schd= ai_schedule.New( "Heal" )
			schd:EngTask( "TASK_STOP_MOVING", 0 )
			schd:EngTask( "TASK_FACE_ENEMY", 0 )
			schd:AddTask( "PlaySequence", { Name = "open_door_away", Speed = 1 } )
			
			self.Entity:StartSchedule( schd )
			self.HealTime = CurTime() + 10
			
			self.Entity:Heal( friend )
			
			return
			
		end
		
	elseif ValidEntity( enemy ) then
	
		sched = SCHED_RUN_FROM_ENEMY_FALLBACK 
	
		if ( self.NextUpdate or 0 ) < CurTime() then
			
			self.Entity:UpdateEnemy( enemy )
			self.NextUpdate = CurTime() + 1
			
		end
	
	end

	self.Entity:SetSchedule( sched ) 

end
