local PANEL = {}

function PANEL:Init()

	//self:SetTitle( "" )
	//self:ShowCloseButton( false )
	//self:SetDraggable( false )
	
	self.Image = vgui.Create( "DImageButton", self )
	self.Image:SetImage( "icon16/car.png" )
	self.Image:SetStretchToFit( false )
	self.Image.DoClick = function()
	
		self:DoClick()
	
	end
	
	self:SetCursor( "hand" )
	self.Text = ""
	self.White = 255
	self.ColorTime = 0
	
end

function PANEL:SetImage( img )

	self.Image:SetImage( img )

end

function PANEL:SetText( text )

	self.Text = text

end

function PANEL:DoClick()

	self.Func()
	surface.PlaySound( self.Sound )

end

function PANEL:SetFunction( func ) 

	self.Func = func

end

function PANEL:SetSelectedState( bool, ignore )

	self.Selected = tobool( bool )
	
	if ignore then return end
	
	self:DoSound( bool )

end

function PANEL:OnMousePressed( mousecode )

	self:MouseCapture( true )

end

function PANEL:OnMouseReleased( mousecode )

	self:MouseCapture( false )
	self:DoClick()

end

function PANEL:GetPadding()
	return 5
end

function PANEL:PerformLayout()

	self.Image:SetSize( self:GetWide() - 10, self:GetTall() - 10 )
	self.Image:SetPos( 5, 5 )
	
	//self:SizeToContents()

end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 180 ) )

end

derma.DefineControl( "Scroller", "A shitty scroller thing.", PANEL, "PanelBase" )
