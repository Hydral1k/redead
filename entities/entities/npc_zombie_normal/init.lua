AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
	
ENT.Damage = 100

ENT.VoiceSounds = {}

ENT.VoiceSounds.Death = {"npc/zombie/zombie_die1.wav",
"npc/zombie/zombie_die2.wav",
"npc/zombie/zombie_die3.wav",
"npc/zombie/zombie_voice_idle6.wav",
"npc/zombie/zombie_voice_idle11.wav"}

ENT.VoiceSounds.Pain = {"npc/zombie/zombie_pain1.wav",
"npc/zombie/zombie_pain2.wav",
"npc/zombie/zombie_pain3.wav",
"npc/zombie/zombie_pain4.wav",
"npc/zombie/zombie_pain5.wav",
"npc/zombie/zombie_pain6.wav",
"npc/zombie/zombie_alert1.wav",
"npc/zombie/zombie_alert2.wav",
"npc/zombie/zombie_alert3.wav"}

ENT.VoiceSounds.Taunt = {"npc/zombie/zombie_voice_idle1.wav",
"npc/zombie/zombie_voice_idle2.wav",
"npc/zombie/zombie_voice_idle3.wav",
"npc/zombie/zombie_voice_idle4.wav",
"npc/zombie/zombie_voice_idle5.wav",
"npc/zombie/zombie_voice_idle7.wav",
"npc/zombie/zombie_voice_idle8.wav",
"npc/zombie/zombie_voice_idle9.wav",
"npc/zombie/zombie_voice_idle10.wav",
"npc/zombie/zombie_voice_idle12.wav",
"npc/zombie/zombie_voice_idle13.wav",
"npc/zombie/zombie_voice_idle14.wav"}

ENT.VoiceSounds.Attack = {"npc/zombie/zo_attack1.wav",
"npc/zombie/zo_attack2.wav"}

function ENT:Initialize()

	self.Entity:SetModel( "models/zombie/classic.mdl" )
	
	self.Entity:SetHullSizeNormal()
	self.Entity:SetHullType( HULL_HUMAN )
	
	self.Entity:SetSolid( SOLID_BBOX ) 
	self.Entity:SetMoveType( MOVETYPE_STEP )
	self.Entity:CapabilitiesAdd( CAP_MOVE_GROUND | CAP_INNATE_MELEE_ATTACK1 ) 
	
	self.Entity:SetMaxYawSpeed( 5000 )
	self.Entity:SetHealth( 200 )
	
	self.Entity:ClearSchedule()
	self.Entity:DropToFloor()
	
	self.Entity:UpdateEnemy( self.Entity:FindEnemy() )
	self.Entity:SetSchedule( SCHED_IDLE_WANDER ) 
	
	self.DmgTable = {}

end

function ENT:OnDamageEnemy( enemy )

	enemy:SetBleeding( true )
	enemy:ViewBounce( 30 )

end

function ENT:OnDeath( dmginfo )

	self.Entity:SpawnRagdoll( "models/Zombie/Classic_torso.mdl", self.Entity:GetPos() + Vector(0,0,50) )
	self.Entity:SetModel( self.Legs )
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < 150 then
		
			v:TakeDamage( 50, self.Entity )
			v:SetInfected( true )
			
			umsg.Start( "Drunk", v )
			umsg.Short( 2 )
			umsg.End()
		
		end
	
	end
	
	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "puke_spray", ed, true, true )
	
	if dmginfo:IsExplosionDamage() then
	
		local ed = EffectData()
		ed:SetOrigin( self.Entity:GetPos() )
		util.Effect( "gore_explosion", ed, true, true )
	
	end

end
