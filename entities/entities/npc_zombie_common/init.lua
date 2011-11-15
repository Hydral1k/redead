AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

for k,v in pairs{ 4, 6, 8 } do

	util.PrecacheModel( "models/Zed/malezed_0" .. v .. ".mdl" )
	
end

ENT.VoiceSounds = {}

ENT.VoiceSounds.Death = { "vo/npc/vortigaunt/vortigese02.wav",
"vo/npc/vortigaunt/vortigese03.wav",
"vo/npc/vortigaunt/vortigese05.wav",
"vo/npc/vortigaunt/vortigese07.wav" }

ENT.VoiceSounds.Pain = { "vo/npc/vortigaunt/vortigese04.wav",
"vo/npc/vortigaunt/vortigese08.wav",
"vo/npc/vortigaunt/vortigese09.wav" }

ENT.VoiceSounds.Taunt = { "npc/zombie/zombie_alert1.wav",
"npc/zombie/zombie_alert2.wav",
"npc/zombie/zombie_alert3.wav" }

ENT.VoiceSounds.Attack = { "npc/fast_zombie/idle1.wav",
"npc/fast_zombie/idle1.wav" }

ENT.AttackAnims = { "attack01", "attack01", "attack02", "attack02", "attack03" }
ENT.AnimSpeeds = { .65, .65, .65, .65, .70 }
ENT.AnimScale = 2.0
ENT.Damage = 40
ENT.HeadshotEffects = true

function ENT:Initialize()

	self.Entity:SetModel( "models/Zed/malezed_0" .. table.Random{ 4, 6, 8 } .. ".mdl" )
	
	self.Entity:SetHullSizeNormal()
	self.Entity:SetHullType( HULL_HUMAN )
	
	self.Entity:SetSolid( SOLID_BBOX ) 
	self.Entity:SetMoveType( MOVETYPE_STEP )
	self.Entity:CapabilitiesAdd( CAP_MOVE_GROUND | CAP_ANIMATEDFACE | CAP_TURN_HEAD | CAP_MOVE_CLIMB | CAP_INNATE_MELEE_ATTACK1 | CAP_MOVE_JUMP )
	
	self.Entity:SetMaxYawSpeed( 5000 )
	self.Entity:SetHealth( 100 )
	self.Entity:SetSkin( math.random(0,22) )
	
	self.Entity:DropToFloor()
	
	self.Entity:UpdateEnemy( self.Entity:FindEnemy() )
	
	self.DmgTable = {}

end

function ENT:OnDamageEnemy( enemy )

	enemy:SetInfected( true )

end

function ENT:OnCondition( cond )
	
	local name = self:ConditionName( cond )

	if name == "COND_SCHEDULE_DONE" and self.Punched then
	
		self.Entity:ClearSchedule()
		self.Entity:SetNPCState( NPC_STATE_COMBAT )
		
		self.Punched = false
	
	end
	
end

function ENT:SelectSchedule()

	if GetGlobalBool( "GameOver", false ) then
	
		self.Entity:SetSchedule( SCHED_CHASE_ENEMY )
		
		return
	
	end

	local enemy = self.Entity:GetEnemy()
	local sched = SCHED_IDLE_WANDER
	
	if ValidEntity( enemy ) then

		if self.Entity:HasCondition( 23 ) or ValidEntity( self.AttackDoor ) then 
		
			local slot = math.random(1,5)
		
			local attack = ai_schedule.New( "Beatdown" )
			attack:EngTask( "TASK_STOP_MOVING", 0 )
			attack:EngTask( "TASK_FACE_ENEMY", 0 )
			attack:AddTask( "PlaySequence", { Name = self.AttackAnims[slot], Speed = self.AnimSpeeds[slot] } )
			
			self.Entity:StartSchedule( attack ) 
			self.Entity:VoiceSound( self.VoiceSounds.Attack )
			
			self.AttackTime = CurTime() + 0.5
			self.Punched = true
			
			return
			
		else
		
			if ( self.NextUpdate or 0 ) < CurTime() then
			
				self.Entity:UpdateEnemy( enemy )
				self.NextUpdate = CurTime() + 1
			
			end
		
			sched = SCHED_CHASE_ENEMY
			
		end
		
	else
	
		self.Entity:UpdateEnemy( self.Entity:FindEnemy() )
		
	end

	self.Entity:SetSchedule( sched ) 

end
