
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
			
			if math.random(1,5) == 1 then
			
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
	
	PrintTable( GAMEMODE.Weather.New )
	
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

RainMat = Material( "models/shadertest/shader3" )

function GM:PaintWeather()

	if GAMEMODE.Weather.Rain > 0 then
	
		if GAMEMODE.PlayerIsIndoors then
		
			GAMEMODE.RainRefract = math.Approach( ( GAMEMODE.RainRefract or 0 ), 0, 0.0002 )
		
		else
	
			GAMEMODE.RainRefract = math.Approach( ( GAMEMODE.RainRefract or 0 ), 0.01 * GAMEMODE.Weather.Rain, 0.0001 )
			
		end
		
		if GAMEMODE.RainRefract == 0 then return end
		
		render.UpdateScreenEffectTexture()

		RainMat:SetFloat( "$envmap", 0 )
		RainMat:SetFloat( "$envmaptint", 0 )
		RainMat:SetFloat( "$refractamount", GAMEMODE.RainRefract )
		RainMat:SetInt( "$ignorez", 1 )
		
		render.SetMaterial( RainMat )
		render.DrawScreenQuad()
	
	end

end

function GM:GetSky()

	local tr = util.TraceLine( util.GetPlayerTrace( LocalPlayer(), Vector(0,0,1) ) )
	
	if tr.HitSky then
	
		GAMEMODE.LastSkyPos = tr.HitPos
		GAMEMODE.PlayerIsIndoors = false
	
		return tr.HitPos
	
	elseif GAMEMODE.LastSkyPos then
	
		GAMEMODE.PlayerIsIndoors = true
	
		return GAMEMODE.LastSkyPos
	
	else
	
		return LocalPlayer():GetPos() 
	
	end

end

function GM:GetClosestSkyPos()

	local skypos = GAMEMODE:GetSky()
	local pos = LocalPlayer():GetPos()
	
	if Vector( pos.x, pos.y, 0 ):Distance( Vector( skypos.x, skypos.y, 0 ) ) < 80 then return skypos end
	
	local trace = {}
	trace.start = skypos
	trace.endpos = Vector( pos.x, pos.y, skypos.z )
	trace.filter = LocalPlayer()
	
	local tr = util.TraceLine( trace )
	
	if tr.Hit then
	
		trace.start = Vector( pos.x, pos.y, skypos.z )
		trace.endpos = skypos
		trace.filter = LocalPlayer()
		
		tr = util.TraceLine( trace )
	
	end
	
	GAMEMODE.LastSkyPos = tr.HitPos
	
	return tr.HitPos

end

GM.RainSound = Sound( "ambient/weather/rumble_rain_nowind.wav" )

function GM:RainThink()

	if ( GAMEMODE.NextRain or 0 ) < CurTime() then
	
		GAMEMODE.NextRain = CurTime() + 0.2
		
		local amt = math.floor( GAMEMODE.Weather.Rain * 150 * CV_Density:GetFloat() )
		
		GAMEMODE:SpawnRain( amt )
		
		if not GAMEMODE.RainNoise then
		
			GAMEMODE.RainNoise = CreateSound( LocalPlayer(), GAMEMODE.RainSound ) 
			GAMEMODE.RainNoise:PlayEx( GAMEMODE.Weather.Rain * 0.3, 100 )
			GAMEMODE.RainVolume = GAMEMODE.Weather.Rain * 0.3
		
		else
		
			if GAMEMODE.PlayerIsIndoors then
			
				GAMEMODE.RainVolume = math.Approach( ( GAMEMODE.RainVolume or 0 ), math.max( GAMEMODE.Weather.Rain * 0.05, 0.02 ), 0.01 )
			
			elseif GAMEMODE.Weather.Rain == 0 then
			
				GAMEMODE.RainVolume = math.Approach( ( GAMEMODE.RainVolume or 0 ), 0, 0.002 )
			
			else
		
				GAMEMODE.RainVolume = math.Approach( ( GAMEMODE.RainVolume or 0 ), math.max( GAMEMODE.Weather.Rain * 0.3, 0.02 ), 0.002 )
				
			end
			
			GAMEMODE.RainNoise:ChangeVolume( GAMEMODE.RainVolume )
	
		end
	
	end

end

function GM:SpawnRain( amt )

	if amt == 0 then return end

	local function RainCollision( particle, pos, norm )
	
		particle:SetDieTime( 0 )
		
		if math.random(1,6) == 1 then
		
			local particle = RainEmitter:Add( "nuke/gore" .. math.random(1,2), pos )
			particle:SetVelocity( Vector(0,0,0) )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 0.3 )
			particle:SetStartAlpha( 100 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 1 )
			particle:SetEndSize( math.Rand( 5, 10 ) )
			particle:SetAirResistance( 0 )
			particle:SetCollide( false )
			//particle:SetColor( Color( 200, 200, 250 ) )
			
		end
		
	end
	
	for i=1, amt do
	
		local vec = VectorRand()
		vec.z = -0.1
		
		local pos = GAMEMODE:GetClosestSkyPos() + vec * 1200
		local len = math.random( 40, 80 )
		
		local particle = RainEmitter:Add( "particle/Water/WaterDrop_001a", pos )			
		particle:SetVelocity( Vector( 0, 0, math.random( -800, -700 ) ) + WindVector * ( 1 + math.sin( CurTime() * 0.1 ) ) )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( 10 )
		particle:SetStartAlpha( 50 )
		particle:SetEndAlpha( 50 )
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

end

function GM:LightningThink()

	if GAMEMODE.Weather.Lightning == 0 then return end

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