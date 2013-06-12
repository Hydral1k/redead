local PANEL = {}

function PANEL:Init()

	self:PerformLayout()
	
	self.Wait = CurTime() + 5
	self.Pos = 1
	self.YPos = 220
	self.ListMode = true
	self.DrawTbl = {} 
	self.Awards = {}
	
	self.Lists = {}
	self.Lists[1] = { 5, ScrW() * 0.30, "Survivors", function() return self:GetSurvivors() end, "bot/whoo2.wav" } 
	self.Lists[2] = { ScrW() * 0.50 - ScrW() * 0.15, ScrW() * 0.30, "Top  Killers", function() return self:GetTopKillers() end, "weapons/357_fire2.wav" } 
	self.Lists[3] = { ScrW() - ( ScrW() * 0.30 ) - 5, ScrW() * 0.30, "Big  Spenders", function() return self:GetTopSpenders() end, "physics/metal/chain_impact_soft1.wav" } 
	
	local x, w = ScrW() * 0.50 - ScrW() * 0.15, ScrW() * 0.65 - 5
	
	self:ListNewAward( { x, w, "Grey Matter:", "got the most headshots.", function() return self:GetStatMax( "Headshot" ) end, "zombie craniums", "player/headshot1.wav" } ) 
	self:ListNewAward( { x, w, "Silent Partner:", "got the most kill assists.", function() return self:GetStatMax( "Assist" ) end, "assists", "weapons/357/357_spin1.wav" } )
	self:ListNewAward( { x, w, "Longshot:", "got the longest distance kill.", function() return self:GetStatMax( "Longshot" ) end, "feet", "weapons/fx/nearmiss/bulletLtoR05.wav" } )
	self:ListNewAward( { x, w, "Big Game Hunter:", "dismembered the most zombies with a shotgun.", function() return self:GetStatMax( "Meat" ) end, "zombies poached", "nuke/gore/blood01.wav", true } )
	self:ListNewAward( { x, w, "Bullet Hose:", "used the most ammunition.", function() return self:GetStatMax( "Bullets" ) end, "rounds fired", "player/pl_shell1.wav" } )
	self:ListNewAward( { x, w, "Meat Grinder:", "butchered the most zombies with a melee weapon.", function() return self:GetStatMax( "Knife" ) end, "melee kills", "weapons/knife/knife_hit2.wav", true } )
	self:ListNewAward( { x, w, "Demolitionist:", "killed the most zombies with explosives.", function() return self:GetStatMax( "Explode" ) end, "unidentified bodies", "weapons/underwater_explode3.wav", true } )
	self:ListNewAward( { x, w, "Firebug:", "ignited the most zombies.", function() return self:GetStatMax( "Igniter" ) end, "crispy corpses", "ambient/fire/mtov_flame2.wav", true } )
	self:ListNewAward( { x, w, "Kleptomaniac:", "picked up the most items.", function() return self:GetStatMax( "Loot" ) end, "items taken", "items/itempickup.wav" } )
	self:ListNewAward( { x, w, "Broke The Bank:", "bought the most expensive weapon.", function() return self:GetStatMax( "Pricey" ) end, GAMEMODE.CurrencyName .. "s spent", "ambient/office/coinslot1.wav" } )
	self:ListNewAward( { x, w, "Meet The Engineer:", "built the most barricades.", function() return self:GetStatMax( "Wood" ) end, "barricades built", "npc/dog/dog_servo6.wav", true } )
	self:ListNewAward( { x, w, "Brain Munch:", "dealt the most damage to humans.", function() return self:GetStatMax( "ZedDamage" ) end, "health points", "npc/zombie/zombie_voice_idle2.wav", true } )
	self:ListNewAward( { x, w, "Get To Ze Choppa:", "was the first to reach the evacuation zone.", function() return self:GetStatMax( "Evac" ) end, nil, "ambient/machines/spinup.wav", true } )
	self:ListNewAward( { x, w, "Martyr:", "was the first human to die.", function() return self:GetStatMax( "Martyr" ) end, nil, "npc/crow/alert1.wav", true } )
	self:ListNewAward( { x, w, "Unhealthy Glow:", "was irradiated the most.", function() return self:GetStatMax( "Rad" ) end, "malignant tumors", "player/geiger3.wav", true } )
	self:ListNewAward( { x, w, "Cum Dumpster:", "was infected by zombies the most.", function() return self:GetStatMax( "Infections" ) end, "infections", "ambient/voices/cough1.wav", true } )
	self:ListNewAward( { x, w, "Accident Prone:", "took the most damage from zombies.", function() return self:GetStatMax( "Damage" ) end, "damage", "bot/pain2.wav" } )
	self:ListNewAward( { x, w, "Roleplayer:", "did jack shit.", function() return self:GetWorstPlayer() end, "kills", "ambient/sheep.wav" } )
	//self:ListNewAward( { x, w, "Piss Poor:", "spent the least " .. GAMEMODE.CurrencyName .. "s.", function() return self:GetStatMin( "Spent" ) end, GAMEMODE.CurrencyName .. "s spent", "bot/i_got_nothing.wav" } )
	
end

function PANEL:ListNewAward( tbl )

	table.insert( self.Awards, tbl )

end

function PANEL:GetWorstPlayer()

	local min = 9000
	local ply = NULL

	for k,v in pairs( player.GetAll() ) do
	
		if v:Frags() < min then
		
			min = v:Frags()
			ply = v
		
		end
	
	end
	
	return ply, min

end

function PANEL:GetStatMin( name )

	local min = 9000
	local ply = NULL

	for k,v in pairs( PlayerStats ) do
	
		if v.Stats and ( v.Stats[ name ] or 0 ) < min then
		
			min = ( v.Stats[ name ] or 0 )
			ply = v.Player
		
		end
	
	end
	
	return ply, min

end

function PANEL:GetStatMax( name )

	local max = -1
	local ply = NULL

	for k,v in pairs( PlayerStats ) do
	
		if v.Stats and ( v.Stats[ name ] or 0 ) > max then
		
			max = ( v.Stats[ name ] or 0 )
			ply = v.Player
		
		end
	
	end
	
	return ply, max

end

function PANEL:GetSurvivors()

	local tbl = {}
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		table.insert( tbl, { v } )
	
	end

	return tbl

end

function PANEL:GetTopSpenders()

	local num = math.min( #player.GetAll(), 5 )
	local tbl = {}
	local ignore = {}
	
	for i=1, num do
	
		local count = -1
		local ply = NULL
	
		for k,v in pairs( PlayerStats ) do
		
			if v.Stats and ( v.Stats[ "Spent" ] or 0 ) > count and not table.HasValue( ignore, v.Player ) then
			
				ply = v.Player
				count = ( v.Stats[ "Spent" ] or 0 )
			
			end
		
		end
		
		if ply != NULL then
			
			table.insert( tbl, { ply, count } )
			table.insert( ignore, ply )
			
		end
	
	end
	
	return tbl

end

function PANEL:GetTopKillers()

	local num = math.min( #player.GetAll(), 5 )
	local plys = player.GetAll()
	local tbl = {}
	
	for i=1, num do
	
		local count = -1
		local ply = NULL
		local pos = 0
	
		for k,v in pairs( plys ) do
		
			if v:Frags() > count then
			
				ply = v
				pos = k
				count = v:Frags()
			
			end
		
		end
		
		if ply != NULL then
		
			table.remove( plys, pos )
			table.insert( tbl, { ply, ply:Frags() } )
			
		end
	
	end
	
	return tbl

end

function PANEL:PerformLayout()
	
	self:SetSize( ScrW(), ScrH() )
	
end

function PANEL:AddList( pos, width, title, players, sound )

	surface.PlaySound( sound )

	table.insert( self.DrawTbl, { X = pos + width * 0.5, Y = 35, Text = title, Style = TEXT_ALIGN_CENTER, Font = "EndGameBig" } )
	
	if not players[1] then return end
	
	local ypos = 60
	
	for k,v in pairs( players ) do

		local list = vgui.Create( "PlayerPanel" )
		list:SetPlayerEnt( v[1] )
		list:SetCount( v[2] )
		list:SetTall( 26 )
		list:SetWide( width )
		list:SetPos( pos, ypos )  
		
		ypos = ypos + 31 

	end

end

function PANEL:AddAward( ypos, pos, width, title, desc, ply, amt, append, sound, condition )

	if condition and amt < 1 then 
		
		self.Wait = 0
	
		return 
		
	end
	
	surface.PlaySound( sound )

	self.YPos = self.YPos + 31
	self.Wait = CurTime() + 1.5

	table.insert( self.DrawTbl, { X = pos + 2, Y = ypos + 5, Text = title, Style = TEXT_ALIGN_LEFT, Font = "EndGame" } )
	
	local offset = 150
	
	local list = vgui.Create( "PlayerPanel" )
	list:SetPlayerEnt( ply )
	list:SetDescription( desc )
	list:SetTall( 26 )
	list:SetWide( width - offset )
	list:SetPos( pos + offset, ypos ) 
	
	if append then
	
		list:SetCount( amt .. " " .. append )
	
	end

end

function PANEL:Think()

	if self.Wait and self.Wait < CurTime() then
	
		self.Wait = CurTime() + 0.5
		
		if self.ListMode then
		
			local alist = self.Lists[ self.Pos ]
		
			self:AddList( alist[1], alist[2], alist[3], alist[4](), alist[5] )
			
			self.Pos = self.Pos + 1
			
			if self.Pos > #self.Lists then
			
				self.ListMode = false
				self.Wait = CurTime() + 1.5
				self.Pos = 1
			
			end
			
		else
		
			local alist = self.Awards[ self.Pos ] 
			
			local ply, amt = alist[5]()
		
			self:AddAward( self.YPos, alist[1], alist[2], alist[3], alist[4], ply, amt, alist[6], alist[7], alist[8] )
			
			self.Pos = self.Pos + 1
			
			if self.Pos > #self.Awards then
			
				self.Wait = nil
			
			end
		
		end
	
	end

end

function PANEL:Paint()

	for k,v in pairs( self.DrawTbl ) do
	
		draw.SimpleText( v.Text, v.Font, v.X, v.Y, Color( 255, 255, 255 ), v.Style, v.Style )
	
	end

end

derma.DefineControl( "EndGame", "The end-game stat page", PANEL, "PanelBase" )
