
Sharpen = 0
MotionBlur = 0
ViewWobble = 0
DisorientTime = 0

ColorModify = {}
ColorModify[ "$pp_colour_addr" ] 		= 0
ColorModify[ "$pp_colour_addg" ] 		= 0
ColorModify[ "$pp_colour_addb" ] 		= 0
ColorModify[ "$pp_colour_brightness" ] 	= 0
ColorModify[ "$pp_colour_contrast" ] 	= 1
ColorModify[ "$pp_colour_colour" ] 		= 1
ColorModify[ "$pp_colour_mulr" ] 		= 0
ColorModify[ "$pp_colour_mulg" ] 		= 0
ColorModify[ "$pp_colour_mulb" ] 		= 0

MixedColorMod = {}

function GM:RenderScreenspaceEffects()

	local approach = FrameTime() * 0.05

	if ( Sharpen > 0 ) then
	
		DrawSharpen( Sharpen, 0.5 )
		
		Sharpen = math.Approach( Sharpen, 0, FrameTime() * 0.5 )
		
	end

	if ( MotionBlur > 0 ) then
	
		DrawMotionBlur( 1 - MotionBlur, 1.0, 0.0 )
		
		MotionBlur = math.Approach( MotionBlur, 0, approach )
		
	end
	
	if LocalPlayer():FlashlightIsOn() then
	
		ColorModify[ "$pp_colour_brightness" ] = math.Approach( ColorModify[ "$pp_colour_brightness" ], 0.01, FrameTime() * 0.25 ) 
		ColorModify[ "$pp_colour_contrast" ] = math.Approach( ColorModify[ "$pp_colour_contrast" ], 1.02, FrameTime() * 0.25 ) 
	
	end
	
	local rads = LocalPlayer():GetNWInt( "Radiation", 0 )
	
	if rads > 0 and LocalPlayer():Alive() then
		
		local scale = rads / 5
		
		MotionBlur = math.Approach( MotionBlur, scale * 0.5, FrameTime() )
		Sharpen = math.Approach( Sharpen, scale * 5, FrameTime() * 3 )
	
		ColorModify[ "$pp_colour_colour" ] = math.Approach( ColorModify[ "$pp_colour_colour" ], 1.0 - scale * 0.8, FrameTime() * 0.1 )
		
	end
	
	if LocalPlayer():Team() == TEAM_ZOMBIES then
	
		if LocalPlayer():Alive() then
	
			ColorModify[ "$pp_colour_brightness" ] 	= -0.20
			ColorModify[ "$pp_colour_addr" ]		= 0.25
			ColorModify[ "$pp_colour_mulr" ] 		= 0.15
			ColorModify[ "$pp_colour_addg" ]		= 0.15
			
		else
		
			ColorModify[ "$pp_colour_addr" ]		= 0.25
			ColorModify[ "$pp_colour_mulr" ] 		= 0.30
			ColorModify[ "$pp_colour_addg" ]		= 0.05
			ColorModify[ "$pp_colour_brightness" ] 	= -0.20
			
			MotionBlur = 0.40
		
		end
	
	else
	
		if not LocalPlayer():Alive() then
	
			ColorModify[ "$pp_colour_addr" ]		= 0.25
			ColorModify[ "$pp_colour_mulr" ] 		= 0.30
			ColorModify[ "$pp_colour_brightness" ] 	= -0.20
			
			MotionBlur = 0.40
			
		elseif LocalPlayer():GetNWBool( "Infected", false ) then
		
			ColorModify[ "$pp_colour_brightness" ] = -0.02
			ColorModify[ "$pp_colour_mulg" ] = 0.55
			ColorModify[ "$pp_colour_addg" ] = 0.05
			
			MotionBlur = 0.30
		
		end
	
	end
	
	for k,v in pairs( ColorModify ) do
		
		if k == "$pp_colour_colour" or k == "$pp_colour_contrast" then
		
			ColorModify[k] = math.Approach( ColorModify[k], 1, approach ) 
		
		elseif k == "$pp_colour_brightness" and GetGlobalBool( "GameOver", false ) then
		
			ColorModify[k] = -1.50
		
		else
		
			ColorModify[k] = math.Approach( ColorModify[k], 0, approach ) 
		
		end
	
		MixedColorMod[k] = math.Approach( MixedColorMod[k] or 0, ColorModify[k], FrameTime() * 0.10 )
	
	end
	
	DrawColorModify( MixedColorMod )
	DrawPlayerRenderEffects()
	
end

function GM:GetMotionBlurValues( y, x, fwd, spin ) 

	if LocalPlayer():Team() == TEAM_ZOMBIES then return y, x, fwd, spin end

	if LocalPlayer():Alive() and LocalPlayer():Health() <= 50 then
	
		local scale = math.Clamp( LocalPlayer():Health() / 50, 0, 1 )
		// local beat = math.Clamp( HeartBeat - CurTime(), 0, 2 ) * ( 1 - scale )
		
		fwd = 1 - scale // + beat
		
	elseif LocalPlayer():GetNWBool( "InIron", false ) then
	
		fwd = 0.05
		
	end
	
	if DisorientTime and DisorientTime > CurTime() then
	
		if not LocalPlayer():Alive() then 
			DisorientTime = nil
		end
	
		local scale = ( ( DisorientTime or 0 ) - CurTime() ) / 10
		local newx, newy = RotateAroundCoord( 0, 0, 1, scale * 0.05 )
		
		return newy, newx, fwd, spin
	
	end
	
	if ScreamTime and ScreamTime > CurTime() then
	
		if not LocalPlayer():Alive() then 
			ScreamTime = nil
		end
		
		local scale = ( ( ScreamTime or 0 ) - CurTime() ) / 10
		local newy = math.sin( CurTime() * 1.5 ) * scale * 0.08
		
		return newy, x, fwd, spin
	
	end
	
	return y, x, fwd, spin

end

function RotateAroundCoord( x, y, speed, dist )

	local newx = x + math.sin( CurTime() * speed ) * dist
	local newy = y + math.cos( CurTime() * speed ) * dist

	return newx, newy

end

local MaterialVision = Material( "toxsin/allyvision" )
local MaterialItem = Material( "toxsin/allyvision" )

//MaterialItem:SetMaterialInt( "$ignorez", 0 )

function DrawPlayerRenderEffects()
	
	if LocalPlayer():Team() != TEAM_ZOMBIES and LocalPlayer():Team() != TEAM_ARMY then return end
	
	if GetGlobalBool( "GameOver", false ) then return end
	
	cam.Start3D( EyePos(), EyeAngles() )
	
	if ValidEntity( TargetedEntity ) and TargetedEntity:GetClass() == "prop_physics" then
	
		if TargetedEntity:GetPos():Distance( LocalPlayer():GetPos() ) < 500 then
		
			local scale = 1 - ( TargetedEntity:GetPos():Distance( LocalPlayer():GetPos() ) / 500 )
			
			render.SuppressEngineLighting( true )
			render.SetBlend( scale * 0.4 )
			render.SetColorModulation( 0, 0.5, 0 )
			
			render.MaterialOverride( MaterialItem )
			
			cam.IgnoreZ( false )

			TargetedEntity:DrawModel()
	 
			render.SuppressEngineLighting( false )
			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 1 )
			
			render.MaterialOverride( 0 )
		
		end
	
	end
	
	for k,v in pairs( player.GetAll() ) do
		
		if ( v:IsPlayer() and v:Alive() and v != LocalPlayer() and v:Team() == TEAM_ARMY ) then
			
			local scale = ( math.Clamp( v:GetPos():Distance( LocalPlayer():GetPos() ), 500, 3000 ) - 500 ) / 2500

			render.SuppressEngineLighting( true )
			render.SetBlend( scale )
			
			render.MaterialOverride( MaterialVision )
		
			if LocalPlayer():Team() == TEAM_ARMY then
		
				render.SetColorModulation( 0, 0.2, 1.0 )
				
			else
			
				render.SetColorModulation( 1.0, 0.2, 0 )
			
			end
	 
			cam.IgnoreZ( false )
	 
			v:SetupBones()
			v:DrawModel()
	 
			render.SuppressEngineLighting( false )
			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 1 )
			
			render.MaterialOverride( 0 )

		end
		
	end
	
	cam.End3D()

end

WalkTimer = 0
VelSmooth = 0
DeathAngle = Angle(0,0,0)
DeathOrigin = Vector(0,0,0)

function GM:CalcView( ply, origin, angle, fov )

	local vel = ply:GetVelocity()
	local ang = ply:EyeAngles()
	
	VelSmooth = VelSmooth * 0.5 + vel:Length() * 0.1
	WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.1
	
	angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.002
	
	local scale = LocalPlayer():GetNWInt( "Radiation", 0 ) / 5
	local wobble = 0
	
	if scale > 0 and LocalPlayer():Alive() then
	
		wobble = 0.3 * scale
		
	end
	
	local drunkscale = Drunkness / 10
	
	if Drunkness > 0 then
	
		if ( DrunkTimer or 0 ) < CurTime() then
		
			Drunkness = math.Clamp( Drunkness - 1, 0, 20 )
			DrunkTimer = CurTime() + 10
		
		end
		
		wobble = wobble + ( drunkscale * 0.3 )

	end
	
	if LocalPlayer():Health() <= 75 and LocalPlayer():Alive() then
	
		local hscale = math.Clamp( LocalPlayer():Health() / 50, 0, 1 )
		wobble = wobble + ( 0.2 - 0.2 * hscale )
		
	end
	
	ViewWobble = math.Approach( ViewWobble - 0.05 * FrameTime(), wobble, FrameTime() * 0.25 ) 
	
	if ply:Alive() then
	
		if ViewWobble > 0 then
	
			angle.roll = angle.roll + math.sin( CurTime() + TimeSeed( 1, -2, 2 ) ) * ( ViewWobble * 15 )
			angle.pitch = angle.pitch + math.sin( CurTime() + TimeSeed( 2, -2, 2 ) ) * ( ViewWobble * 15 )
			angle.yaw = angle.yaw + math.sin( CurTime() + TimeSeed( 3, -2, 2 ) ) * ( ViewWobble * 15 )
			
		end
		
		DeathAngle = angle
		DeathOrigin = origin
		
	elseif not ply:Alive() and CV_RagdollVision:GetBool() then
	
		local rag = ply:GetRagdollEntity()
		
		if ValidEntity( rag ) then
			
			local eyes = rag:LookupAttachment( "eyes" )
			local tbl = rag:GetAttachment( eyes )
			
			if tbl then
			
				angle = tbl.Ang
				origin = tbl.Pos + ( tbl.Ang:Up() * 16 ) + ( tbl.Ang:Forward() * -8 )
				
			end
		
		end
	
	end
	
	if ply:GetGroundEntity() != NULL then
	
		angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.001
		angle.pitch = angle.pitch + math.cos( WalkTimer * 1.25 ) * VelSmooth * 0.005
		
	end
		
	return self.BaseClass:CalcView( ply, origin, angle, fov )
	
end
