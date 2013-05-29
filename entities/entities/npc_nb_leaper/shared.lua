
AddCSLuaFile()

ENT.Base = "npc_nb_base"

// Moddable

ENT.AttackAnims = { "Melee" }
ENT.AnimSpeed = 1.0
ENT.AttackTime = 0.3
ENT.MeleeDistance = 64
ENT.BreakableDistance = 96
ENT.Damage = 35
ENT.BaseHealth = 60
ENT.MoveSpeed = 250
ENT.JumpHeight = 300
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

ENT.Leap = Sound( "npc/fast_zombie/fz_scream1.wav" )

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
		
			if math.random(1,25) == 1 then
			
				self.loco:SetJumpHeight( math.random( 150, self.JumpHeight ) )
				self.loco:Jump()
				self.loco:SetDesiredSpeed( math.random( 350, 700 ) )
				
				self.Entity:EmitSound( self.Leap, 100, math.random(90,110) )
			
			end
		
			self.Entity:MoveToPos( enemy:GetPos(), opts ) 
			
			self.Entity:StartActivity( ACT_IDLE ) 
			
			self.Entity:BreakableRoutine()
			self.Entity:EnemyRoutine()
			
			self.Entity:StartActivity( ACT_IDLE ) 
			
		end
		
        coroutine.yield()
		
    end
	
end