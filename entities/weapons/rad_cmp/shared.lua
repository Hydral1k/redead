if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.PrintName = "CMP-250"
	SWEP.IconLetter = "f"
	SWEP.Slot = 3
	SWEP.Slotpos = 1
	
end

SWEP.HoldType = "smg"

SWEP.Base = "rad_base"

SWEP.UseHands = true

SWEP.ViewModel	= "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"

SWEP.SprintPos = Vector (3.6907, -0.6364, -0.5846)
SWEP.SprintAng = Vector (-2.2928, 28.9069, 0)

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"
SWEP.FirstShot = true

SWEP.Primary.Sound			= Sound( "Weapon_smg1.Burst" )
SWEP.Primary.Sound2			= Sound( "weapons/smg1/smg1_fireburst1.wav" )
SWEP.Primary.ReloadSound    = Sound( "Weapon_smg1.reload" )
SWEP.Primary.Recoil			= 12.5
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 3
SWEP.Primary.Cone			= 0.045
SWEP.Primary.Delay			= 0.600

SWEP.Primary.ClipSize		= 18
SWEP.Primary.Automatic		= true

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then 
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.25 )
		
		return 
		
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:SetClip1( self.Weapon:Clip1() - self.Primary.NumShots )
	self.Weapon:ShootEffects()
	
	if self.IsSniper and self.Weapon:GetZoomMode() == 1 then
	
		self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.SniperCone, 1 )
	
	else
	
		self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Weapon:GetZoomMode() )
	
	end
	
	if self.Weapon:GetZoomMode() > 1 then
	
		self.Weapon:UnZoom()
	
	end
	
	if SERVER then
	
		self.Owner:AddAmmo( self.AmmoType, self.Primary.NumShots * -1 )
		self.Owner:EmitSound( self.Primary.Sound2, 100, math.random( 120, 130 ) )
		
	end

end

function SWEP:CanPrimaryAttack()

	if self.HolsterMode or self.ReloadTime or self.LastRunFrame > CurTime() then return false end
	
	if self.Owner:GetNWInt( "Ammo" .. self.AmmoType, 0 ) < self.Primary.NumShots then 
	
		self.Weapon:EmitSound( self.Primary.Empty )
		
		return false 
		
	end

	if self.Weapon:Clip1() <= 0 then
	
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		self.Weapon:DoReload()
		
		if self.Weapon:GetZoomMode() != 1 then
		
			self.Weapon:UnZoom()
			
		end	
		
		return false
		
	end
	
	return true
	
end

--[[function SWEP:PrimaryAttack()

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
	
	if SERVER then
	
		self.Owner:AddAmmo( self.AmmoType, -1 )
		
	end

end]]

function SWEP:DoReload()

	local time = self.Weapon:StartWeaponAnim( ACT_VM_RELOAD )
	
	self.Weapon:SetNextPrimaryFire( CurTime() + time + 0.100 )
	self.Weapon:EmitSound( self.Primary.ReloadSound )
	
	self.ReloadTime = CurTime() + time

end

function SWEP:ReloadThink()

	if self.ReloadTime and self.ReloadTime <= CurTime() then
	
		self.ReloadTime = nil
		self.Weapon:SetClip1( self.Primary.ClipSize )
	
	end

end