local PANEL = {}

function PANEL:Init()

	//self:SetTitle( "" )
	//self:ShowCloseButton( false )
	//self:SetDraggable( false )
	
	self.Items = {}
	
	self.List = vgui.Create( "DListView", self )
	
	local col1 = self.List:AddColumn( "Ordered Item" )
	local col2 = self.List:AddColumn( "Cost" )
	
	col1:SetMinWidth( 150 )
	col2:SetMinWidth( 50 )
	col2:SetMaxWidth( 100 )
	
	self.Button = vgui.Create( "DImageButton", self )
	self.Button:SetImage( "toxsin/airdrop" )
	self.Button.OnMousePressed = function() self.List:Clear() self.Items = {} RunConsoleCommand( "ordershipment" ) RunConsoleCommand( "gm_showteam" ) end
	
end

function PANEL:AddItems( id, amt )

	local tbl = item.GetByID( id )
	
	if tbl.Price * amt > LocalPlayer():GetNWInt( "Cash", 0 ) then return end

	for i=1,amt do
	
		table.insert( self.Items, id )
	
	end
	
	self.List:Clear()
	
	for k,v in pairs( self.Items ) do
	
		local tbl = item.GetByID( v )
	
		self.List:AddLine( tbl.Name, tbl.Price )
	
	end

end

function PANEL:GetPadding()
	return 5
end

function PANEL:PerformLayout()

	local x,y = self:GetPadding(), self:GetPadding() + 30
	
	self.List:SetSize( self:GetWide() * 0.5 - ( 2 * self:GetPadding() ), self:GetTall() - ( 2 * self:GetPadding() ) - 30 )
	self.List:SetPos( x, y )

	self.Button:SetSize( self:GetWide() * 0.5 - ( 2 * self:GetPadding() ), self:GetTall() - ( 2 * self:GetPadding() ) - 30 )
	self.Button:SetPos( x + self.List:GetWide() + self:GetPadding(), self:GetPadding() + 30 )
	
	self:SizeToContents()

end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 150 ) )
	
	draw.SimpleText( "Shipment Display", "ItemDisplayFont", self:GetWide() * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "ShopMenu", "A shop menu.", PANEL, "PanelBase" )
