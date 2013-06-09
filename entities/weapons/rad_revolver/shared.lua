if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	
	SWEP.PrintName = "Colt Python"
	SWEP.IconLetter = "f"
	SWEP.Slot = 2
	SWEP.Slotpos = 1
	
end

SWEP.HoldType = "revolver"

SWEP.Base = "rad_base"

SWEP.UseHands = true

SWEP.ViewModel	= "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.SprintPos = Vector (2.4955, 2.1219, 2.9007)
SWEP.SprintAng = Vector (-10.2034, 15.2433, 0)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_357.Single" )
SWEP.Primary.Recoil			= 13.5
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.030
SWEP.Primary.Delay			= 0.850

SWEP.Primary.ClipSize		= 6
SWEP.Primary.Automatic		= false

function SWEP:ShootEffects()	

	if SERVER then
	
		self.Owner:ViewBounce( self.Primary.Recoil )  
		
	end
	
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	
	if CLIENT then return end

	local tbl = self.ShellSounds[ ( self.Primary.ShellType or 1 ) ] 
	local pos = self.Owner:GetPos()
	
	//timer.Simple( math.Rand( self.MinShellDelay, self.MaxShellDelay ), function() sound.Play( table.Random( tbl.Wavs ), pos, 75, tbl.Pitch ) end )
	
	--[[local ed = EffectData()
	ed:SetOrigin( self.Owner:GetShootPos() )
	ed:SetEntity( self.Weapon )
	ed:SetAttachment( self.Weapon:LookupAttachment( "2" ) )
	ed:SetScale( ( self.Primary.ShellType or SHELL_9MM ) )
	util.Effect( "weapon_shell", ed, true, true )]]
	
end