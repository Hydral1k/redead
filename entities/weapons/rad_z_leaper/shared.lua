if SERVER then

	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Claws"
	SWEP.IconLetter = "C"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	killicon.AddFont( "rad_z_leaper", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.Base = "rad_z_base"
SWEP.HoldType = "slam"
SWEP.ViewModel = "models/Zed/weapons/v_wretch.mdl"

SWEP.Taunt = { "npc/fast_zombie/fz_frenzy1.wav",
"npc/barnacle/barnacle_pull1.wav",
"npc/barnacle/barnacle_pull2.wav",
"npc/barnacle/barnacle_pull3.wav",
"npc/barnacle/barnacle_pull4.wav" }

SWEP.Die = { "npc/fast_zombie/fz_alert_close1.wav",
"npc/fast_zombie/fz_alert_far1.wav" }

SWEP.Scream = Sound( "npc/fast_zombie/fz_scream1.wav" )

SWEP.Primary.Hit            = Sound( "npc/zombie/claw_strike1.wav" )
SWEP.Primary.HitFlesh		= Sound( "npc/zombie/claw_strike2.wav" )
SWEP.Primary.Sound			= Sound( "npc/fast_zombie/wake1.wav" )
SWEP.Primary.Miss           = Sound( "npc/zombie/claw_miss1.wav" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 1.200

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= true

SWEP.JumpTime = 0

function SWEP:NoobHelp()

	self.Owner:NoticeOnce( "Your attacks cause bleeding", GAMEMODE.Colors.Blue, 5, 10 )

end

function SWEP:Think()	

	if self.ThinkTime != 0 and self.ThinkTime < CurTime() then
	
		self.Weapon:MeleeTrace( self.Primary.Damage )
		
		self.ThinkTime = 0
	
	end
	
	if CLIENT then return end
	
	if self.JumpTime < CurTime() and self.Owner:KeyDown( IN_SPEED ) then
	
		local vec = self.Owner:GetAimVector()
		vec.z = math.Clamp( vec.z, 0.40, 0.75 )
	
		self.JumpTime = CurTime() + 8
	
		self.Owner:SetVelocity( vec * 800 )
		self.Owner:EmitSound( self.Scream, 100, math.random( 90, 110 ) )
	
	end

end

function SWEP:OnHitHuman( ent, dmg )

	if not ent:IsBleeding() then

		ent:SetBleeding( true )
		
		self.Owner:Notice( "You made a human bleed", GAMEMODE.Colors.Green )
		self.Owner:AddZedDamage( 10 )
		
	end
	
	self.Owner:AddZedDamage( dmg )
	self.Owner:DrawBlood( 5 )
	
end
