if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Claws"
	SWEP.IconLetter = "C"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	killicon.AddFont( "rad_z_banshee", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.Base = "rad_z_base"

SWEP.ViewModel = "models/Zed/weapons/v_banshee.mdl"

SWEP.Taunt = Sound( "npc/stalker/go_alert2a.wav" )

SWEP.Die = { "npc/headcrab_poison/ph_scream1.wav",
"npc/headcrab_poison/ph_scream2.wav",
"npc/headcrab_poison/ph_scream3.wav"}

SWEP.Primary.Hit            = Sound( "npc/antlion/shell_impact3.wav" )
SWEP.Primary.HitFlesh		= Sound( "npc/antlion/foot4.wav" )
SWEP.Primary.Sound			= Sound( "npc/zombie/zo_attack1.wav" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 1.900

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= true

function SWEP:NoobHelp()

	self.Owner:NoticeOnce( "Right click to use your scream ability", GAMEMODE.Colors.Blue, 5, 10 )
	self.Owner:NoticeOnce( "Your scream will disorient nearby people", GAMEMODE.Colors.Blue, 5, 12 )

end

function SWEP:Holster()

	if SERVER then
	
		self.Owner:EmitSound( table.Random( self.Die ), 100, math.random(40,60) )
	
	end
	
	return true

end

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 8 )
	
	if SERVER then
	
		self.Owner:VoiceSound( self.Taunt, 100, math.random( 90, 100 ) )
		
		local hit = false
		
		for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		
			local dist = v:GetPos():Distance( self.Owner:GetPos() )
			
			if dist <= 350 then
			
				local scale = 1 - ( dist / 350 )
				local count = math.Round( scale * 4 )
				
				umsg.Start( "Drunk", v )
				umsg.Short( count )
				umsg.End()

				umsg.Start( "ScreamHit", v )
				umsg.End()
				
				v:TakeDamage( scale * 20, self.Owner, self.Weapon )
				v:SetDSP( 34, false )
				
				self.Owner:AddZedDamage( 5 )
				
				hit = true
			
			end
		
		end
		
		if hit then
		
			self.Owner:Notice( "You disoriented a human", GAMEMODE.Colors.Green )
		
		end
	
	end

end

function SWEP:PrimaryAttack()
	
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(130,150) )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.ThinkTime = CurTime() + ( self.Primary.Delay * 0.3 )
	
end

function SWEP:OnHitHuman( ent, dmg )

	if ent:GetRadiation() != 5 then

		ent:AddRadiation( 1 )
		
		self.Owner:AddZedDamage( 10 )
		
	end
	
	self.Owner:AddZedDamage( dmg )
	self.Owner:DrawBlood( 4 )
	self.Owner:Notice( "You irradiated a human", GAMEMODE.Colors.Green )

end