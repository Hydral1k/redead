if SERVER then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
end

if CLIENT then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "BASE WEAPON"
	SWEP.IconLetter = "c"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "CSSelectIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		//draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end
	
end

SWEP.HoldType = "pistol"

SWEP.ViewModel	= "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.SprintPos = Vector(0,0,0)
SWEP.SprintAng = Vector(0,0,0)

SWEP.ZoomModes = { 0, 50, 10 }
SWEP.ZoomSpeeds = { 5, 5, 5 }

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"

SWEP.Primary.Empty          = Sound( "weapons/clipempty_rifle.wav" )
SWEP.Primary.Sound			= Sound( "Weapon_USP.Single" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.SniperCone     = 0.025
SWEP.Primary.Delay			= 0.150

SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 200
SWEP.Primary.Automatic		= false

SWEP.Secondary.Sound        = Sound( "weapons/zoom.wav" )
SWEP.Secondary.Laser        = Sound( "weapons/ar2/ar2_empty.wav" )
SWEP.Secondary.Delay  		= 0.5

SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false

SWEP.LaserOffset = Vector(0,0,0)
SWEP.HolsterMode = false
SWEP.HolsterTime = 0
SWEP.LastRunFrame = 0

SWEP.MinShellDelay = 0.3
SWEP.MaxShellDelay = 0.6

SWEP.FalloffDistances = {}
SWEP.FalloffDistances[ "Sniper" ] = { Range = 3500, Falloff = 8000 }
SWEP.FalloffDistances[ "Rifle" ] = { Range = 2000, Falloff = 2000 }
SWEP.FalloffDistances[ "SMG" ] = { Range = 1500, Falloff = 1500 }
SWEP.FalloffDistances[ "Pistol" ] = { Range = 1000, Falloff = 500 }
SWEP.FalloffDistances[ "Buckshot" ] = { Range = 300, Falloff = 500 }

SWEP.UseShellSounds = true
SWEP.ShellSounds = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" }
SWEP.BuckshotShellSounds = { "weapons/fx/tink/shotgun_shell1.wav", "weapons/fx/tink/shotgun_shell2.wav", "weapons/fx/tink/shotgun_shell3.wav" } 

SWEP.Pitches = {}
SWEP.Pitches[ "Pistol" ] = 100
SWEP.Pitches[ "SMG" ] = 90
SWEP.Pitches[ "Rifle" ] = 80
SWEP.Pitches[ "Sniper" ] = 70
SWEP.Pitches[ "Buckshot" ] = 100

function SWEP:GetViewModelPosition( pos, ang )

    local newpos = nil
    local newang = nil
    local movetime = 0.25
    local duration = 0//self.Weapon:GetNWInt( "ViewTime", 0 )

    local pang = self.Owner:EyeAngles()
    local vel = self.Owner:GetVelocity()

    //if not newpos or not newang then

       // newpos = pos
       // newang = ang

    //end

    local mul = 0

    self.SwayScale = 1.0
    self.BobScale = 1.0

    if ( self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() > 0 ) or GAMEMODE:ElementsVisible() or self.HolsterMode then

        self.SwayScale = 1.25
        self.BobScale = 1.25

        if not self.SprintStart then

            self.SprintStart = CurTime()

        end

        mul = math.Clamp( ( CurTime() - self.SprintStart ) / movetime, 0, 1 )
        mul = -( mul - 1 ) ^ 2 + 1

        newang = self.SprintAng
        newpos = self.SprintPos

    else

        if self.SprintStart then

            self.SprintEnd = CurTime()
            self.SprintStart = nil

        end

        if self.SprintEnd then

            mul = math.Clamp( ( CurTime() - self.SprintEnd ) / movetime, 0, 1 )
            mul = ( mul - 1 ) ^ 2

            newang = self.SprintAng
            newpos = self.SprintPos

            if mul == 0 then

                self.SprintEnd = nil

            end

        else

            mul = self:GetMoveScale( movetime, duration, mul )

        end
    end

    return self:MoveViewModelTo( newpos, newang, pos, ang, mul )

end

function SWEP:GetMoveScale( movetime, duration, mul )

	mul = 1
		
	if CurTime() - movetime < duration then
	
		mul = math.Clamp( ( CurTime() - duration ) / movetime, 0, 1 )
		
	end
	
	if self.Weapon:GetNWBool( "ReverseAnim", false ) then
	
		return -( mul - 1 ) ^ 3
		
	end
	
	return ( mul - 1 ) ^ 3 + 1

end

function SWEP:AngApproach( newang, ang, mul )

	if not newang then return ang end

	ang:RotateAroundAxis( ang:Right(), 		newang.x * mul )
	ang:RotateAroundAxis( ang:Up(), 		newang.y * mul )
	ang:RotateAroundAxis( ang:Forward(), 	newang.z * mul )
	
	return ang

end

function SWEP:PosApproach( newpos, pos, ang, mul ) 

	local right 	= ang:Right()
	local up 		= ang:Up()
	local forward 	= ang:Forward()
	
	if not newpos then return pos end

	pos = pos + newpos.x * right * mul
	pos = pos + newpos.y * forward * mul
	pos = pos + newpos.z * up * mul
	
	return pos

end

function SWEP:MoveViewModelTo( newpos, newang, pos, ang, mul )

	ang = self:AngApproach( newang, ang, mul )
	pos = self:PosApproach( newpos, pos, ang, mul )
	
	return pos, ang

end

function SWEP:Initialize()

	self.Weapon:SetWeaponHoldType( self.HoldType )
	
end

function SWEP:Deploy()

	if SERVER then
	
		self.Weapon:SetZoomMode( 1 )
		self.Owner:DrawViewModel( true )
		
	end	

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end  

function SWEP:Holster()
	
	return true

end

function SWEP:Think()	

	self.Weapon:ReloadThink()

	if self.Owner:GetVelocity():Length() > 0 and self.Owner:KeyDown( IN_SPEED ) then
		
		self.LastRunFrame = CurTime() + 0.3
			
		self.Weapon:UnZoom()
		
	end

end

function SWEP:SetZoomMode( num )

	if num > #self.ZoomModes then
	
		num = 1

		self.Weapon:UnZoom()
		
	end
	
	self.Weapon:SetNWInt( "Mode", num )
	
	if self.Owner:GetFOV() != self.ZoomModes[num] then
	
		self.Owner:SetFOV( self.ZoomModes[num], self.ZoomSpeeds[num] )
		
	end

end

function SWEP:GetZoomMode()

	return self.Weapon:GetNWInt( "Mode", 1 )
	
end

function SWEP:UnZoom()

	if CLIENT then return end

	self.Weapon:SetZoomMode( 1 )
	self.Weapon:SetNWBool( "ReverseAnim", true )
	
	self.Owner:DrawViewModel( true )
	
end

function SWEP:Reload()

	if self.Weapon:Clip1() == self.Primary.ClipSize or self.Weapon:Clip1() > self.Owner:GetNWInt( "Ammo" .. self.AmmoType, 0 ) or self.HolsterMode or self.ReloadTime then return end
	
	if self.Owner:GetNWInt( "Ammo" .. self.AmmoType, 0 ) < 1 then 
	
		self.Weapon:SetClip1( self.Primary.ClipSize )
		
		return
	
	end

	if self.Weapon:GetZoomMode() != 1 then
	
		self.Weapon:UnZoom()
		
	end	

	self.Weapon:DoReload()
	
end

function SWEP:StartWeaponAnim( anim )
		
	if IsValid( self.Owner ) then
	
		local vm = self.Owner:GetViewModel()
	
		local idealSequence = self:SelectWeightedSequence( anim )
		local nextSequence = self:FindTransitionSequence( self.Weapon:GetSequence(), idealSequence )
		
		//vm:RemoveEffects( EF_NODRAW )
		//vm:SetPlaybackRate( pbr )

		if nextSequence > 0 then
		
			vm:SendViewModelMatchingSequence( nextSequence )
			
		else
		
			vm:SendViewModelMatchingSequence( idealSequence )
			
		end

		return vm:SequenceDuration( vm:GetSequence() )
		
	end	
	
end

function SWEP:DoReload()

	local time = self.Weapon:StartWeaponAnim( ACT_VM_RELOAD )
	
	self.Weapon:SetNextPrimaryFire( CurTime() + time + 0.080 )
	
	self.ReloadTime = CurTime() + time

end

function SWEP:ReloadThink()

	if self.ReloadTime and self.ReloadTime <= CurTime() then
	
		self.ReloadTime = nil
		self.Weapon:SetClip1( self.Primary.ClipSize )
	
	end

end

function SWEP:CanSecondaryAttack()

	if self.HolsterMode or self.Owner:KeyDown( IN_SPEED ) or self.LastRunFrame > CurTime() then return false end

	if self.Weapon:Clip1() <= 0 and self.IsSniper then
	
		if self.Weapon:GetZoomMode() != 1 then
		
			self.Weapon:UnZoom()
			
		end
	
		return false
		
	end
	
	return true
	
end

function SWEP:CanPrimaryAttack()

	if self.HolsterMode or self.ReloadTime or self.LastRunFrame > CurTime() then return false end
	
	if self.Owner:GetNWInt( "Ammo" .. self.AmmoType, 0 ) < 1 then 
	
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

function SWEP:ShootEffects()	

	if IsFirstTimePredicted() then
	
		self.Owner:ViewPunch( Angle( math.Rand( -0.2, -0.1 ) * self.Primary.Recoil, math.Rand( -0.05, 0.05 ) * self.Primary.Recoil, 0 ) )
		
	end
	
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	
	if CLIENT then return end
	
	if self.UseShellSounds then
	
		local pitch = self.Pitches[ self.AmmoType ] + math.random( -3, 3 )
		local tbl = self.ShellSounds
		local pos = self.Owner:GetPos()
		
		if self.AmmoType == "Buckshot" then
		
			tbl = self.BuckshotShellSounds
		
		end
	
		timer.Simple( math.Rand( self.MinShellDelay, self.MaxShellDelay ), function() sound.Play( table.Random( tbl ), pos, 50, pitch ) end )
		
	end
	
end

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
		
	end

end

function SWEP:SecondaryAttack()

	if not self.Weapon:CanSecondaryAttack() then return end
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.25 )
	
	if not self.IsSniper then
	
		self.Weapon:ToggleLaser()
	
		return
	
	end
	
	if SERVER then
		
		if self.Weapon:GetZoomMode() == 1 then
		
			self.Owner:DrawViewModel( false )
			
		end
		
		self.Weapon:SetZoomMode( self.Weapon:GetZoomMode() + 1 )
	
	end
	
	self.Weapon:EmitSound( self.Secondary.Sound )
	
end

function SWEP:ToggleLaser()

	self.Weapon:EmitSound( self.Secondary.Laser )
	self.Weapon:SetNWBool( "Laser", !self.Weapon:GetNWBool( "Laser", false ) )

end

function SWEP:AdjustMouseSensitivity()

	local num = self.Weapon:GetNWInt( "Mode", 1 )
	local scale = ( self.ZoomModes[ num ] or 0 ) / 100
	
	if scale == 0 then
	
		return nil
		
	end

	return scale
	
end		

function SWEP:GetDamageFalloffScale( distance )		

	local scale = 1		

	if distance > self.FalloffDistances[ self.AmmoType ].Range then		

		scale = ( 1 - ( ( distance - self.FalloffDistances[ self.AmmoType ].Range ) / self.FalloffDistances[ self.AmmoType ].Falloff ) )		

	end		
	
	return math.Clamp( scale, 0.1, 1.0 )
	
end

function SWEP:ShootBullets( damage, numbullets, aimcone, zoommode )

	if SERVER then
	
		self.Owner:AddStat( "Bullets", numbullets )
	
	end

	local scale = aimcone
	
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
	
		scale = aimcone * 1.75
		
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
	
		scale = math.Clamp( aimcone / 1.75, 0, 10 )
		
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 0
	bullet.Force	= damage * 2						
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	
	//if self.IsSniper and self.AmmoType == "Sniper" then
	
		//bullet.TracerName = "sniper_tracer"
	
	//end
	
	bullet.Callback = function( attacker, tr, dmginfo )
		
		dmginfo:ScaleDamage( self:GetDamageFalloffScale( tr.HitPos:Distance( self.Owner:GetShootPos() ) ) )
			
		if tr.Entity.NextBot then
			
			tr.Entity:OnLimbHit( tr.HitGroup, dmginfo )
			
		end

		if ( IsValid( tr.Entity ) and tr.Entity:IsPlayer() ) or math.random(1,5) != 1 then return end
		
		self.Weapon:BulletPenetration( attacker, tr, dmginfo, 0 )
		
	end
	
	self.Owner:LagCompensation( true )
	
	self.Owner:FireBullets( bullet )
	
	self.Owner:LagCompensation( false )
	
end

function SWEP:GetPenetrationDistance( mat_type )

	if ( mat_type == MAT_PLASTIC || mat_type == MAT_WOOD || mat_type == MAT_ALIENFLESH || mat_type == MAT_FLESH || mat_type == MAT_GLASS ) then
	
		return 64
	
	end
	
	return 32
	
end

function SWEP:GetPenetrationDamageLoss( mat_type, distance, damage )

	if ( mat_type == MAT_GLASS || mat_type == MAT_ALIENFLESH || mat_type == MAT_FLESH ) then
		return damage
	elseif ( mat_type == MAT_PLASTIC  || mat_type == MAT_WOOD ) then
		return damage - distance
	elseif( mat_type == MAT_TILE || mat_type == MAT_SAND || mat_type == MAT_DIRT ) then
		return damage - ( distance * 1.2 )
	end
	
	return damage - ( distance * 1.8 )
	
end

--[[function SWEP:BulletPenetration( attacker, tr, dmginfo, bounce )

	if ( !self or !IsValid( self.Weapon ) ) then return end
	
	if IsValid( tr.Entity ) and string.find( tr.Entity:GetClass(), "npc" ) then		
	
		local effectdata = EffectData()		
		effectdata:SetOrigin( tr.HitPos )		
		util.Effect( "BloodImpact", effectdata )		
	
	end		
	
	// Don't go through more than 3 times
	if ( bounce > 3 ) then return false end
	
	// Direction (and length) that we are gonna penetrate
	local PeneDir = tr.Normal * self:GetPenetrationDistance( tr.MatType )
		
	local PeneTrace = {}
	   PeneTrace.endpos = tr.HitPos
	   PeneTrace.start = tr.HitPos + PeneDir
	   PeneTrace.mask = MASK_SHOT
	   PeneTrace.filter = { self.Owner }
	   
	local PeneTrace = util.TraceLine( PeneTrace ) 
	
	// Bullet didn't penetrate.
	if ( PeneTrace.StartSolid or PeneTrace.Fraction >= 1.0 or tr.Fraction <= 0.0 ) then return false end
	
	local distance = ( PeneTrace.HitPos - tr.HitPos ):Length()
	local new_damage = self:GetPenetrationDamageLoss( tr.MatType, distance, dmginfo:GetDamage() )
	
	if new_damage > 0 then
	
		local bullet = 
		{	
			Num 		= 1,
			Src 		= PeneTrace.HitPos,
			Dir 		= tr.Normal,	
			Spread 		= Vector( 0, 0, 0 ),
			Tracer		= 0,
			Force		= 5,
			Damage		= new_damage,
			AmmoType 	= "Pistol",
		}
		
		bullet.Callback = function ( attacker, tr, dmginfo )
	
			if IsValid( self ) and IsValid( self.Weapon ) then
	
				self.Weapon:BulletPenetration( attacker, tr, dmginfo, bounce + 1 )
				
			end
		
		end
		
		local effectdata = EffectData()
		effectdata:SetOrigin( PeneTrace.HitPos )
		effectdata:SetNormal( PeneTrace.Normal )
		util.Effect( "Impact", effectdata ) 
		
		local func = function( attacker, bullet )
		
			if IsValid( attacker ) then
			
				attacker.FireBullets( attacker, bullet, true )
			
			end
		
		end
		
		timer.Simple( 0.05, function() func( attacker, bullet ) end )
		
		if SERVER and tr.MatType != MAT_FLESH then
	
			sound.Play( table.Random( GAMEMODE.Ricochet ), tr.HitPos, 100, math.random(90,120) )
	
		end
		
	end
	
end]]

function SWEP:BulletPenetration( attacker, tr, dmginfo, bounce )

	if ( !self or not IsValid( self.Weapon ) ) then return end
	
	if IsValid( tr.Entity ) and string.find( tr.Entity:GetClass(), "npc" ) then		
	
		local effectdata = EffectData()		
		effectdata:SetOrigin( tr.HitPos )		
		util.Effect( "BloodImpact", effectdata )		
	
	end	
	
	if ( bounce > 3 ) then return false end
	
	local PeneDir = tr.Normal * self:GetPenetrationDistance( tr.MatType )
		
	local PeneTrace = {}
	   PeneTrace.endpos = tr.HitPos
	   PeneTrace.start = tr.HitPos + PeneDir
	   PeneTrace.mask = MASK_SHOT
	   PeneTrace.filter = { self.Owner }
	   
	local PeneTrace = util.TraceLine( PeneTrace ) 
	
	if ( PeneTrace.StartSolid || PeneTrace.Fraction >= 1.0 || tr.Fraction <= 0.0 ) then return false end
	
	local distance = ( PeneTrace.HitPos - tr.HitPos ):Length()
	local new_damage = self:GetPenetrationDamageLoss( tr.MatType, distance, dmginfo:GetDamage() )
	
	if new_damage > 0 then
	
		local bullet = 
		{	
			Num 		= 1,
			Src 		= PeneTrace.HitPos,
			Dir 		= tr.Normal,	
			Spread 		= Vector( 0, 0, 0 ),
			Tracer		= 0,
			Force		= 5,
			Damage		= new_damage,
			AmmoType 	= "Pistol",
		}
		
		bullet.Callback = function( a, b, c ) 
		
			if IsValid( self ) and IsValid( self.Weapon ) then
	
				self.Weapon:BulletPenetration( attacker, tr, dmginfo, bounce + 1 )
						
			end 
			
		end
		
		local effectdata = EffectData()
		effectdata:SetOrigin( PeneTrace.HitPos );
		effectdata:SetNormal( PeneTrace.Normal );
		util.Effect( "Impact", effectdata ) 
		
		timer.Simple( 0.01, function() attacker:FireBullets( bullet, true ) end )
		
		if SERVER and tr.MatType != MAT_FLESH and bounce == 0 then
	
			sound.Play( table.Random( GAMEMODE.Ricochet ), tr.HitPos, 100, math.random(90,120) )
	
		end
		
	end
	
end

function SWEP:ShouldNotDraw()

	return self.Weapon:GetNWBool( "Laser", false )
	
end

if CLIENT then

	SWEP.CrossRed = CreateClientConVar( "cl_redead_crosshair_r", 255, true, false )
	SWEP.CrossGreen = CreateClientConVar( "cl_redead_crosshair_g", 255, true, false )
	SWEP.CrossBlue = CreateClientConVar( "cl_redead_crosshair_b", 255, true, false )
	SWEP.CrossAlpha = CreateClientConVar( "cl_redead_crosshair_a", 255, true, false )
	SWEP.CrossLength = CreateClientConVar( "cl_redead_crosshair_length", 10, true, false )
	
	SWEP.DotMat = Material( "Sprites/light_glow02_add_noz" )
	SWEP.LasMat = Material( "sprites/bluelaser1" )

end

SWEP.CrosshairScale = 1

function SWEP:LaserDraw()

	local vm = self.Owner:GetViewModel()
	
	if IsValid( vm ) then
	
		local idx = vm:LookupAttachment( "1" )
		
		if idx == 0 then idx = vm:LookupAttachment( "muzzle" ) end
		
		local trace = util.GetPlayerTrace( ply )
		local tr = util.TraceLine( trace )
		local tbl = vm:GetAttachment( idx )
		
		local pos = tr.HitPos
		
		if vm:GetSequence() != ACT_VM_IDLE then
			
			self.AngDiff = ( tbl.Ang - self.LastGoodAng ):Forward()
			
			trace = {}
			trace.start = tbl.Pos or Vector(0,0,0)
			trace.endpos = trace.start + ( ( EyeAngles() + self.AngDiff ):Forward() * 99999 )
			trace.filter = { self.Owner, self.Weapon }
		
			local tr2 = util.TraceLine( trace )
			
			pos = tr2.HitPos
			
		else
		
			self.LastGoodAng = tbl.Ang
		
		end
		
		cam.Start3D( EyePos(), EyeAngles() )
		
			local dir = ( tbl.Ang ):Forward()
			local start = tbl.Pos
	
			render.SetMaterial( self.LasMat )
			
			for i=0,254 do
			
				render.DrawBeam( start, start + dir * 5, 2, 0, 12, Color( 255, 0, 0, 255 - i ) )
				
				start = start + dir * 5
				
			end
				
			local dist = tr.HitPos:Distance( EyePos() )
			local size = math.Rand( 6, 7 )
			local dotsize = dist / size ^ 2
			
			render.SetMaterial( self.DotMat )
			render.DrawQuadEasy( pos, ( EyePos() - tr.HitPos ):GetNormal(), dotsize, dotsize, Color( 255, 0, 0, 255 ), 0 )
			
		cam.End3D()
		
	end	

end

function SWEP:DrawHUD()

	if self.Weapon:ShouldNotDraw() then return end
	
	if self.Weapon:GetNWBool( "Laser", false ) then return end
	
	local mode = self.Weapon:GetZoomMode()

	if not self.IsSniper or mode == 1 then
	
		local cone = self.Primary.Cone
		local scale = cone
	
		if self.IsSniper then
		
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
	
		return
	
	end
	
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
		surface.DrawLine( 0, h * 0.50, w, h * 0.50 )
		surface.DrawLine( w * 0.50, 0, w * 0.50, h )
		
	end
	
end

