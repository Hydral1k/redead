if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "SG 552"
	SWEP.IconLetter = "A"
	SWEP.Slot = 4
	SWEP.Slotpos = 2
	
end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.ViewModel			= "models/weapons/v_rif_sg552.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_sg552.mdl"

SWEP.SprintPos = Vector (-2.629, -4.8963, 1.4033)
SWEP.SprintAng = Vector (-7.3401, -31.7536, 3.9563)

SWEP.ZoomModes = { 0, 35 }
SWEP.ZoomSpeeds = { 0.25, 0.35 }

SWEP.IsSniper = true
SWEP.AmmoType = "Rifle"

SWEP.Primary.Sound			= Sound( "Weapon_SG552.Single" )
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Damage			= 60
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.005
SWEP.Primary.SniperCone		= 0.020
SWEP.Primary.Delay			= 0.210

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true

function SWEP:SetZoomMode( num )

	if num > 2 then
	
		num = 1

		self.Weapon:UnZoom()
		
	end
	
	self.Weapon:SetNWInt( "Mode", num )
	self.Owner:SetFOV( self.ZoomModes[num], self.ZoomSpeeds[num] )

end

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then 
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.25 )
		
		return 
		
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:SetClip1( self.Weapon:Clip1() - 1 )
	self.Weapon:ShootEffects()
	
	if self.IsSniper and self.Weapon:GetZoomMode() == 1 then
	
		self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.SniperCone, 1 )
	
	else
	
		self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Weapon:GetZoomMode() )
	
	end
	
	--[[if self.Weapon:GetZoomMode() > 1 then
	
		self.Weapon:UnZoom()
	
	end]]
	
	if SERVER then
	
		self.Owner:AddAmmo( self.AmmoType, -1 )
		
	end

end

function SWEP:DrawHUD()

	if self.Weapon:ShouldNotDraw() then return end
	
	local mode = self.Weapon:GetZoomMode()

	local cone = self.Primary.Cone
	local scale = cone
	
	if mode == 1 then
		
		cone = self.Primary.SniperCone
		scale = cone
		
	end

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	local scalebywidth = ( ScrW() / 1024 ) * 10
		
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
			
		scale = cone * 1.75
				
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
			
		scale = math.Clamp( cone / 1.75, 0, 10 )
				
	end
			
	scale = scale * scalebywidth
		
	local dist = math.abs( self.CrosshairScale - scale )
	self.CrosshairScale = math.Approach( self.CrosshairScale, scale, FrameTime() * 2 + dist * 0.05 )
			
	local gap = 40 * self.CrosshairScale
	local length = gap + self.CrossLength:GetInt() //20 * self.CrosshairScale
			
	surface.SetDrawColor( self.CrossRed:GetInt(), self.CrossGreen:GetInt(), self.CrossBlue:GetInt(), self.CrossAlpha:GetInt() )
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
		
	if mode != 1 then
		
		local w = ScrW()
		local h = ScrH()
		local wr = ( h / 3 ) * 4

		surface.SetTexture( surface.GetTextureID( "gmod/scope" ) )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawTexturedRect( ( w / 2 ) - wr / 2, 0, wr, h )
			
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, ( w / 2 ) - wr / 2, h )
		surface.DrawRect( ( w / 2 ) + wr / 2, 0, w - ( ( w / 2 ) + wr / 2 ), h )
		
	end
	
end