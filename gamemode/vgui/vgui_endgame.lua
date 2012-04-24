local PANEL = {}

function PANEL:Init()

	self:PerformLayout()
	
	self.Wait = CurTime() + 5
	self.Pos = 1
	self.YPos = 220
	self.ListMode = true
	self.DrawTbl = {} 
	
	self.Lists = {}
	self.Lists[1] = { 5, ScrW() * 0.30, "Survivors", function() return self:GetSurvivors() end, "bot/whoo2.wav" } 
	self.Lists[2] = { ScrW() * 0.50 - ScrW() * 0.15, ScrW() * 0.30, "Top  Killers", function() return self:GetTopKillers() end, "weapons/357_fire2.wav" } 
	self.Lists[3] = { ScrW() - ( ScrW() * 0.30 ) - 5, ScrW() * 0.30, "Big  Spenders", function() return self:GetTopSpenders() end, "physics/metal/chain_impact_soft1.wav" } 
	
	local x, w = ScrW() * 0.50 - ScrW() * 0.15, ScrW() * 0.65 - 5
	
	self.Awards = {}
	self.Awards[1] = { x, w, "Grey Matter:", "got the most headshots.", function() return self:GetStatMax( "Headshot" ) end, "zombie craniums", "player/headshot1.wav" }
	self.Awards[2] = { x, w, "Silent Partner:", "got the most kill assists.", function() return self:GetStatMax( "Assist" ) end, "assists", "weapons/357/357_spin1.wav" }
	self.Awards[3] = { x, w, "Longshot:", "got the longest distance kill.", function() return self:GetStatMax( "Longshot" ) end, "feet", "weapons/fx/nearmiss/bulletLtoR05.wav" }
	self.Awards[4] = { x, w, "Meat Grinder:", "killed the most zombies with a shotgun.", function() return self:GetStatMax( "Meat" ) end, "zombies butchered", "toxsin/blood01.wav", true }
	self.Awards[5] = { x, w, "Crazy Ivan:", "killed the most zombies with explosives.", function() return self:GetStatMax( "Explode" ) end, "unidentified bodies", "weapons/underwater_explode3.wav", true }
	self.Awards[6] = { x, w, "Shoplifter:", "looted the most items.", function() return self:GetStatMax( "Loot" ) end, "items taken", "items/itempickup.wav" }
	self.Awards[7] = { x, w, "Broke The Bank:", "bought the most expensive weapon.", function() return self:GetStatMax( "Pricey" ) end, GAMEMODE.CurrencyName .. "s spent", "ambient/office/coinslot1.wav" }
	self.Awards[8] = { x, w, "Come At Me Bro:", "butchered the most zombies with a melee weapon.", function() return self:GetStatMax( "Knife" ) end, "melee kills", "weapons/knife/knife_hit2.wav", true }
	self.Awards[9] = { x, w, "Get To Ze Choppa:", "was the first to reach the evacuation zone.", function() return self:GetStatMax( "Evac" ) end, "Arnold Schwarzenegger impression", "ambient/machines/spinup.wav", true }
	self.Awards[10] ={ x, w, "Meet The Engineer:", "built the most barricades.", function() return self:GetStatMax( "Wood" ) end, "barricades built", "npc/dog/dog_servo6.wav", true }
	self.Awards[11] ={ x, w, "Brain Munch:", "killed the most humans.", function() return self:GetStatMax( "ZedKills" ) end, "brains eaten", "npc/zombie/zombie_voice_idle2.wav", true }
	self.Awards[12] ={ x, w, "Cum Dumpster:", "was infected by zombies the most.", function() return self:GetStatMax( "Infections" ) end, "infections", "ambient/voices/cough1.wav", true }
	self.Awards[13] ={ x, w, "Accident Prone:", "took the most damage from zombies.", function() return self:GetStatMax( "Damage" ) end, "damage", "toxsin/pain05.wav" }
	self.Awards[14] ={ x, w, "Piss Poor:", "spent the least " .. GAMEMODE.CurrencyName .. "s.", function() return self:GetStatMin( "Spent" ) end, GAMEMODE.CurrencyName .. "s spent", "bot/i_got_nothing.wav" }
	self.Awards[15] ={ x, w, "Martyr:", "was the first human to die.", function() return self:GetStatMax( "Martyr" ) end, "sacrifice made", "toxsin/carnage04.wav", true }
	self.Awards[16] ={ x, w, "Roleplayer:", "did jack shit.", function() return self:GetWorstPlayer() end, "kills", "ambient/sheep.wav" }
	
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
	self.Wait = CurTime() + 1.0

	table.insert( self.DrawTbl, { X = pos + 2, Y = ypos + 5, Text = title, Style = TEXT_ALIGN_LEFT, Font = "EndGame" } )
	
	local offset = 150
	
	local list = vgui.Create( "PlayerPanel" )
	list:SetPlayerEnt( ply )
	list:SetCount( amt .. " " .. append )
	list:SetDescription( desc )
	list:SetTall( 26 )
	list:SetWide( width - offset )
	list:SetPos( pos + offset, ypos ) 

end

function PANEL:Think()

	if self.Wait and self.Wait < CurTime() then
	
		self.Wait = CurTime() + 0.5
		
		if self.ListMode then
		
			local list = self.Lists[ self.Pos ]
		
			self:AddList( list[1], list[2], list[3], list[4](), list[5] )
			
			self.Pos = self.Pos + 1
			
			if self.Pos > #self.Lists then
			
				self.ListMode = false
				self.Wait = CurTime() + 1.5
				self.Pos = 1
			
			end
			
		else
		
			local list = self.Awards[ self.Pos ] 
			
			local ply, amt = list[5]()
		
			self:AddAward( self.YPos, list[1], list[2], list[3], list[4], ply, amt, list[6], list[7], list[8] )
			
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
