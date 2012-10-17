local PANEL = {}

PANEL.Text = { "<html><body style=\"background-color:DimGray;\">",
"<p style=\"font-family:tahoma;color:red;font-size:25;text-align:center\"><b>READ THIS!</b></p>",
"<p style=\"font-family:verdana;color:black;font-size:10px;text-align:left\"><b>The Inventory System:</b> ",
"To toggle your inventory, press your spawn menu button (default Q). Click an item in your inventory to interact with it. To interact with dropped items, press your USE key (default E) on them.<br><br>",
"<b>Purchasing Items:</b> Press F2 to purchase and order items to be airdropped to you. You can only order items outdoors.<br><br>",
"<b>The Panic Button:</b> Press F3 to activate the panic button. It automatically detects your ailments and attempts to fix them using what you have in your inventory.<br><br>",
"<b>The HUD:</b> The location of important locations and items are marked on your screen. Your teammates are highlighted through walls, as well as the antidote.",
"If you have radiation poisoning, an icon indicating the severity of the poisoning will appear on the bottom left of your screen. An icon will also appear if you are bleeding or infected.<br><br>",
"<b>Evacuation:</b> At the last minute of the round, a helicopter will come to rescue your squad. Run to the evac zone marked on your HUD to be rescued.<br><br>",
"<b>The Infection:</b> The common undead will infect you when they hit you. To cure infection, go to the antidote and press your USE key to access it. The antidote location is always marked on your HUD.<br><br>",
"<b>The Zombie Lord:</b> If there are more than 8 players then a zombie lord will be chosen. If the zombie lord manages to fill their blood meter, they will respawn as a human with a special reward.<br><br>",
"<b>Radiation:</b> Radiation is visually unnoticeable. When near radiation, your handheld geiger counter will make sounds indicating how close you are to a radioactive deposit. Radiation poisoning is cured by vodka or Anti-Rad.<br><br>" }

PANEL.ButtonText = { "Holy Shit I Don't Care",
"I Didn't Read Any Of That",
"That's A Lot Of Words",
"I'd Rather Just Whine For Help",
"Just Wanna Play Video Games",
"Who Gives A Shit?",
"Help Menus Are For Nerds",
"I Thought This Was A Roleplay Server",
"How I Shoot Zobies",
"How Do I Buy Wepon",
"HEY GUYS WHERES ANTIDOTE this game suck",
"WHERE MY INVENTOREY",
"TL;DR",
"FUCK OFF" }

function PANEL:Init()

	//self:SetTitle( "" )
	//self:ShowCloseButton( false )
	self:ChooseParent()
	
	local text = ""
	
	for k,v in pairs( self.Text ) do
	
		text = text .. v
	
	end
	
	self.Label = vgui.Create( "HTML", self )
	self.Label:SetHTML( text )
	
	self.Button = vgui.Create( "DButton", self )
	self.Button:SetText( table.Random( self.ButtonText ) )
	self.Button.OnMousePressed = function()

		self:Remove() 
		
		if LocalPlayer():Team() != TEAM_UNASSIGNED then return end
		
		local classmenu = vgui.Create( "ClassPicker" )
		classmenu:SetSize( 415, 475 )
		classmenu:Center()
		classmenu:MakePopup()
		
	end
	
end

function PANEL:ChooseParent()
	
end

function PANEL:GetPadding()
	return 5
end

function PANEL:PerformLayout()

	local x,y = self:GetPadding(), self:GetPadding() + 10
	
	self.Label:SetSize( self:GetWide() - ( self:GetPadding() * 2 ) - 5, self:GetTall() - 50 )
	self.Label:SetPos( x + 5, y + 5 )
	
	self.Button:SetSize( 250, 20 )
	self.Button:SetPos( self:GetWide() * 0.5 - self.Button:GetWide() * 0.5, self:GetTall() - 30 )
	
	self:SizeToContents()

end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 150 ) )
	
	draw.SimpleText( "Help Menu", "ItemDisplayFont", self:GetWide() * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "HelpMenu", "A help menu.", PANEL, "PanelBase" )
