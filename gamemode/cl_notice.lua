
local HUDNote_c = 0
local HUDNote_i = 1
local HUDNotes = {}
local NoteQueue = {}
local NextNotify = 0

surface.CreateFont ( "Notice", { size = 18, weight = 500, antialias = true, additive = true, font = "Typenoksidi" } )

function DoNotice( msg )

	local str = msg:ReadString()
	local r = msg:ReadShort()
	local g = msg:ReadShort()
	local b = msg:ReadShort()
	local len = msg:ReadShort()
	local once = msg:ReadBool()
	local col = Color( r, g, b, 255 )
	
	if once and not CV_NoobHelp:GetBool() then return end
	
	MsgN( str )
	
	str = string.gsub( str, " ", "  " )
	
	GAMEMODE:AddNotify( str, col, len )
	
end
usermessage.Hook( "ToxNotice", DoNotice ) 

function GM:AddNotify( msg, col, len )

	local tab = {}
	tab.text 	= msg
	tab.recv 	= 0 //systime
	tab.len 	= len //how long to display
	tab.velx	= -5
	tab.vely	= 0
	tab.x		= ScrW() + 200
	tab.y		= ScrH()
	tab.a		= 255
	tab.col	    = col
	
	table.insert( NoteQueue, tab )
	
end

function NotifyThink()

	if NextNotify < CurTime() then
	
		NextNotify = CurTime() + 0.3
		
		if NoteQueue[1] then
		
			NoteQueue[1].recv = SysTime()
		
			table.insert( HUDNotes, NoteQueue[1] )
	
			HUDNote_c = HUDNote_c + 1
			HUDNote_i = HUDNote_i + 1
			
			table.remove( NoteQueue, 1 )
		
		end
	
	end

end
hook.Add( "Think", "NotifyThink", NotifyThink )

local function DrawNotice( self, k, v, i )

	local H = ScrH() / 1024
	local x = v.x - 25 * H //74
	local y = v.y - 300 * H //580 * H
	
	if !v.w then
	
		surface.SetFont( "Notice" )
		v.w, v.h = surface.GetTextSize( v.text )
		
	end
	
	local w = v.w
	local h = v.h
	w = w - 16
	h = h + 16

	draw.RoundedBox( 4, x - w - h + 8, y - 8, w + h, h, Color( 10, 10, 10, v.a * 0.5 ) )
	
	draw.SimpleText( v.text, "Notice", x+1, y+1, Color(0,0,0,v.a*0.8), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "Notice", x-1, y-1, Color(0,0,0,v.a*0.5), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "Notice", x+1, y-1, Color(0,0,0,v.a*0.6), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "Notice", x-1, y+1, Color(0,0,0,v.a*0.6), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "Notice", x, y, v.col, TEXT_ALIGN_RIGHT )
	
	local ideal_y = ScrH() - (HUDNote_c - i) * (h + 4)
	local ideal_x = ScrW()
	
	local timeleft = v.len - ( SysTime() - v.recv )
	
	//gone from screen
	
	if ( timeleft < 0.5  ) then
	
		ideal_x = ScrW() + w * 4 //2
		
	end
	
	local spd = RealFrameTime() * 15
	
	v.y = v.y + v.vely * spd
	v.x = v.x + v.velx * spd
	
	local dist = ideal_y - v.y
	v.vely = v.vely + dist * spd * 1
	
	if (math.abs(dist) < 2 && math.abs(v.vely) < 0.1) then v.vely = 0 end
	
	local dist = ideal_x - v.x
	
	v.velx = v.velx + dist * spd * 1
	
	if (math.abs(dist) < 2 && math.abs(v.velx) < 0.1) then v.velx = 0 end
	
	//friction that is FPS independant
	
	v.velx = v.velx * (0.95 - RealFrameTime() * 8 )
	v.vely = v.vely * (0.95 - RealFrameTime() * 8 )

end

function PaintNotes()

	if ( !HUDNotes ) then return end
		
	local i = 0
	for k, v in pairs( HUDNotes ) do
		if ( v != 0 ) then
			i = i + 1
			DrawNotice( self, k, v, i)		
		end
	end
	
	for k, v in pairs( HUDNotes ) do
		if ( v != 0 && v.recv + v.len < SysTime() ) then
			HUDNotes[ k ] = 0
			HUDNote_c = HUDNote_c - 1
			if (HUDNote_c == 0) then HUDNotes = {} end
		end
	end
end

hook.Add("HUDPaint", "PaintNotes", PaintNotes)

