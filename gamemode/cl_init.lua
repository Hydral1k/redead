
include( 'player_class/player_base.lua' )
include( 'player_class/player_zombie.lua' )
include( 'animations.lua' )
include( 'items.lua' )
include( 'shared.lua' )
include( 'enums.lua' )
include( 'moddable.lua' )
include( 'tables.lua' )
include( 'weather.lua' )
include( 'cl_notice.lua' )
include( 'cl_hudstains.lua' )
include( 'cl_targetid.lua' )
include( 'cl_spawnmenu.lua' )
include( 'cl_scoreboard.lua' )
include( 'cl_postprocess.lua' )
include( 'cl_inventory.lua' )
include( 'vgui/vgui_panelbase.lua' )
include( 'vgui/vgui_dialogue.lua' )
include( 'vgui/vgui_itemdisplay.lua' )
include( 'vgui/vgui_shopmenu.lua' )
include( 'vgui/vgui_classpicker.lua' )
include( 'vgui/vgui_zombieclasses.lua' )
include( 'vgui/vgui_helpmenu.lua' )
include( 'vgui/vgui_endgame.lua' )
include( 'vgui/vgui_playerdisplay.lua' )
include( 'vgui/vgui_playerpanel.lua' )
include( 'vgui/vgui_itempanel.lua' )
include( 'vgui/vgui_panelsheet.lua' )
include( 'vgui/vgui_goodmodelpanel.lua' )
include( 'vgui/vgui_categorybutton.lua' )
include( 'vgui/vgui_sidebutton.lua' )
include( 'vgui/vgui_scroller.lua' )

CV_RagdollVision = CreateClientConVar( "cl_redead_ragdoll_vision", "1", true, false )
CV_Density = CreateClientConVar( "cl_redead_rain_density", "1.0", true, false )

function GM:Initialize()
	
	WindVector = Vector( math.random(-10,10), math.random(-10,10), 0 )
	StaticPos = Vector(0,0,0)
	ViewWobble = 0
	ShopMenu = false
	HeadlessTbl = {}
	GibbedTbl = {}
	BurnTbl = {}
	PlayerStats = {}
	Drunkness = 0
	DeathScreenTime = 0
	DeathScreenScale = 0
	HeartBeat = 0
	JumpTimer = 0
	
	surface.CreateFont ( "DeathFont", { size = 34, weight = 200, antialias = true, additive = true, font = "Graffiare" } )
	surface.CreateFont ( "AmmoFont", { size = 28, weight = 200, antialias = true, additive = true, font = "Graffiare" } )
	surface.CreateFont ( "CashFont", { size = 22, weight = 200, antialias = true, additive = true, font = "Graffiare" } )
	surface.CreateFont ( "InventoryFont", { size = 20, weight = 150, antialias = true, additive = true, font = "Graffiare" } )
	surface.CreateFont ( "HudMarker", { size = 20, weight = 200,antialias = true, additive = true, font = "Graffiare" } )
	surface.CreateFont ( "ZombieHud", { size = 24, weight = 500, antialias = true, additive = true, font = "Typenoksidi" } )
	surface.CreateFont ( "ShopBig", { size = 22, weight = 500,  antialias = true, additive = true, font = "Typenoksidi" } )
	surface.CreateFont ( "ShopSmall", { size = 16, weight = 400, antialias = true, additive = true, font = "Typenoksidi" } )
	surface.CreateFont ( "EndGameBig", { size = 24, weight = 300,antialias = true, additive = true, font = "Typenoksidi" } )
	surface.CreateFont ( "EndGame", { size = 14, weight = 400,  antialias = true, additive = true, font = "Tahoma" } )
	surface.CreateFont ( "AmmoFontSmall", { size = 12, weight = 300, antialias = true, additive = true, font = "Verdana" } )
	surface.CreateFont ( "TargetIDFont", { size = 12, weight = 200, antialias = true, additive = true, font = "Verdana" } )

	//matRadar = Material( "radbox/radar" )
	//matArm = Material( "radbox/radar_arm" )
	//matArrow = Material( "radbox/radar_arrow" )
	//matNoise = Material( "radbox/nvg_noise" )
	
	matHealth = Material( "radbox/img_health" )
	matStamina = Material( "radbox/img_stamina" )
	matBlood = Material( "radbox/img_blood" )
	matRadiation = Material( "radbox/img_radiation" )
	matInfection = Material( "radbox/img_infect" )
	
	GAMEMODE:WeatherInit()
	
end

function GM:GetHelpHTML()

	local str = ""
	
	for k,v in pairs( GAMEMODE.HelpText ) do
	
		str = str .. v
	
	end

	return str

end

// Help menu - comment this out later?
function GM:ShowHelp()

	if IsValid( self.HelpFrame ) then return end
	
	self.HelpFrame = vgui.Create( "HelpMenu" )
	self.HelpFrame:SetSize( 415, 370 )
	self.HelpFrame:Center()
	self.HelpFrame:MakePopup()
	self.HelpFrame:SetKeyboardInputEnabled( false )
	
end

function GM:ShowClasses()

	--[[local classmenu = vgui.Create( "ClassPicker" )
	classmenu:SetSize( 415, 475 )
	classmenu:Center()
	classmenu:MakePopup()]]
	
	GAMEMODE:ShowHelp()

end

function GM:ShowZombieClasses()

	if IsValid( self.Classes ) then return end
	
	self.Classes = vgui.Create( "ZombieClassPicker" )
	self.Classes:SetSize( 415, 475 )
	self.Classes:Center()
	self.Classes:MakePopup()

end

function GM:HUDShouldDraw( name )

	if GAMEMODE.ScoreboardVisible then return false end
	
	for k, v in pairs{ "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudSuitPower", "CHudPoisonDamageIndicator", "CHudCrosshair" } do
	
		if name == v then return false end 
		
  	end 
	
	if name == "CHudDamageIndicator" and not LocalPlayer():Alive() then
	
		return false
		
	end
	
	return true
	
end

function GM:Think()

	GAMEMODE:ProcessWeather()
	GAMEMODE:FadeRagdolls()
	GAMEMODE:GoreRagdolls()
	GAMEMODE:HUDTraces()
	//GAMEMODE:SpawnRagdolls()
	
	if GetGlobalBool( "GameOver", false ) and not EndScreenShown then
	
		EndScreenShown = true
		
		local endscreen = vgui.Create( "EndGame" )
		endscreen:SetPos(0,0)
	
	end

	if IsValid( LocalPlayer() ) and LocalPlayer():Alive() and not StartMenuShown then
	
		StartMenuShown = true
		GAMEMODE:ShowClasses()
		
		//player_manager.SetPlayerClass( LocalPlayer(), "player_base" )
	
	end

	if not LocalPlayer():Alive() and GAMEMODE:ElementsVisible() then
	
		GAMEMODE:ClearElements()
		
		gui.EnableScreenClicker( false )
		
	end
	
	if LocalPlayer():Team() != TEAM_ARMY then return end

	if LocalPlayer():Alive() and HeartBeat < CurTime() and ( LocalPlayer():GetNWBool( "Bleeding", false ) or LocalPlayer():Health() < 50 ) then
	
		local scale = LocalPlayer():Health() / 100
		HeartBeat = CurTime() + 0.5 + scale * 1.5
		
		LocalPlayer():EmitSound( Sound( "nuke/heartbeat.wav" ), 100, 150 - scale * 50 )
		
	end
	
	--[[if Inv_HasItem( "models/gibs/shield_scanner_gib1.mdl" ) then
	
		MaxDist = 2200
		ArmSpeed = 90
	
	else
	
		MaxDist = 1500
		ArmSpeed = 70
	
	end

	if ( NextRadarThink or 0 ) < CurTime() then
	
		NextRadarThink = CurTime() + 1.5
	
		RadarEntTable = team.GetPlayers( TEAM_ZOMBIES ) 
		RadarEntTable = table.Add( RadarEntTable, team.GetPlayers( TEAM_ARMY ) )
		RadarEntTable = table.Add( RadarEntTable, ents.FindByClass( "npc_*" ) )
		RadarEntTable = table.Add( RadarEntTable, ents.FindByClass( "sent_lootbag" ) )
		RadarEntTable = table.Add( RadarEntTable, ents.FindByClass( "point_stash" ) )
		RadarEntTable = table.Add( RadarEntTable, ents.FindByClass( "sent_supplycrate" ) )
		RadarEntTable = table.Add( RadarEntTable, ents.FindByClass( "sent_antidote" ) )
		
	end
	
	local aimvec = LocalPlayer():GetAimVector()
		
	for k,v in pairs( RadarEntTable ) do
	
		if not IsValid( v ) then break end
		
		local dirp = ( LocalPlayer():GetPos() - v:GetPos() ):GetNormal()
		local aimvec = LocalPlayer():GetAimVector()
		aimvec.z = dirp.z
		
		local dir = ( aimvec:Angle() + Angle( 0, ArmAngle + 90, 0 ) ):Forward()
        local dot = dir:Dot( dirp )
        local diff = ( v:GetPos() - LocalPlayer():GetPos() )
		
		local close = math.sqrt( diff.x * diff.x + diff.y * diff.y ) < MaxDist * FadeDist

		if ( !v:IsPlayer() or ( v:Alive() and ( v != LocalPlayer() and ( v:Team() == LocalPlayer():Team() or  close ) ) ) ) and !IsOnRadar( v ) and ( dot > 0.99 or close ) then
			
			local pos = v:GetPos()
			local color = Color( 0, 255, 0 )
			
			if not v:IsPlayer() then
			
				color = Color( 80, 150, 255 )
				
				if v:GetClass() == "sent_antidote" or v:GetClass() == "sent_supplycrate" then
				
					color = Color( 255, 255, 255 )
				
				elseif v:IsNPC() then
				
					if v:GetClass() == "npc_scientist" then
				
						color = Color( 200, 200, 0 )
						
					else
						
						color = Color( 255, 80, 80 )
					
					end
				
				end
				
			elseif v:IsPlayer() and v:Team() != LocalPlayer():Team() then
				
				color = Color( 255, 80, 80 )
				
			end
				
			local dietime = CurTime() + BlipTime
			
			if close then
				
				dietime = -1
				
			end
			
			table.insert( PosTable, { Ent = v, Pos = pos, DieTime = dietime, Color = color } )
			
		end
		
	end]]
	
end

function GM:FadeRagdolls()

	for k,v in pairs( ents.FindByClass( "class C_ClientRagdoll" ) ) do
	
		if v.Time and v.Time < CurTime() then
		
			//v:SetColor( Color( 255, 255, 255, v.Alpha ) )
			//v.Alpha = math.Approach( v.Alpha, 0, -2 )
			
			//if v.Alpha <= 0 then
				//v:Remove()
			//end
			
			v:Remove()
		
		elseif not v.Time then
		
			v.Time = CurTime() + 12
			//v.Alpha = 255
		
		end
		
	end
	
end

function GM:GetNearestEnt( pos, dist, tbl )

	local closest 
	local best = 9000

	for k,v in pairs( tbl ) do
	
		local newdist = v:GetPos():Distance( pos )
	
		if newdist < dist and newdist < best then
		
			closest = v
		
		end
	
	end
	
	return closest

end

GM.GoreSheets = { "models/charple/charple1_sheet",
"models/charple/charple3_sheet",
"models/charple/charple4_sheet" }

function GM:GoreRagdolls()

	local tbl = ents.FindByClass( "class C_HL2MPRagdoll" )
	tbl = table.Add( tbl, ents.FindByClass( "class C_ClientRagdoll" ) )

	for k,v in pairs( tbl ) do
	
		if not v.Gore and table.HasValue( GAMEMODE.Corpses, string.lower( v:GetModel() ) ) then
		
			v.Gore = true
			v:SetMaterial( "models/flesh" )
			
			local phys = v:GetPhysicsObject()
			
			if IsValid( phys ) then
			
				phys:ApplyForceCenter( VectorRand() * 5000 )
			
			end
		
		elseif not LocalPlayer():Alive() and IsValid( LocalPlayer():GetRagdollEntity() ) and LocalPlayer():GetRagdollEntity() == v and not v.Slowed and not table.HasValue( GAMEMODE.Corpses, string.lower( v:GetModel() ) ) then
		
			v.Slowed = true
			
			local phys = v:GetPhysicsObject()
			
			if IsValid( phys ) then
			
				local count = LocalPlayer():GetRagdollEntity():GetPhysicsObjectCount()
				
				for i=0, count do
				
					local limb = v:GetPhysicsObjectNum( i )
					
					if IsValid( limb ) then
					
						limb:SetDamping( 5, 0 )
						limb:ApplyForceCenter( VectorRand() * 50 )
						
					end
				
				end
				
				phys:Wake()
			
			end
		
		end
	
		if not v.Randomized then
		
			v.Randomized = true
			
			if math.random(1,2) == 1 then 
			
				local phys = v:GetPhysicsObject()
				
				if IsValid( phys ) then
			
					for i=1, math.random(2,6) do
			
						local count = v:GetPhysicsObjectCount()
						local limb = v:GetPhysicsObjectNum( math.random( 0, count ) )
					
						if IsValid( limb ) then
					
							limb:SetDamping( math.Rand( 0, 2 ), math.Rand( 0, 5 ) )
							limb:ApplyForceCenter( VectorRand() * 75 )
				
						end
				
						phys:Wake()
			
					end
				
				end
			
			end
		
		end
		
	end
	
	for c,d in pairs( HeadlessTbl ) do
	
		local ent = GAMEMODE:GetNearestEnt( d.Pos, 50, tbl )
		
		if IsValid( ent ) and not ent.IsHeadless then
			
			ent:ManipulateBoneScale( 6, Vector( 0.01, 0.01, 0.01 ) ) 
			ent:ManipulateBoneScale( 6, Vector( 0.001, 0.001, 0.001 ) ) 
			
			ent.IsHeadless = true
			
			table.remove( HeadlessTbl, c )
			
			break
			
		elseif d.Time < CurTime() then
			
			table.remove( HeadlessTbl, c )
			
			break
			
		end
		
	end
		
	for c,d in pairs( BurnTbl ) do
	
		local ent = GAMEMODE:GetNearestEnt( d.Pos, 50, tbl )
		
		if IsValid( ent ) and not ent.IsBurnt then
			
			ent:SetMaterial( table.Random( GAMEMODE.GoreSheets ) )
			ent.IsBurnt = true
			
			table.remove( BurnTbl, c )
			
			break
			
		elseif d.Time < CurTime() then
			
			table.remove( BurnTbl, c )
			
			break
			
		end
		
	end
	
end

function GM:SpawnRagdolls()

	local tbl = ents.FindByClass( "npc_*" )
	
	for c,d in pairs( RagdollTbl ) do
	
		local ent = GAMEMODE:GetNearestEnt( d.Pos, 30, tbl )
		
		if IsValid( ent ) and not ent.Ragdolled then
			
			ent:BecomeRagdollOnClient()
			ent.Ragdolled = true
			
			table.remove( RagdollTbl, c )
			
			break
			
		elseif d.Time < CurTime() then
			
			table.remove( RagdollTbl, c )
			
			break
		
		end
		
	end
	
end

function DrawBar( x, y, w, h, value, maxvalue, icon, colorlight, colordark, hp )

	draw.RoundedBox( 4, x - 1, y, h + 1, h, Color( 0, 0, 0, 180 ) )
	
	surface.SetDrawColor( colorlight.r, colorlight.g, colorlight.b, 180 ) 
	surface.SetMaterial( icon ) 
	surface.DrawTexturedRect( x, y + 1, h - 1, h - 2 ) 
	
	x = x + h + 4
	
	local w = 5 + maxvalue * 2
	
	draw.RoundedBox( 4, x, y, w, h, Color( 0, 0, 0, 180 ) )
	
	for i=1, value do
	
		local grn = colorlight.g
		
		if i <= 50 then
		
			grn = grn + 50
	
		end
	
		draw.RoundedBox( 0, 1 + x + i * 2, y + 3, 1, h - 6, colordark )
		draw.RoundedBox( 0, 1 + x + i * 2, y + 3 + ( h * 0.2 ), 1, h - 6 - ( h * 0.4 ), Color( colorlight.r, grn, colorlight.b ) )
		
		--[[if hp then
		
			if i % 6 == 0 or ( i + 1 ) % 6 == 0 or ( i + 2 ) % 6 == 0 then
				
				draw.RoundedBox( 0, 1 + x + i * 2, y + 3, 1, ( h * ( math.sin( CurTime() * 3 + i ) * 0.2 + 0.5 ) ) - 3, Color( colorlight.r, grn, colorlight.b ) )
				
			end
		
			draw.RoundedBox( 0, 1 + x + i * 2, y + 3, 1, ( h * 0.4 ) - 3, Color( colorlight.r, grn, colorlight.b ) )
		
		else
		
			draw.RoundedBox( 0, 1 + x + i * 2, y + 3, 1, ( h * ( math.sin( ( CurTime() * 0.1 + i * 0.5 ) ) * ( math.sin( CurTime() * 2 ) * 0.15 ) + 0.5 ) ) - 3, Color( colorlight.r, grn, colorlight.b ) )
			
		end]]
	
	end

end

function DrawIcon( x, y, w, h, icon, color )

	draw.RoundedBox( 4, x - 1, y, h + 1, h, Color( 0, 0, 0, 180 ) )
	
	surface.SetDrawColor( color.r, color.g, color.b, 180 ) 
	surface.SetMaterial( icon ) 
	surface.DrawTexturedRect( x, y + 1, h - 1, h - 2 ) 

end

function DrawAmmo( x, y, w, h, text, label )

	if not IsValid( LocalPlayer():GetActiveWeapon() ) then return end

	draw.RoundedBox( 4, x, y, w, h, Color( 0, 0, 0, 180 ) )
	
	draw.SimpleText( text, "AmmoFont", x + 5, y + ( h * 0.5 ) - 5, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	draw.SimpleText( label, "AmmoFontSmall", x + 5, y + 5, Color( 255, 255, 150 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	
end

function DrawCash( x, y, w, h, text )

	draw.RoundedBox( 4, x, y, w, h, Color( 0, 0, 0, 180 ) )
	draw.SimpleText( text, "CashFont", x + w * 0.5, y + h * 0.5 + 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

function GM:GetAfflictions()

	local tbl = {}
	local cols = { Color( 40, 200, 40 ), Color( 80, 150, 40 ), Color( 150, 150, 0 ), Color( 200, 100, 40 ), Color( 255, 40, 40 ) }

	if LocalPlayer():GetNWBool( "Infected", false ) then
	
		table.insert( tbl, { Icon = matInfection, Color = Color( 40, 200, 40 ) } )
	
	end
	
	if LocalPlayer():GetNWBool( "Bleeding", false ) then
	
		table.insert( tbl, { Icon = matBlood, Color = Color( 225, 40, 40 ) } )
		
	end
	
	if LocalPlayer():GetNWInt( "Radiation", 0 ) > 0 then

		table.insert( tbl, { Icon = matRadiation, Color = cols[ LocalPlayer():GetNWInt( "Radiation", 1 ) ] } )
		
	end
	
	return tbl

end

function GM:GetHealthColor()
	
	local hp = math.Clamp( LocalPlayer():Health(), 0, 500 )
	
	if hp > 150 then
	
		return Color( 0, 255, 255 )
	
	end
	
	local scale = hp / 150
		
	return Color( ( 1 - scale ) * 255, scale * 255, scale * 255 )

end

function GM:DrawMarkers()

	local tbl = ents.FindByClass( "sent_heliflare" )
	tbl = table.Add( tbl, ents.FindByClass( "sent_antidote" ) )

	for k,v in pairs( tbl ) do
	
		local sc = v:GetPos():ToScreen()
		
		if sc.visible then
		
			local text = "antidote"
			local offset = ( v:GetPos() + Vector(0,0,80) ):ToScreen()
			local dist = v:GetPos():Distance( LocalPlayer():GetPos() )
			local maxdist = 1600
		
			if v:GetClass() == "sent_heliflare" then
			
				text = "evac  zone"
				offset = ( v:GetPos() + Vector(0,0,40) ):ToScreen()
				maxdist = 600
			
			end
			
			local alpha = math.Clamp( dist - maxdist, 0, 200 ) / 200
			
			sc.y = sc.y + ( offset.y - sc.y )
		
			draw.SimpleText( text, "HudMarker", sc.x, sc.y, Color( 255, 255, 255, alpha * 255 ), TEXT_ALIGN_CENTER )
			
		end
	
	end

end

function GM:HUDPaint()

	if GetGlobalBool( "GameOver", false ) then return end
	
	if LocalPlayer():IsFrozen() then return end
	
	if LocalPlayer():Team() == TEAM_ZOMBIES then
	
		GAMEMODE:PaintWeather()
	
		if not LocalPlayer():Alive() then
		
			DeathScreenScale = math.Approach( DeathScreenScale, 1, FrameTime() * 0.3 ) 
			
			draw.RoundedBox( 0, 0, 0, ScrW(), ScrH() * ( 0.15 * DeathScreenScale ), Color( 0, 0, 0, 180 ) )
			draw.RoundedBox( 0, 0, ScrH() - ( ScrH() * ( 0.15 * DeathScreenScale ) ), ScrW(), ScrH() * ( 0.15 * DeathScreenScale ), Color( 0, 0, 0, 180 ) )
			
			if DeathScreenScale == 1 then
			
				local dtime = math.Round( DeathScreenTime - CurTime() )
				
				if dtime > 0 then
				
					draw.SimpleText( "YOU WILL RESPAWN IN "..dtime.." SECONDS", "DeathFont", ScrW() * 0.5, ScrH() * 0.1, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					
				else
				
					draw.SimpleText( "PRESS ANY KEY TO RESPAWN", "DeathFont", ScrW() * 0.5, ScrH() * 0.1, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				
				end
				
				draw.SimpleText( DeathScreenText or "POOP", "DeathFont", ScrW() * 0.5, ScrH() * 0.9, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			end
	
		else
		
			local hp = math.Clamp( LocalPlayer():Health(), 0, 500 )
			local x, y = 40, ScrH() - 60
			
			surface.SetFont( "ZombieHud" )
			local w, h = surface.GetTextSize( "Health: " .. hp )
		
			draw.RoundedBox( 4, 30, ScrH() - 70, w + 20, h + 20, Color( 0, 0, 0, 180 ) )
		
			draw.SimpleText( "Health: " .. hp, "ZombieHud", x+1, y+1, Color(40,40,40), TEXT_ALIGN_LEFT )
			draw.SimpleText( "Health: " .. hp, "ZombieHud", x+1, y-1, Color(40,40,40), TEXT_ALIGN_LEFT )
			draw.SimpleText( "Health: " .. hp, "ZombieHud", x-1, y-1, Color(40,40,40), TEXT_ALIGN_LEFT )
			draw.SimpleText( "Health: " .. hp, "ZombieHud", x-1, y+1, Color(40,40,40), TEXT_ALIGN_LEFT )
			draw.SimpleText( "Health: " .. hp, "ZombieHud", x, y, GAMEMODE:GetHealthColor(), TEXT_ALIGN_LEFT )
			
			if not LocalPlayer():GetNWBool( "Lord", false ) then return end
			
			local xpos, ypos = x + w + 20, ScrH() - 70
			local w = 200
			local scale = math.floor( w * math.Clamp( LocalPlayer():GetNWInt( "ZedDamage", 0 ) / GAMEMODE.RedemptionDamage, 0.01, 1.00 ) )
			local pos = 0
			
			draw.RoundedBox( 4, xpos, ypos, w + 20, h + 20, Color( 0, 0, 0, 180 ) )
			
			if scale == 200 then
			
				draw.RoundedBox( 0, xpos + 10, ScrH() - 60, scale, h, Color( 200, 0, 0, 200 ) )
			
			else
			
				draw.RoundedBox( 0, xpos + 10, ScrH() - 60, scale, h, Color( 100, 0, 0, 200 ) )
				
			end
			
			while pos < scale do
			
				local width = math.min( math.random( 10, 50 ), math.max( scale - pos, 1 ) ) 
			
				local tbl = {} 
				tbl.texture = surface.GetTextureID( "nuke/redead/noise0" .. math.random(1,3) )
				tbl.x = xpos + pos + 10
				tbl.y = ScrH() - 60 
				tbl.w = width
				tbl.h = h
				
				if scale == 200 then
				
					tbl.color = Color( 250, 125 + math.sin( CurTime() * 5 ) * 125, 125 + math.sin( CurTime() * 5 ) * 125, 250 ) 
				
				else
				
					tbl.color = Color( 250, 0, 0, 200 ) 
				
				end
				
				draw.TexturedQuad( tbl )
				
				pos = pos + width
			
			end
		
		end
		
		return
	
	end
	
	GAMEMODE:HUDDrawTargetID()
	
	if not LocalPlayer():Alive() and LocalPlayer():Team() != TEAM_UNASSIGNED then
		
		DeathScreenScale = math.Approach( DeathScreenScale, 1, FrameTime() * 0.3 ) 
		
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH() * ( 0.15 * DeathScreenScale ), Color( 0, 0, 0, 180 ) )
		draw.RoundedBox( 0, 0, ScrH() - ( ScrH() * ( 0.15 * DeathScreenScale ) ), ScrW(), ScrH() * ( 0.15 * DeathScreenScale ), Color( 0, 0, 0, 180 ) )
		
		if DeathScreenScale == 1 then
		
			local dtime = math.Round( DeathScreenTime - CurTime() )
			
			if dtime > 0 then
			
				draw.SimpleText( "YOU WILL RESPAWN IN "..dtime.." SECONDS", "DeathFont", ScrW() * 0.5, ScrH() * 0.1, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				
			else
			
				draw.SimpleText( "PRESS ANY KEY TO RESPAWN", "DeathFont", ScrW() * 0.5, ScrH() * 0.1, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			end
			
			draw.SimpleText( DeathScreenText or "POOP", "DeathFont", ScrW() * 0.5, ScrH() * 0.9, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		end
	
	end
	
	if not LocalPlayer():Alive() or LocalPlayer():Team() == TEAM_UNASSIGNED then return end //or GAMEMODE:ElementsVisible() then return end
	
	GAMEMODE:DrawMarkers()
	
	local xlen = 200
	local ylen = 25
	local xpos = 5
	local ypos = ScrH() - 5 - ylen
	
	DrawBar( xpos, ypos, xlen, ylen, LocalPlayer():Health(), 150, matHealth, Color( 225, 50, 50, 255 ), Color( 175, 25, 25, 255 ), true )
	
	ypos = ScrH() - 10 - ylen * 2
	
	local stam = LocalPlayer():GetNWInt( "Stamina", 0 )
	
	DrawBar( xpos, ypos, xlen, ylen, stam, 150, matStamina, Color( 50, 100, 225, 255 ), Color( 25, 50, 175, 255 ), false )
	
	local tbl = GAMEMODE:GetAfflictions()
	
	for k,v in pairs( tbl ) do
	
		ypos = ScrH() - ( 10 + ( k * 5 ) ) - ylen * ( 2 + k )
		
		DrawIcon( xpos, ypos, xlen, ylen, v.Icon, v.Color )
	
	end
	
	local ylen = 55
	local ypos = 35
	
	if IsValid( LocalPlayer():GetActiveWeapon() ) and ( LocalPlayer():GetActiveWeapon().AmmoType or "SMG" ) != "Knife" then
	
		local total = LocalPlayer():GetNWInt( "Ammo" .. ( LocalPlayer():GetActiveWeapon().AmmoType or "SMG" ), 0 )
		local ammo = math.Clamp( LocalPlayer():GetActiveWeapon():Clip1(), 0, total )
	
		local xlen = 50
	
		DrawAmmo( ScrW() - 5 - xlen, ScrH() - ylen - 5, xlen, ylen, total, "TOTAL" )
		DrawAmmo( ScrW() - 10 - xlen * 2, ScrH() - ylen - 5, xlen, ylen, ammo, "AMMO" )
		
		ypos = ypos + ylen + 5
	
	end
	
	DrawCash( ScrW() - 110, ScrH() - ypos, 105, 30, string.upper( LocalPlayer():GetNWInt( "Cash", 0 ) .. "  " .. GAMEMODE.CurrencyName .. "s" ) )

	GAMEMODE:PaintWeather()
	--[[local radius = 200 
	local centerx = ScrW() - ( radius / 2 ) - 20
	local centery = 20 + ( radius / 2 )
	
	ArmAngle = ArmAngle + FrameTime() * ArmSpeed
		
	if ArmAngle > 360 then
		ArmAngle = 0 + ( ArmAngle - 360 )
	end
	
	surface.SetDrawColor( 255, 255, 255, 220 ) 
	surface.SetMaterial( matRadar ) 
	surface.DrawTexturedRect( ScrW() - radius - 20, 20, radius, radius ) 
	
	local aimvec = LocalPlayer():GetAimVector()
	
	for k,v in pairs( PosTable ) do
		
		local diff = v.Pos - LocalPlayer():GetPos()
		local alpha = 100 
		
		if IsValid( v.Ent ) and ( v.Ent:IsPlayer() or v.Ent:IsNPC() ) then
		
			diff = v.Ent:GetPos() - LocalPlayer():GetPos()
		
		end
		
		if v.DieTime != -1 then
		
			alpha = 100 * ( math.Clamp( v.DieTime - CurTime(), 0, BlipTime ) / BlipTime )
		
		elseif not IsValid( v.Ent ) then
			
			PosTable[k].DieTime = CurTime() + 1.5
			
		end
			
		if math.sqrt( diff.x * diff.x + diff.y * diff.y ) > MaxDist * FadeDist and v.DieTime == -1 then
			
			PosTable[k].DieTime = CurTime() + 1.5 // Remove the dot because they left our inner circle
			
		end
			
		if alpha > 0 and math.sqrt( diff.x * diff.x + diff.y * diff.y ) < MaxDist then
			
			local addx = diff.x / MaxDist
			local addy = diff.y / MaxDist
			local addz = math.sqrt( addx * addx + addy * addy )
			local phi = math.atan2( addx, addy ) - math.atan2( aimvec.x, aimvec.y ) - ( math.pi / 2 )
			
			addx = math.cos( phi ) * addz
			addy = math.sin( phi ) * addz
			
			draw.RoundedBox( 4, centerx + addx * ( ( radius - 15 ) / 2 ) - 4, centery + addy * ( ( radius - 15 ) / 2 ) - 4, 5, 5, Color( v.Color.r, v.Color.g, v.Color.b, alpha ) )
			
		end
	
	end
		
	for k,v in pairs( PosTable ) do
		
		if v.DieTime != -1 and v.DieTime < CurTime() then
			
			table.remove( PosTable, k )
			
		end
		
	end
		
	surface.SetDrawColor( 255, 255, 255, 220 ) 
	surface.SetMaterial( matArm )
	surface.DrawTexturedRectRotated( centerx, centery, radius, radius, ArmAngle ) 
	
	local ent = LocalPlayer():GetDTEntity( 0 )
	
	if IsValid( ent ) or StaticPos != Vector(0,0,0) then
	
		local ang = Angle(0,0,0)
	
		if IsValid( ent ) then
		
			ang = ( ent:GetPos() - LocalPlayer():GetShootPos()):Angle() - LocalPlayer():GetForward():Angle()
			
			local diff = ( ent:GetPos() - LocalPlayer():GetPos() )
				
			if math.sqrt( diff.x * diff.x + diff.y * diff.y ) < MaxDist * FadeDist then 
				
				return
				
			end
		
		end
		
		if StaticPos != Vector(0,0,0) then
		
			ang = ( StaticPos - LocalPlayer():GetShootPos()):Angle() - LocalPlayer():GetForward():Angle()
		
		end
		
		surface.SetDrawColor( 255, 255, 255, 200 ) 
		surface.SetMaterial( matArrow )
		surface.DrawTexturedRectRotated( centerx, centery, radius, radius, ang.y )
		
	end]]
	
end

--[[function IsOnRadar( ent )

	for k,v in pairs( PosTable ) do
	
		if v.Ent == ent then
		
			return v
		
		end
	
	end

end]]

function GM:HUDWeaponPickedUp( wep )

end

function GM:HUDItemPickedUp( itemname )

end

function GM:HUDAmmoPickedUp( itemname, amount )

end

function GM:HUDDrawPickupHistory( )

end

function GM:HUDPaintBackground()

end

function GM:CreateMove( cmd )

	if LocalPlayer():Team() == TEAM_ZOMBIES then
	
		if bit.band( cmd:GetButtons(), IN_DUCK ) > 0 then
		
			cmd:SetButtons( cmd:GetButtons() - IN_DUCK )
			
		end
	
	else
	
		local scale = LocalPlayer():GetNWInt( "Radiation", 0 ) / 5
		local wobble = 0
		
		if scale > 0 and LocalPlayer():Alive() then
		
			wobble = scale * 0.05
			
		end
		
		local drunkscale = Drunkness / 10
		
		if Drunkness > 0 then
		
			if ( DrunkTimer or 0 ) < CurTime() then
			
				Drunkness = math.Clamp( Drunkness - 1, 0, 20 )
				DrunkTimer = CurTime() + 15
			
			end
			
			wobble = wobble + ( drunkscale * 0.08 )

		end
		
		if LocalPlayer():Health() <= 75 and LocalPlayer():Alive() then
		
			local hscale = math.Clamp( LocalPlayer():Health() / 50, 0, 1 )
			wobble = wobble + ( 0.05 - 0.05 * hscale )
			
		end
		
		ViewWobble = math.Approach( ViewWobble, wobble, FrameTime() * 0.1 ) 
		
		local ang = cmd:GetViewAngles()
		
		if ViewWobble > 0 or ang.r != 0 then
			
			ang.p = ang.p + math.sin( CurTime() ) * ViewWobble
			ang.y = ang.y + math.cos( CurTime() ) * ViewWobble
			ang.r = math.Approach( ang.r + math.sin( CurTime() ) * ( ( ViewWobble * 0.5 ) * math.cos( CurTime() * ViewWobble ) ), 0, FrameTime() * 0.5 )
		
			cmd:SetViewAngles( ang )
		
		end
	
	end

end

function GrenadeHit( msg )

	DisorientTime = CurTime() + 8
	
end
usermessage.Hook( "GrenadeHit", GrenadeHit )

function ScreamHit( msg )

	ScreamTime = CurTime() + 8
	
end
usermessage.Hook( "ScreamHit", ScreamHit )

function DeathScreen( msg )

	local dteam = msg:ReadShort()

	DeathScreenScale = 0
	DeathScreenTime = CurTime() + 10
	DeathScreenText = table.Random( GAMEMODE.DeathScreenText[ dteam or TEAM_ARMY ] )
	
end
usermessage.Hook( "DeathScreen", DeathScreen )

--[[function Ragdoll( msg )

	local pos = msg:ReadVector()
	local burn = msg:ReadShort()
	local ent = Entity( msg:ReadShort() )
	
	if IsValid( ent ) and not ent.Ragdolled then
	
		ent:BecomeRagdollOnClient()
		ent.Ragdolled = true
	
	end
	
	if burn == 2 then
	
		table.insert( BurnTbl, { Pos = pos, Time = CurTime() + 0.5 } )
	
	end

end
usermessage.Hook( "Ragdoll", Ragdoll )]]

function Burned( msg )

	table.insert( BurnTbl, { Pos = msg:ReadVector(), Time = CurTime() + 0.5 } )

end
usermessage.Hook( "Burned", Burned )

function Gibbed( msg )

	table.insert( GibbedTbl, { Pos = msg:ReadVector(), Time = CurTime() + 0.5 } )

end
usermessage.Hook( "Gibbed", Gibbed )

function Headless( msg )

	table.insert( HeadlessTbl, { Pos = msg:ReadVector(), Time = CurTime() + 0.5 } )

end
usermessage.Hook( "Headless", Headless )

function SetRadarTarget( msg )
 
	StaticPos = msg:ReadVector()
 
end
usermessage.Hook( "StaticTarget", SetRadarTarget )

function AddDrunkness( msg )
 
	Drunkness = math.Clamp( Drunkness + msg:ReadShort(), 0, 20 )
	DrunkTimer = CurTime() + 30
 
end
usermessage.Hook( "Drunk", AddDrunkness )

function CashSynch( msg )
 
	Inv_SetStashCash( msg:ReadShort() )
 
end
usermessage.Hook( "CashSynch", CashSynch )

function Radio( msg )

	local num = msg:ReadShort()
	local snd = msg:ReadString()
	
	if num == 100 then
	
		surface.PlaySound( snd )
	
	else
	
		if not IsValid( LocalPlayer() ) then return end
		
		sound.Play( snd, LocalPlayer():GetShootPos(), 180, num, 1 )
		
	end

end
usermessage.Hook( "Radio", Radio )

net.Receive( "StatsSynch", function( len )

	local count = net.ReadInt( 8 )
	PlayerStats = {}
	
	for i=1, count do
	
		table.insert( PlayerStats, { Player = net.ReadEntity(), Stats = net.ReadTable() } )
	
	end

end )

net.Receive( "InventorySynch", function( len )

	LocalInventory = net.ReadTable()
	
	if GAMEMODE.ItemSheet and GAMEMODE.ItemSheet:IsVisible() then
	
		GAMEMODE.ItemSheet:RefreshItems( LocalInventory )
		
	end

end )

net.Receive( "StashSynch", function( len )

	LocalStash = net.ReadTable()
	
	if StashScreen and StashScreen:IsVisible() then
	
		StashScreen:RefreshItems( LocalStash )
		
	end

end )
