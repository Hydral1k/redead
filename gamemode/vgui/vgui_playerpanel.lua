local PANEL = {}

function PANEL:Init()

	//self:ShowCloseButton( false )
	
	self.Avatar = vgui.Create( "AvatarImage", self )
	self.PlayerName = "N/A"
	self.Desc = ""
	
	self:PerformLayout()
	
end

function PANEL:SetPlayerEnt( ply )

	self.Avatar:SetPlayer( ply )
	
	if IsValid( ply ) then
	
		self.PlayerName = ply:Nick()
	
	end

end

function PANEL:SetCount( num )

	self.Count = num

end

function PANEL:SetDescription( text )

	self.Desc = text

end

function PANEL:GetPadding()

	return 5

end

function PANEL:PerformLayout()
	
	self.Avatar:SetSize( 16, 16 )
	self.Avatar:SetPos( self:GetPadding(), self:GetPadding() )
	
	self:SetTall( 16 + self:GetPadding() * 2 )
	
end

function PANEL:Paint()

	draw.RoundedBox( 4, 2, 2, self:GetWide() - 4, self:GetTall() - 4, Color( 100, 100, 100, 255 ) )
	
	draw.SimpleText( self.PlayerName .. " " .. self.Desc, "EndGame", self:GetPadding() * 3 + 16, self:GetTall() * 0.4 - self:GetPadding(), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	
	if self.Count then
	
		draw.SimpleText( self.Count, "EndGame", self:GetWide() - self:GetPadding() * 2, self:GetTall() * 0.4 - self:GetPadding(), Color( 255, 50, 50 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT )
	
	end

end

derma.DefineControl( "PlayerPanel", "A HUD Element with a player name and avatar", PANEL, "PanelBase" )
