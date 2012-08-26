local PANEL = {}

PANEL.OnSound = Sound( "common/talk.wav" )
PANEL.OffSound = Sound( "weapons/sniper/sniper_zoomin.wav" )

surface.CreateFont ( "CategoryButton", { size = 16, weight = 500, antialias = true, additive = false, font = "Typenoksidi" } )

function PANEL:Init()

	//self:SetTitle( "" )
	//self:ShowCloseButton( false )
	//self:SetDraggable( false )
	
	self:SetCursor( "hand" )
	
	self.Image = vgui.Create( "DImageButton", self )
	self.Image:SetImage( "icon16/car.png" )
	self.Image:SetStretchToFit( false )
	self.Image.DoClick = function()
	
		self:Toggle()
	
	end
	
	self.Selected = false
	self.Text = ""
	
end

function PANEL:SetImage( img )

	self.Image:SetImage( img )

end

function PANEL:SetText( text )

	self.Text = text

end

function PANEL:Toggle( bool )

	self:SetSelectedState( bool or !self.Selected )
	
	if not bool then
	
		self:OnToggle( self.Selected )
		
	end

end

function PANEL:OnToggle( bool ) // override this

end

function PANEL:DoSound( bool )

	if bool then
	
		surface.PlaySound( self.OnSound )
	
	else
	
		surface.PlaySound( self.OffSound )
	
	end

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
	self:Toggle()

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
	
	if self.Selected then
	
		draw.RoundedBox( 4, self:GetWide() - imgsize - self:GetPadding(), self:GetPadding(), imgsize, imgsize, Color( 100, 100, 100, 100 ) )
		
		draw.SimpleText( self.Text, "CategoryButton", tx+1, ty+1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		draw.SimpleText( self.Text, "CategoryButton", tx-1, ty-1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		draw.SimpleText( self.Text, "CategoryButton", tx+1, ty-1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		draw.SimpleText( self.Text, "CategoryButton", tx-1, ty+1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		
		draw.SimpleText( self.Text, "CategoryButton", tx, ty, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	
	else

		draw.RoundedBox( 4, self:GetWide() - imgsize - self:GetPadding(), self:GetPadding(), imgsize, imgsize, Color( 100, 100, 100, 100 ) )
		
		draw.SimpleText( self.Text, "CategoryButton", tx+1, ty+1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		draw.SimpleText( self.Text, "CategoryButton", tx-1, ty-1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		draw.SimpleText( self.Text, "CategoryButton", tx+1, ty-1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		draw.SimpleText( self.Text, "CategoryButton", tx-1, ty+1, Color( 0, 0, 0, 150 ), TEXT_ALIGN_LEFT )
		
		draw.SimpleText( self.Text, "CategoryButton", tx, ty, Color( 100, 100, 100, 255 ), TEXT_ALIGN_LEFT )
		
	end

end

derma.DefineControl( "CategoryButton", "A shitty button thing.", PANEL, "PanelBase" )
