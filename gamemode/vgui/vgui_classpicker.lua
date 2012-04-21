local PANEL = {}

function PANEL:Init()

	//self:SetTitle( "" )
	//self:ShowCloseButton( false )
	self:ChooseParent()
	
	self.Items = {}
	
	for k,v in pairs( GAMEMODE.ClassNames ) do

		local desc = GAMEMODE.ClassDescriptions[k] or "TEH"
		local logo = GAMEMODE.ClassLogos[k] or "brick/brick_model"
		
		local button = vgui.Create( "DImageButton", self )
		button:SetImage( logo )
		button:SetSize( 100, 100 )
		button.OnMousePressed = function() RunConsoleCommand( "changeclass", k ) RunConsoleCommand( "changeteam", TEAM_ARMY ) self:Remove() end
		button.ID = id

		local label = vgui.Create( "DLabel", self )
		label:SetWrap( true )
		label:SetText( desc )
		label:SetFont( "ItemDisplayFont" )
		label:SetSize( 300, 100 )
			
		table.insert( self.Items, { button, label } )
		
	end
	
end

function PANEL:ChooseParent()
	
end

function PANEL:GetPadding()
	return 5
end

function PANEL:PerformLayout()

	local x,y = self:GetPadding(), self:GetPadding() + 50

	for k,v in pairs( self.Items ) do
	
		v[1]:SetPos( x, y )
		v[2]:SetPos( x + 100 + self:GetPadding(), y )
		
		y = y + 100 + self:GetPadding()
	
	end
	
	self:SizeToContents()

end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 150 ) )
	
	draw.SimpleText( "Class Menu", "ItemDisplayFont", self:GetWide() * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "ClassPicker", "A class picker menu.", PANEL, "PanelBase" )
