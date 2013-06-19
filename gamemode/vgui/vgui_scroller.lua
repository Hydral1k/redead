local PANEL = {}

function PANEL:Init()

	//self:SetTitle( "" )
	//self:ShowCloseButton( false )
	//self:SetDraggable( false )
	
	self.Image = vgui.Create( "DImageButton", self )
	self.Image:SetImage( "icon16/car.png" )
	self.Image:SetStretchToFit( false )
	self.Image.OnMousePressed = function()
	
		self.Depressed = true
	
	end
	
	self.Image.OnMouseReleased = function()
	
		self.Depressed = false
	
	end
	
	self:SetCursor( "hand" )
	self.Up = true
	self.MoveTime = 0
	
end

function PANEL:SetImage( img )

	self.Image:SetImage( img )

end

function PANEL:SetScrollUp( bool )

	self.Up = bool

end

function PANEL:Think()

	if not self.Target then return end
	
	if self.Depressed and self.MoveTime < CurTime() then
	
		self.MoveTime = CurTime() + 0.2
	
		if self.Up then
	
			self.Target:AddScroll( 1 )
	
		else
	
			self.Target:AddScroll( -1 )
			
		end
		
		surface.PlaySound( "buttons/lightswitch2.wav" )
		
	end

end

function PANEL:SetTarget( pnl )

	self.Target = pnl

end

function PANEL:OnMousePressed( mousecode )

	self.Depressed = true
	self:MouseCapture( true )

end

function PANEL:OnMouseReleased( mousecode )

	self.Depressed = false
	self:MouseCapture( false )

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
