
AddCSLuaFile()

ENT.Base = "npc_nb_base"

// Moddable

ENT.AttackAnims = { "attackB", "attackD", "attackE", "attackF", "swatleftmid", "swatrightmid" }
ENT.AnimSpeed = 1.2
ENT.AttackTime = 0.5
ENT.MeleeDistance = 64
ENT.BreakableDistance = 96
ENT.Damage = 60
ENT.BaseHealth = 200
ENT.MoveSpeed = 50
ENT.MoveAnim = ACT_WALK

ENT.Models = nil
ENT.Model = Model( "models/zombie/classic.mdl" ) 

ENT.VoiceSounds = {}

ENT.VoiceSounds.Death = { Sound( "npc/zombie/zombie_die1.wav" ),
 Sound( "npc/zombie/zombie_die2.wav" ),
 Sound( "npc/zombie/zombie_die3.wav" ),
 Sound( "npc/zombie/zombie_voice_idle6.wav" ),
 Sound( "npc/zombie/zombie_voice_idle11.wav" ) }

ENT.VoiceSounds.Pain = { Sound( "npc/zombie/zombie_pain1.wav" ),
 Sound( "npc/zombie/zombie_pain2.wav" ),
 Sound( "npc/zombie/zombie_pain3.wav" ),
 Sound( "npc/zombie/zombie_pain4.wav" ),
 Sound( "npc/zombie/zombie_pain5.wav" ),
 Sound( "npc/zombie/zombie_pain6.wav" ),
 Sound( "npc/zombie/zombie_alert1.wav" ),
 Sound( "npc/zombie/zombie_alert2.wav" ),
 Sound( "npc/zombie/zombie_alert3.wav" ) }

ENT.VoiceSounds.Taunt = { Sound( "npc/zombie/zombie_voice_idle1.wav" ),
 Sound( "npc/zombie/zombie_voice_idle2.wav" ),
 Sound( "npc/zombie/zombie_voice_idle3.wav" ),
 Sound( "npc/zombie/zombie_voice_idle4.wav" ),
 Sound( "npc/zombie/zombie_voice_idle5.wav" ),
 Sound( "npc/zombie/zombie_voice_idle7.wav" ),
 Sound( "npc/zombie/zombie_voice_idle8.wav" ),
 Sound( "npc/zombie/zombie_voice_idle9.wav" ),
 Sound( "npc/zombie/zombie_voice_idle10.wav" ),
 Sound( "npc/zombie/zombie_voice_idle12.wav" ),
 Sound( "npc/zombie/zombie_voice_idle13.wav" ),
 Sound( "npc/zombie/zombie_voice_idle14.wav" ) }

ENT.VoiceSounds.Attack = { Sound( "npc/zombie/zo_attack1.wav" ),
Sound( "npc/zombie/zo_attack2.wav" ) }

ENT.Torso = Model( "models/zombie/classic_torso.mdl" )

function ENT:OnDeath( dmginfo )
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < 150 then
		
			v:TakeDamage( 40, self.Entity )
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
	
	self.Entity:SpawnRagdoll( dmginfo, self.Torso, self.Entity:GetPos() + Vector(0,0,50), true )
	self.Entity:SetModel( self.Legs )

end

function ENT:OnHitEnemy( enemy )

	enemy:TakeDamage( self.Damage, self.Entity )
	
	if enemy:IsPlayer() then
	
		enemy:ViewBounce( 30 )
		
	end
	
	umsg.Start( "Drunk", enemy )
	umsg.Short( 3 )
	umsg.End()

end