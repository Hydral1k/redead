
AddCSLuaFile()

ENT.Base = "npc_nb_base"

// Moddable

ENT.AttackAnims = { "melee_01" }
ENT.AnimSpeed = 1.2
ENT.AttackTime = 0.5
ENT.MeleeDistance = 64
ENT.BreakableDistance = 96
ENT.Damage = 65
ENT.BaseHealth = 700
ENT.MoveSpeed = 75
ENT.MoveAnim = ACT_WALK

ENT.Radius = 175
ENT.SoundRadius = 500
ENT.EffectTime = 0

ENT.Models = nil
ENT.Model = Model( "models/zombie/poison.mdl" )

ENT.VoiceSounds = {}

ENT.VoiceSounds.Death = { Sound( "npc/zombie_poison/pz_die1.wav" ),
Sound( "npc/zombie_poison/pz_die2.wav" ),
Sound( "npc/zombie_poison/pz_idle2.wav" ),
Sound( "npc/zombie_poison/pz_warn2.wav" ) }

ENT.VoiceSounds.Pain = { Sound( "npc/zombie_poison/pz_idle3.wav" ),
Sound( "npc/zombie_poison/pz_idle4.wav" ),
Sound( "npc/zombie_poison/pz_pain1.wav" ),
Sound( "npc/zombie_poison/pz_pain2.wav" ),
Sound( "npc/zombie_poison/pz_pain3.wav" ),
Sound( "npc/zombie_poison/pz_warn1.wav" ) }

ENT.VoiceSounds.Taunt = { Sound( "npc/zombie_poison/pz_alert1.wav" ),
Sound( "npc/zombie_poison/pz_alert2.wav" ),
Sound( "npc/zombie_poison/pz_call1.wav" ),
Sound( "npc/zombie_poison/pz_throw2.wav" ),
Sound( "npc/zombie_poison/pz_throw3.wav" ) }

ENT.VoiceSounds.Attack = { Sound( "npc/zombie_poison/pz_throw2.wav" ),
Sound( "npc/zombie_poison/pz_throw3.wav" ),
Sound( "npc/zombie_poison/pz_alert2.wav" ) }

function ENT:OnDeath( dmginfo ) 

end

function ENT:OnThink()

	if self.EffectTime < CurTime() then
	
		self.EffectTime = CurTime() + 5
		
		local ed = EffectData()
		ed:SetEntity( self.Entity )
		util.Effect( "radiation", ed, true, true )
	
	end

	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		local dist = v:GetPos():Distance( self.Entity:GetPos() )
		
		if dist < self.SoundRadius then
		
			if dist < self.Radius then
		
				if ( v.RadAddTime or 0 ) < CurTime() then
			
					v.RadAddTime = CurTime() + 8
					v:AddRadiation( 1 )
					
				end
		
			end
		
			if ( v.NextRadSound or 0 ) < CurTime() then
			
				local scale = math.Clamp( ( self.SoundRadius - dist ) / ( self.SoundRadius - self.Radius ), 0.1, 1.0 )
			
				v.NextRadSound = CurTime() + 1 - scale 
				v:EmitSound( table.Random( GAMEMODE.Geiger ), 100, math.random( 80, 90 ) + scale * 20 )
				v:NoticeOnce( "A radioactive zombie is nearby", GAMEMODE.Colors.Blue )
				v:NoticeOnce( "Radioactive zombies will poison nearby people", GAMEMODE.Colors.Blue, 3, 2 )
				
			end
		
		end
	
	end

end

function ENT:OnHitEnemy( enemy )

	enemy:TakeDamage( self.Damage, self.Entity )
	enemy:AddRadiation( 2 )
	enemy:ViewBounce( 35 )
	
	umsg.Start( "Drunk", enemy )
	umsg.Short( 3 )
	umsg.End()

end

function ENT:OnDeath( dmginfo ) 

	local ent = ents.Create( "sent_radiation" ) 
	ent:SetPos( self.Entity:GetPos() )
	ent:Spawn()
	
	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "rad_explosion", ed, true, true )

end