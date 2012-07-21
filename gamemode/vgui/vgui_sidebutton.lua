local PANEL = {}

PANEL.Sound = Sound( "common/talk.wav" )

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

	local imgsize = self:GetTall() - ( 2 * self:GetPadding() )

	self.Image:SetSize( imgsize, imgsize )
	self.Image:SetPos( self:GetWide() - imgsize - self:GetPadding(), self:GetPadding() )
	
	//self:SizeToContents()

end

function PANEL:Paint()

	local tx, ty = self:GetPadding() * 2, self:GetTall() * 0.5 - 8
	//local px, py = self.Image:GetPos()
	local imgsize = self:GetTall() - ( 2 * self:GetPadding() )

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 180 ) )
	
	if self.Hovered then
	
		draw.RoundedBox( 4, self:GetWide() - imgsize - self:GetPadding(), self:GetPadding(), imgsize, imgsize, Color( 100, 100, 100, 100 ) )
		
		draw.SimpleText( self.Text, "CategoryButton", tx+1, ty+1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		draw.SimpleText( self.Text, "CategoryButton", tx-1, ty-1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		draw.SimpleText( self.Text, "CategoryButton", tx+1, ty-1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		draw.SimpleText( self.Text, "CategoryButton", tx-1, ty+1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		
		if self.ColorTime < CurTime() then
		
			self.ColorTime = CurTime() + math.Rand( 0, 0.3 )
			self.White = math.random( 150, 255 )
		
		end
		
		draw.SimpleText( self.Text, "CategoryButton", tx, ty, Color( self.White, self.White, self.White, 255 ), TEXT_ALIGN_LEFT )
	
	else

		draw.RoundedBox( 4, self:GetWide() - imgsize - self:GetPadding(), self:GetPadding(), imgsize, imgsize, Color( 100, 100, 100, 100 ) )
		
		draw.SimpleText( self.Text, "CategoryButton", tx+1, ty+1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		draw.SimpleText( self.Text, "CategoryButton", tx-1, ty-1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		draw.SimpleText( self.Text, "CategoryButton", tx+1, ty-1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		draw.SimpleText( self.Text, "CategoryButton", tx-1, ty+1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		
		draw.SimpleText( self.Text, "CategoryButton", tx, ty, Color( 100, 100, 100, 255 ), TEXT_ALIGN_LEFT )
		
	end

end

derma.DefineControl( "SideButton", "A shitty action button thing.", PANEL, "PanelBase" )
