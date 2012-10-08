if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.PrintName = "CMP-250"
	SWEP.IconLetter = "f"
	SWEP.Slot = 2
	SWEP.Slotpos = 1
	
	killicon.AddFont( "rad_cmp", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "smg"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"

SWEP.IronPos = Vector (-6.39, -0.5168, 1.8135)
SWEP.IronAng = Vector (2.4247, 0.1947, 0.8866)

SWEP.SprintPos = Vector (3.6907, -0.6364, -0.5846)
SWEP.SprintAng = Vector (-2.2928, 28.9069, 0)

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"
SWEP.FirstShot = true

SWEP.Primary.Sound			= Sound( "Weapon_smg1.Single" )
SWEP.Primary.Sound2			= Sound( "Weapon_smg1.Burst" )
SWEP.Primary.ReloadSound    = Sound( "Weapon_smg1.reload" )
SWEP.Primary.Recoil			= 11.5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.040
SWEP.Primary.Delay			= 0.550
SWEP.Primary.ShotDelay      = 0.055

SWEP.Primary.ClipSize		= 20
SWEP.Primary.Automatic		= true

SWEP.Primary.ShellType = SHELL_9MM

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then 
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return 
		
	end
	
	if self.FirstShot then
	
		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.ShotDelay )
		self.AutoShoot = CurTime() + self.Primary.ShotDelay
	
	else
	
		self.Owner:EmitSound( self.Primary.Sound2, 100, math.random(95,105) )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	end
	
	self.FirstShot = !self.FirstShot

	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Weapon:GetZoomMode() )
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:ShootEffects()
	
	if self.Weapon:GetZoomMode() > 1 then
	
		self.Weapon:UnZoom()
	
	end
	
	if SERVER then
	
		self.Owner:AddAmmo( self.AmmoType, -1 )
		
	end

end

function SWEP:DoReload()

	local time = self.Weapon:StartWeaponAnim( ACT_VM_RELOAD )
	
	self.Weapon:SetNextPrimaryFire( CurTime() + time + 0.080 )
	self.Weapon:EmitSound( self.Primary.ReloadSound )
	
	self.ReloadTime = CurTime() + time

end

function SWEP:ReloadThink()

	if self.AutoShoot and self.AutoShoot <= CurTime() then
	
		self.AutoShoot = nil
		
		if not self.Owner:KeyDown( IN_ATTACK ) then
		
			self.Weapon:PrimaryAttack()
			
		end
	
	end

	if self.ReloadTime and self.ReloadTime <= CurTime() then
	
		self.ReloadTime = nil
		self.Weapon:SetClip1( self.Primary.ClipSize )
	
	end

end