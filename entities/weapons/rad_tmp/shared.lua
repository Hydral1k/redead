if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "TMP"
	SWEP.IconLetter = "x"
	SWEP.Slot = 3
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_tmp", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "pistol"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel = "models/weapons/w_smg_tmp.mdl"

SWEP.SprintPos = Vector (2.0027, -0.751, 0.1411)
SWEP.SprintAng = Vector (-1.2669, -27.7284, 10.4434)

SWEP.IronPos = Vector (4.8797, -1.6067, 3.121)
SWEP.IronAng = Vector (-1.8649, 0.4487, -5.7797)

SWEP.IronPos2 = Vector (5.2431, -1.6067, 2.5137)
SWEP.IronAng2 = Vector (0.7738, -0.0637, 0.0471)

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"

SWEP.Primary.Sound			= Sound( "Weapon_USP.SilencedShot" )
SWEP.Primary.Recoil			= 7.5
SWEP.Primary.Damage			= 27
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.040
SWEP.Primary.Delay			= 0.075

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true

SWEP.Primary.ShellType = SHELL_9MM

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then 
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return 
		
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Weapon:GetZoomMode() )
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:ShootEffects()
	
	if self.Weapon:GetZoomMode() > 1 then
	
		self.Weapon:UnZoom()
	
	end
	
	if SERVER then
	
		self.Owner:AddAmmo( self.AmmoType, -1 )
		
		self.Weapon:SetNWVector( "ViewVector", self.IronPos2 )
		self.Weapon:SetNWVector( "ViewAngle", self.IronAng2 )
		
	end

end

function SWEP:ReloadThink()

	if self.ReloadTime and self.ReloadTime <= CurTime() then
	
		self.ReloadTime = nil
		self.Weapon:SetClip1( self.Primary.ClipSize )
		self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
	
	end

end