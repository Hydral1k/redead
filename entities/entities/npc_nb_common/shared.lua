
AddCSLuaFile()

ENT.Base = "npc_nb_base"

// Moddable

ENT.AttackAnims = { "attack01", "attack02", "attack03", "attack04" }
ENT.AnimSpeed = 0.8
ENT.AttackTime = 0.5
ENT.MeleeDistance = 64
ENT.BreakableDistance = 96
ENT.Damage = 30
ENT.BaseHealth = 90
ENT.MoveSpeed = 175
ENT.MoveAnim = ACT_RUN

ENT.Models = { Model( "models/zed/malezed_04.mdl" ), 
Model( "models/zed/malezed_06.mdl" ), 
Model( "models/zed/malezed_08.mdl" ) }

ENT.VoiceSounds = {}

ENT.VoiceSounds.Death = { Sound( "nuke/redead/death_1.wav" ),
Sound( "nuke/redead/death_2.wav" ),
Sound( "nuke/redead/death_3.wav" ),
Sound( "nuke/redead/death_4.wav" ),
Sound( "nuke/redead/death_5.wav" ),
Sound( "nuke/redead/death_6.wav" ) }

ENT.VoiceSounds.Pain = { Sound( "nuke/redead/pain_1.wav" ),
Sound( "nuke/redead/pain_2.wav" ),
Sound( "nuke/redead/pain_3.wav" ),
Sound( "nuke/redead/pain_4.wav" ),
Sound( "nuke/redead/pain_5.wav" ),
Sound( "nuke/redead/pain_6.wav" ) }

ENT.VoiceSounds.Taunt = { Sound( "nuke/redead/idle_1.wav" ),
Sound( "nuke/redead/idle_2.wav" ),
Sound( "nuke/redead/idle_3.wav" ),
Sound( "nuke/redead/idle_4.wav" ),
Sound( "nuke/redead/idle_5.wav" ),
Sound( "nuke/redead/idle_6.wav" ),
Sound( "nuke/redead/idle_7.wav" ),
Sound( "nuke/redead/idle_8.wav" ) }

ENT.VoiceSounds.Attack = { Sound( "nuke/redead/attack_1.wav" ),
Sound( "nuke/redead/attack_2.wav" ),
Sound( "nuke/redead/attack_3.wav" ),
Sound( "nuke/redead/attack_4.wav" ),
Sound( "nuke/redead/attack_5.wav" ),
Sound( "nuke/redead/attack_6.wav" ) }

function ENT:OnDeath( dmginfo ) 

end

function ENT:OnHitEnemy( enemy )

	enemy:TakeDamage( self.Damage, self.Entity )
	
	if enemy:IsPlayer() then
	
		enemy:SetInfected( true )
		enemy:ViewBounce( 10 )
	
	end
	
	umsg.Start( "Drunk", enemy )
	umsg.Short( 1 )
	umsg.End()

end