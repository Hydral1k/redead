if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Dual Berettas"
	SWEP.IconLetter = "s"
	SWEP.Slot = 2
	SWEP.Slotpos = 0
	
end

SWEP.HoldType = "duel"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"

SWEP.SprintPos = Vector (-0.626, 0.5615, 3.5852)
SWEP.SprintAng = Vector (-25.2347, -3.1815, 0.3427)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.AnimPos = 1

SWEP.Anims = {}
SWEP.Anims[1] = ACT_VM_SECONDARYATTACK
SWEP.Anims[2] = ACT_VM_PRIMARYATTACK

SWEP.Primary.Sound			= Sound( "Weapon_Elite.Single" )
SWEP.Primary.Recoil			= 9.5
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.040
SWEP.Primary.Delay			= 0.180

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= false

function SWEP:ShootEffects()	

	if IsFirstTimePredicted() then
	
		self.Owner:ViewPunch( Angle( math.Rand( -0.2, -0.1 ) * self.Primary.Recoil, math.Rand( -0.05, 0.05 ) * self.Primary.Recoil, 0 ) )
		
	end
	
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	
	self.Weapon:SendWeaponAnim( self.Anims[ self.AnimPos ] )

	self.AnimPos = self.AnimPos + 1
	
	if self.AnimPos > 2 then
	
		self.AnimPos = 1
	
	end
	
end

--[[function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then 
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return 
		
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Weapon:GetZoomMode() )
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:ShootEffects()
	
	if SERVER then
	
		self.Owner:AddAmmo( self.AmmoType, -1 )
		
	end

end]]
