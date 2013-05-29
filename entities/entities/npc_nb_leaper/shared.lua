
AddCSLuaFile()

ENT.Base = "npc_nb_base"

// Moddable

ENT.AttackAnims = { "Melee" }
ENT.AnimSpeed = 1.0
ENT.AttackTime = 0.3
ENT.MeleeDistance = 64
ENT.BreakableDistance = 96
ENT.Damage = 40
ENT.BaseHealth = 80
ENT.MoveSpeed = 250
ENT.MoveAnim = ACT_RUN

ENT.Models = nil
ENT.Model = Model( "models/zombie/fast.mdl" ) 
ENT.Legs = Model( "models/gibs/fast_zombie_legs.mdl" )

ENT.VoiceSounds = {}

ENT.VoiceSounds.Death = { Sound( "npc/fast_zombie/fz_alert_close1.wav" ),
Sound( "npc/fast_zombie/fz_alert_far1.wav" ) }

ENT.VoiceSounds.Pain = { Sound( "npc/fast_zombie/idle1.wav" ),
Sound( "npc/fast_zombie/idle2.wav" ),
Sound( "npc/fast_zombie/idle3.wav" ),
Sound( "npc/headcrab_poison/ph_hiss1.wav" ),
Sound( "npc/headcrab_poison/ph_idle1.wav" ) }

ENT.VoiceSounds.Taunt = { Sound( "npc/fast_zombie/fz_frenzy1.wav" ),
Sound( "npc/fast_zombie/fz_scream1.wav" ),
Sound( "npc/barnacle/barnacle_pull1.wav" ),
Sound( "npc/barnacle/barnacle_pull2.wav" ),
Sound( "npc/barnacle/barnacle_pull3.wav" ),
Sound( "npc/barnacle/barnacle_pull4.wav" ) }

ENT.VoiceSounds.Attack = { Sound( "npc/fast_zombie/wake1.wav" ),
Sound( "npc/fast_zombie/leap1.wav" ) }

function ENT:OnDeath( dmginfo ) 

end

function ENT:OnHitEnemy( enemy )

	enemy:TakeDamage( self.Damage, self.Entity )
	
	if enemy:IsPlayer() then
	
		enemy:SetBleeding( true )
		enemy:ViewBounce( 15 )
	
	end
	
	umsg.Start( "Drunk", enemy )
	umsg.Short( 1 )
	umsg.End()

end