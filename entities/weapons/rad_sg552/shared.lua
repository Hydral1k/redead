if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "SG 552"
	SWEP.IconLetter = "A"
	SWEP.Slot = 4
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_sg552", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.ViewModel			= "models/weapons/v_rif_sg552.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_sg552.mdl"

SWEP.SprintPos = Vector (-2.629, -4.8963, 1.4033)
SWEP.SprintAng = Vector (-7.3401, -31.7536, 3.9563)

SWEP.IronPos = Vector (6.7835, -10.4656, 2.3705)
SWEP.IronAng = Vector (3.9725, 1.9759, -0.0066)

SWEP.ZoomModes = { 0, 35 }
SWEP.ZoomSpeeds = { 0.25, 0.35 }

SWEP.IsSniper = true
SWEP.AmmoType = "Rifle"

SWEP.Primary.Sound			= Sound( "Weapon_SG552.Single" )
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Damage			= 55
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.010
SWEP.Primary.Delay			= 0.210

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true

SWEP.Primary.ShellType = SHELL_556

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

end

function SWEP:DrawHUD()

	if self.Weapon:ShouldNotDraw() then return end

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	local scalebywidth = ( ScrW() / 1024 ) * 10
	local scale = self.Primary.Cone
		
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		
		scale = self.Primary.Cone * 1.75
			
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
		
		scale = math.Clamp( self.Primary.Cone / 1.75, 0, 10 )
			
	end
		
	scale = scale * scalebywidth
		
	local dist = math.abs( self.CrosshairScale - scale )
	self.CrosshairScale = math.Approach( self.CrosshairScale, scale, FrameTime() * 2 + dist * 0.05 )
		
	local gap = 40 * self.CrosshairScale
	local length = gap + 20 * self.CrosshairScale
		
	surface.SetDrawColor( self.CrossRed:GetInt(), self.CrossGreen:GetInt(), self.CrossBlue:GetInt(), self.CrossAlpha:GetInt() )
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
	
	local mode = self.Weapon:GetNWInt( "Mode", 1 )
	
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