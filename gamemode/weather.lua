
GM.Weather = {}
GM.Weather.Rain = 0
GM.Weather.Thunder = 0
GM.Weather.Lightning = 0
GM.Weather.Wind = 0
GM.Weather.TransitionTime = 60 // 1 minute for weather transitions

GM.Weather.New = {}
GM.Weather.New.Rain = 0
GM.Weather.New.Thunder = 0
GM.Weather.New.Lightning = 0
GM.Weather.New.Wind = 0 

function GM:EntityKeyValue( ent, key, val )
     
	if ent:GetClass() == "worldspawn" and key == "skyname" then
                        
		SetGlobalString( "SkyName", val )
	
	end
	
end

function GM:WeatherInit()

	if CLIENT then
	
		RainEmitter = ParticleEmitter( Vector(0,0,0) )
	
	end

end

function GM:PlayerIndoors( ply )

	if SERVER then
	
		return ply:IsIndoors()
	
	else
	
		local tr = util.TraceLine( util.GetPlayerTrace( LocalPlayer(), Vector(0,0,1) ) )
	
		if tr.HitWorld and not tr.HitSky then 
			
			GAMEMODE.PlayerIsIndoors = true 
			
			return true 
			
		end
	
	end
	
	GAMEMODE.PlayerIsIndoors = false
	
	return false

end

function GM:RandomizeWeather( force )

	GAMEMODE.Weather.New.Rain = 0
	GAMEMODE.Weather.New.Thunder = 0
	GAMEMODE.Weather.New.Lightning = 0
	GAMEMODE.Weather.New.Wind = 0

	if math.random(1,5) == 1 and not force then

		GAMEMODE:SynchWeather()
	
		return {0,0,0,0} 
		
	end
	
	for k,v in pairs( GAMEMODE.Weather.New ) do
	
		if math.random(1,5) > 1 then
	
			GAMEMODE.Weather.New[k] = math.Rand(0,1)
			
			if math.random(1,3) == 1 then
			
				GAMEMODE.Weather.New[k] = 1
			
			end
		
		end
	
	end
	
	local count = 0
	
	for k,v in pairs( GAMEMODE.Weather.New ) do
	
		if v == 0 then
		
			count = count + 1
		
		end
	
	end
	
	if count == 4 or math.random(1,10) == 1 then
	
		GAMEMODE.Weather.New.Rain = 1
		GAMEMODE.Weather.New.Thunder = 1
		GAMEMODE.Weather.New.Lightning = 1
		GAMEMODE.Weather.New.Wind = 1
	
	end
	
	GAMEMODE:SynchWeather()
	
	return { GAMEMODE.Weather.New.Rain, GAMEMODE.Weather.New.Thunder, GAMEMODE.Weather.New.Lightning, GAMEMODE.Weather.New.Wind }

end

function GM:ManualWeather( rain, thunder, lightning, wind )

	GAMEMODE.Weather.New.Rain = rain
	GAMEMODE.Weather.New.Thunder = thunder
	GAMEMODE.Weather.New.Lightning = lightning
	GAMEMODE.Weather.New.Wind = wind
	
	GAMEMODE.Weather.NextShift = CurTime() + math.random( 240, 480 )
	
	GAMEMODE:SynchWeather()

end

function GM:ShiftWeather()

	for k,v in pairs( GAMEMODE.Weather.New ) do
	
		if v < 0.2 and math.random(1,2) == 1 then
		
			GAMEMODE.Weather.New[k] = 0
		
		else
		
			GAMEMODE.Weather.New[k] = math.Clamp( v + math.Rand( -0.2, math.Rand( 0.2, 0.3 ) ), 0, 1 )
		
		end
	
	end
	
	GAMEMODE:SynchWeather()

end

function GM:WeatherThink()

	if not GAMEMODE.Weather.NextShift then
	
		GAMEMODE.Weather.NextShift = CurTime() + math.random( 120, 600 )
	
	elseif GAMEMODE.Weather.NextShift < CurTime() then
	
		GAMEMODE.Weather.NextShift = nil
		
		GAMEMODE:ShiftWeather()
	
	end

end

function GM:SynchWeather()

	net.Start( "WeatherSynch" )
		
		net.WriteTable( GAMEMODE.Weather.New )
		
	net.Broadcast()

end

if SERVER then return end

net.Receive( "WeatherSynch", function( len )

	GAMEMODE.Weather.New = net.ReadTable()
	GAMEMODE.Weather.Transition = true
	GAMEMODE.Weather.Inc = 0
	
	//PrintTable( GAMEMODE.Weather.New )
	
end )

function GM:ProcessWeather()

	GAMEMODE:RainThink()
	GAMEMODE:ThunderThink()
	GAMEMODE:LightningThink()
	GAMEMODE:WindThink()

	if GAMEMODE.Weather.Transition then
	
		//local scale = 1 - ( ( GAMEMODE.Weather.Transition - CurTime() ) / GAMEMODE.Weather.TransitionTime )
		
		if GAMEMODE.Weather.Inc <= CurTime() then
		
			GAMEMODE.Weather.Inc = CurTime() + 1
			local count = 0
		
			for k,v in pairs( GAMEMODE.Weather.New ) do 
			
				local diff = math.abs( GAMEMODE.Weather[k] - GAMEMODE.Weather.New[k] )
				local inc = diff / GAMEMODE.Weather.TransitionTime
				
				GAMEMODE.Weather[k] = math.Approach( GAMEMODE.Weather[k], GAMEMODE.Weather.New[k], inc )
			
				if GAMEMODE.Weather[k] == GAMEMODE.Weather.New[k] then
				
					count = count + 1
				
				end
			
			end
			
			if count == 4 then
			
				GAMEMODE.Weather.Transition = false
			
			end
			
		end
	
	end

end

RainMat = surface.GetTextureID( "effects/rain_warp" )

function GM:PaintWeather()

	if GAMEMODE.Weather.Rain > 0 and render.GetDXLevel() >= 90 then
		
		for k,v in pairs( GAMEMODE.RainDrops ) do
			
			local scale = math.Clamp( ( v.Time - CurTime() ) / v.Life, 0, 1 )
			
			surface.SetDrawColor( 200, 200, 220, 255 * scale )
			surface.SetTexture( RainMat )
			surface.DrawTexturedRect( v.X, v.Y - v.Movement * scale, v.Size, v.Size )
			
		end
	
	end

end

function GM:GetSky()

	local tr = util.TraceLine( util.GetPlayerTrace( LocalPlayer(), Vector(0,0,1) ) )
	
	if tr.HitSky then
	
		GAMEMODE.LastSkyPos = tr.HitPos
		GAMEMODE.PlayerIsIndoors = false
		
		GAMEMODE:ComputeSkyBounds()
	
		return tr.HitPos
	
	elseif GAMEMODE.LastSkyPos then
	
		GAMEMODE.PlayerIsIndoors = true
	
		return GAMEMODE.LastSkyPos
	
	else
	
		return LocalPlayer():GetPos() 
	
	end

end

GM.RainDist = 1000
GM.RainDrops = {}

function GM:ComputeSkyBounds()

	local trace = {}
	trace.start = GAMEMODE.LastSkyPos
	trace.endpos = trace.start + Vector( GAMEMODE.RainDist, 0, 0 )
	
	local tr = util.TraceLine( trace )
	
	trace = {}
	trace.start = tr.HitPos
	trace.endpos = trace.start + Vector( 0, GAMEMODE.RainDist, 0 )
	
	tr = util.TraceLine( trace )
	
	GAMEMODE.RightSkyBound = tr.HitPos
	
	trace = {}
	trace.start = GAMEMODE.LastSkyPos
	trace.endpos = trace.start + Vector( GAMEMODE.RainDist * -1, 0, 0 )
	
	tr = util.TraceLine( trace )
	
	trace = {}
	trace.start = tr.HitPos
	trace.endpos = trace.start + Vector( 0, GAMEMODE.RainDist * -1, 0 )
	
	tr = util.TraceLine( trace )
	
	GAMEMODE.LeftSkyBound = tr.HitPos

end

function GM:GetClosestSkyPos()

	local skypos = GAMEMODE:GetSky()
	local pos = LocalPlayer():GetPos()
	
	local trace = {}
	trace.start = skypos
	trace.endpos = Vector( pos.x, pos.y, skypos.z )
	
	local tr = util.TraceLine( trace )
	
	GAMEMODE.LastSkyPos = tr.HitPos
	
	GAMEMODE:ComputeSkyBounds()
	
	return tr.HitPos

end

GM.RainSound = Sound( "ambient/weather/rumble_rain_nowind.wav" )

function GM:RainThink()

	for k,v in pairs( GAMEMODE.RainDrops ) do
	
		if v.Time < CurTime() then
				
			table.remove( GAMEMODE.RainDrops, k )
					
			break
				
		end
	
	end

	if GAMEMODE.Weather.Rain > 0 and ( GAMEMODE.NextRainDrop or 0 ) < CurTime() and not GAMEMODE.PlayerIsIndoors then
	
		GAMEMODE.NextRainDrop = CurTime() + math.Rand( 1 - GAMEMODE.Weather.Rain, ( 1.2 - GAMEMODE.Weather.Rain ) * 3 )
		
		for i=1, math.random( 1, math.floor( GAMEMODE.Weather.Rain * 4 ) ) do
		
			local tbl = {}
			
			tbl.Size = math.random( 40, 80 ) + math.random( 0, GAMEMODE.Weather.Rain * 20 )
			tbl.X = math.random( 0, ScrW() - tbl.Size )
			tbl.Y = math.random( 0, ScrH() - tbl.Size )
			tbl.Movement = math.random( 20, 80 )
			tbl.Life = math.Rand( 1.0, 5.0 )
			tbl.Time = CurTime() + tbl.Life
			
			if math.random(1,5) == 1 then
			
				tbl.Movement = 10
				
			end
				
			table.insert( GAMEMODE.RainDrops, tbl )
			
		end
	
	end

	if ( GAMEMODE.NextRain or 0 ) < CurTime() then
	
		GAMEMODE.NextRain = CurTime() + 0.2
		
		local amt = math.floor( GAMEMODE.Weather.Rain * 175 * CV_Density:GetFloat() )
		
		GAMEMODE:SpawnRain( amt )
		
		if not GAMEMODE.RainNoise then
		
			GAMEMODE.RainNoise = CreateSound( LocalPlayer(), GAMEMODE.RainSound ) 
			GAMEMODE.RainNoise:PlayEx( GAMEMODE.Weather.Rain * 0.3, 100 )
			GAMEMODE.RainVolume = GAMEMODE.Weather.Rain * 0.4
		
		else
		
			if GAMEMODE.PlayerIsIndoors then
			
				GAMEMODE.RainVolume = math.Approach( ( GAMEMODE.RainVolume or 0 ), math.max( GAMEMODE.Weather.Rain * 0.05, 0.02 ), 0.01 )
			
			elseif GAMEMODE.Weather.Rain == 0 then
			
				GAMEMODE.RainVolume = math.Approach( ( GAMEMODE.RainVolume or 0 ), 0, 0.002 )
			
			else
		
				GAMEMODE.RainVolume = math.Approach( ( GAMEMODE.RainVolume or 0 ), math.max( GAMEMODE.Weather.Rain * 0.4, 0.02 ), 0.002 )
				
			end
			
			GAMEMODE.RainNoise:ChangeVolume( GAMEMODE.RainVolume, GAMEMODE.RainVolume )
	
		end
	
	end

end

function GM:SpawnRain( amt )

	if amt == 0 and not GetGlobalBool( "Radiation", false ) then return end

	local function RainCollision( particle, pos, norm )
	
		particle:SetDieTime( 0 )
		
		if math.random(1,6) == 1 then
		
			local particle = RainEmitter:Add( "effects/blood", pos )
			particle:SetVelocity( Vector(0,0,0) )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 0.25 )
			particle:SetStartAlpha( 100 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 1 )
			particle:SetEndSize( math.Rand( 3, 10 + GAMEMODE.Weather.Rain * 5 ) )
			particle:SetRoll( math.Rand( -360, 360 ) )
			particle:SetAirResistance( 0 )
			particle:SetCollide( false )
			//particle:SetColor( Color( 200, 200, 250 ) )
			
		end
		
	end
	
	local function CloudCollision( particle, pos, norm )
	
		particle:SetDieTime( 0 )
		
	end
	
	local function RadCollision( particle, pos, norm )
	
		particle:SetDieTime( math.Rand( 1.0, 3.0 ) )
		
	end
	
	local pos = GAMEMODE:GetClosestSkyPos()
	
	if not pos then return end
	
	if GetGlobalBool( "Radiation", false ) then
	
		for i=1, 10 do
	
			local vec = Vector( math.random( GAMEMODE.LeftSkyBound.x, GAMEMODE.RightSkyBound.x ), math.random( GAMEMODE.LeftSkyBound.y, GAMEMODE.RightSkyBound.y ), pos.z )
			
			local particle = RainEmitter:Add( "effects/rain_cloud", vec )			
			particle:SetVelocity( Vector( 0, 0, math.random( -1000, -800 ) ) + WindVector * math.Rand( 0, 2.0 ) )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 10 )
			particle:SetStartAlpha( math.random( 5, 10 ) )
			particle:SetEndAlpha( 5 )
			particle:SetStartSize( math.random( 150, 250 ) )
			particle:SetEndSize( 250 )
			particle:SetAirResistance( 0 )
			particle:SetCollide( true )
			particle:SetBounce( 0 )
			particle:SetColor( Color( 100, 250, 50 ) )
			particle:SetCollideCallback( CloudCollision )
			
			if i < 3 then
			
				local particle = RainEmitter:Add( "effects/rain_cloud", vec )			
				particle:SetVelocity( Vector( 0, 0, math.random( -1000, -800 ) ) + WindVector * math.Rand( 0, 2.0 ) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 10 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.random( 1, 3 ) )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.random( -180, 180 ) )
				particle:SetColor( 100, 200, 0 )
				particle:SetGravity( Vector( 0, 0, -300 ) + WindVector * ( math.sin( CurTime() * 0.01 ) * 20 ) )
				particle:SetCollide( true )
				particle:SetCollideCallback( RadCollision )
				particle:SetBounce( math.Rand( 0, 0.1 ) )
			
			end
		
		end
	
	end
	
	if amt == 0 then return end
	
	for i=1, amt do
	
		local vec = Vector( math.random( GAMEMODE.LeftSkyBound.x, GAMEMODE.RightSkyBound.x ), math.random( GAMEMODE.LeftSkyBound.y, GAMEMODE.RightSkyBound.y ), pos.z )
		local len = math.random( 40, 80 )
		
		local particle = RainEmitter:Add( "particle/Water/WaterDrop_001a", vec )			
		particle:SetVelocity( Vector( 0, 0, math.random( -1000, -800 ) ) )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( 10 )
		particle:SetStartAlpha( math.random( 5, 20 ) )
		particle:SetEndAlpha( 20 )
		particle:SetStartSize( 2.0 )
		particle:SetEndSize( math.Rand( 3.0, 4.0 + GAMEMODE.Weather.Rain ) )
		particle:SetStartLength( len )
		particle:SetEndLength( len + 5 )
		particle:SetAirResistance( 0 )
		particle:SetCollide( true )
		particle:SetBounce( 0 )
		//particle:SetColor( Color( 200, 200, 250 ) )
		particle:SetCollideCallback( RainCollision )
		
	end
	
	amt = math.floor( amt * 0.05 ) + 1
	
	for i=1, amt do
	
		local vec = Vector( math.random( GAMEMODE.LeftSkyBound.x, GAMEMODE.RightSkyBound.x ), math.random( GAMEMODE.LeftSkyBound.y, GAMEMODE.RightSkyBound.y ), pos.z )
		
		local particle = RainEmitter:Add( "effects/rain_cloud", vec )			
		particle:SetVelocity( Vector( 0, 0, math.random( -1000, -800 ) ) + WindVector * math.Rand( 0, 2.0 ) )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( 10 )
		particle:SetStartAlpha( 3 + math.Rand( 0, GAMEMODE.Weather.Rain * 5 ) )
		particle:SetEndAlpha( 5 )
		particle:SetStartSize( math.random( 100, 200 ) )
		particle:SetEndSize( 200 )
		particle:SetAirResistance( 0 )
		particle:SetCollide( true )
		particle:SetBounce( 0 )
		particle:SetColor( Color( 200, 200, 250 ) )
		particle:SetCollideCallback( CloudCollision )
	
	end

end

function GM:LightningThink()

	if GAMEMODE.Weather.Lightning == 0 then

		if GAMEMODE.NextLightning and GAMEMODE.NextLightning > CurTime() then
		
			GAMEMODE:LightUpSky( false )
			GAMEMODE.NextLightning = 0
		
		end
	
		return 
	
	end

	local skyname = GetGlobalString( "SkyName" )
	
	if skyname and not GAMEMODE.SkyMat then
                                
		GAMEMODE.SkyMat = {}
        GAMEMODE.SkyMat[1] = Material("skybox/" .. skyname .. "up")
        GAMEMODE.SkyMat[2] = Material("skybox/" .. skyname .. "dn")
        GAMEMODE.SkyMat[3] = Material("skybox/" .. skyname .. "lf")
        GAMEMODE.SkyMat[4] = Material("skybox/" .. skyname .. "rt")
        GAMEMODE.SkyMat[5] = Material("skybox/" .. skyname .. "bk")
        GAMEMODE.SkyMat[6] = Material("skybox/" .. skyname .. "ft")
		
		GAMEMODE.OldSky = {}
		GAMEMODE.LitUp = {}
		
		skyname = "sky_day01_01"
		
		GAMEMODE.NewSky = {}
		GAMEMODE.NewSky[1] = Material("skybox/" .. skyname .. "up")
        GAMEMODE.NewSky[2] = Material("skybox/" .. skyname .. "dn")
        GAMEMODE.NewSky[3] = Material("skybox/" .. skyname .. "lf")
        GAMEMODE.NewSky[4] = Material("skybox/" .. skyname .. "rt")
        GAMEMODE.NewSky[5] = Material("skybox/" .. skyname .. "bk")
        GAMEMODE.NewSky[6] = Material("skybox/" .. skyname .. "ft")
                                        
	end
	
	if ( GAMEMODE.NextLightning or 0 ) < CurTime() then
	
		if not GAMEMODE.FlashInterval then
		
			GAMEMODE.FlashInterval = CurTime() + math.Rand( 1.0, 2.5 )
			GAMEMODE.FlashTime = CurTime() + math.Rand( 0, 0.2 )
			GAMEMODE.FlashToggle = CurTime() + math.Rand( 0, 0.8 )
			
			sound.Play( table.Random( GAMEMODE.Thunder ), LocalPlayer():GetShootPos(), 150, math.random( 80, 110 ), 0.2 )
		
		end
		
		GAMEMODE:LightUpSky( GAMEMODE.FlashTime >= CurTime() )
		
		if GAMEMODE.FlashToggle < CurTime() then
		
			GAMEMODE.FlashTime = CurTime() + math.Rand( 0, 0.2 )
			GAMEMODE.FlashToggle = CurTime() + math.Rand( 0, 0.8 )
		
		end
		
		if GAMEMODE.FlashInterval < CurTime() then 
		
			GAMEMODE.FlashInterval = nil
			GAMEMODE.NextLightning = CurTime() + math.random( 4, 8 + ( 1.0 - GAMEMODE.Weather.Lightning ) * 50 ) 
			GAMEMODE:LightUpSky( false )
		
		end
	
	end

end

function GM:LightUpSky( bool )

	if bool then
	
		for k,v in pairs( GAMEMODE.SkyMat ) do
	
			if not GAMEMODE.LitUp[k] then
	
				GAMEMODE.OldSky[k] = v:GetTexture( "$basetexture" )
				GAMEMODE.LitUp[k] = true
				
				v:SetTexture( "$basetexture", GAMEMODE.NewSky[k]:GetTexture( "$basetexture" ) )
			
			end
		
		end
	
	else
	
		for k,v in pairs( GAMEMODE.SkyMat ) do
	
			if GAMEMODE.LitUp and GAMEMODE.LitUp[k] then
	
				GAMEMODE.LitUp[k] = false
				
				v:SetTexture( "$basetexture", GAMEMODE.OldSky[k] )
				
			end
		
		end
	
	end

end

function GM:WindThink()

	if GAMEMODE.Weather.Wind == 0 then return end
	
	if ( GAMEMODE.NextWind or 0 ) < CurTime() then 
		
		local vol = math.max( GAMEMODE.Weather.Wind, 0.2 )
		local snd = table.Random( GAMEMODE.Wind )
		
		if GAMEMODE.PlayerIsIndoors then
		
			vol = 0.1
		
		end
		
		sound.Play( snd, LocalPlayer():GetShootPos(), 150, math.random( 80, 110 ), vol )
		
		GAMEMODE.NextWind = CurTime() + math.random( 1, SoundDuration( snd ) + ( 1.0 - GAMEMODE.Weather.Wind ) * 30 + math.Rand( -2, 2 ) )
	
	end

end

function GM:ThunderThink()

	if GAMEMODE.Weather.Thunder == 0 then return end
	
	if ( GAMEMODE.NextThunder or 0 ) < CurTime() then
	
		GAMEMODE.NextThunder = CurTime() + math.random( 4, 8 + ( 1.0 - GAMEMODE.Weather.Thunder ) * 50 ) 
		
		local vol = math.max( GAMEMODE.Weather.Thunder, 0.2 )
		
		if GAMEMODE.PlayerIsIndoors then
		
			vol = 0.1
		
		end
		
		sound.Play( table.Random( GAMEMODE.Thunder ), LocalPlayer():GetShootPos(), 150, math.random( 80, 110 ), vol )
	
	end

end