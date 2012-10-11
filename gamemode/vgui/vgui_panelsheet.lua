local PANEL = {}

function PANEL:Init()

	self:ChooseParent()
	self.Stashable = false
	self.StashStyle = "Stash"
	self.PriceScale = 1
	self.Categories = {}
	
	self:SetDraggableName( "GlobalDPanel" );

	self.pnlCanvas 	= vgui.Create( "DPanel", self )
	self.pnlCanvas:SetPaintBackground( false )
	self.pnlCanvas.OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end
	self.pnlCanvas.OnChildRemoved = function() self:OnChildRemoved() end
	self.pnlCanvas:SetMouseInputEnabled( true )
	self.pnlCanvas.InvalidateLayout = function() self:InvalidateLayout() end
	
	self.Items = {}
	self.YOffset = 0
	self.m_fAnimTime = 0;
	self.m_fAnimEase = -1; -- means ease in out
	self.m_iBuilds = 0
	
	self:SetSpacing( 0 )
	self:SetPadding( 0 )
	self:EnableHorizontal( false )
	self:SetAutoSize( false )
	self:SetDrawBackground( true )
	//self:SetBottomUp( false )
	self:SetNoSizing( false )
	
	self:SetMouseInputEnabled( true )
	
	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	
	self.ScrollAmt = 0
	
end

function PANEL:ToggleVisible( tbl, bool )

	if bool then
	
		local newtbl = {}
	
		for k,v in pairs( self.Categories ) do // remove all of tbl from categories
		
			if not table.HasValue( tbl, v ) then
			
				table.insert( newtbl, v )
			
			end
		
		end
		
		self.Categories = newtbl
	
	else
	
		for k,v in pairs( tbl ) do // insert all of tbl into categories
		
			if not table.HasValue( self.Categories, v ) then
			
				table.insert( self.Categories, v )
			
			end
		
		end
	
	end

end

function PANEL:ChooseParent()
	
end

function PANEL:SetPriceScale( scale )

	self.PriceScale = scale

end

function PANEL:SetStashable( bool, style, localinv )

	self.Stashable = bool
	self.StashStyle = style
	self.IsLocalInv = localinv
	
	for k,v in pairs( self:GetItems() ) do
	
		v:SetPriceScale( self.PriceScale )
		v:SetStashable( bool, style )
	
	end

end

function PANEL:GetCash()

	return LocalPlayer():GetNWInt( "Cash", 0 )

end

function PANEL:HasItem( id )

	for k,v in pairs( self:GetItems() ) do
	
		if v:GetID() == id then
		
			return v
		
		end
	
	end

end

function PANEL:GetItemPnlSize() // determine the size of item panels, always needs to add up to 1.0

	--[[if self.StashStyle == "Buy" then
	
		return ( self:GetWide() * 0.2 )
	
	end]]

	return ( self:GetWide() * 0.25 ) 

end

function PANEL:IsBlacklisted( id )

	local tbl = item.GetByID( id )
	local cat = tbl.Type
	
	return table.HasValue( self.Categories, cat )

end

function PANEL:RefreshItems( tbl )

	self:Clear( true )
	
	for k,v in pairs( tbl ) do
	
		local pnl = self:HasItem( v )
	
		if pnl and pnl:IsStackable() then
		
			pnl:AddCount( 1 )
		
		elseif not self:IsBlacklisted( v ) then
		
			local pnl = vgui.Create( "ItemPanel" )
			pnl:SetItemTable( item.GetByID( v ) )
			pnl:SetCount( 1 )
			pnl:SetPriceScale( self.PriceScale )
			pnl:SetStashable( self.Stashable, self.StashStyle )
			pnl:SetSizeOverride( self:GetItemPnlSize() ) //bigg0r
		
			self:AddItem( pnl )
		
		end
		
	end
	
	if #tbl < 1 then
	
		self:InvalidateLayout()
	
	end
	
	if self.StashButton then
	
		self.StashButton:Remove()
		self.StashButton = nil
		
	end
	
	if self.CashBox then
	
		self.CashBox:Remove()
		self.CashBox = nil
	
	end
	
	if self.CashButton then
	
		self.CashButton:Remove()
		self.CashButton = nil
		
	end
	
	if self.StashStyle != "Buy" then
	
		self.CashBox = vgui.Create( "DNumberWang", self )
		self.CashBox:SetDecimals( 0 )
		self.CashBox:SetValue( math.max( self:GetCash(), 5 ) )
		self.CashBox:SetMinMax( 5, math.max( self:GetCash(), 5 ) )
		self.CashBox:SetWide( 80 )
		
		self.CashButton = vgui.Create( "DButton", self )
		
		if self.StashStyle == "Take" then
		
			self.CashButton:SetText( self.StashStyle )
			self.CashButton.OnMousePressed = function()
				
				RunConsoleCommand( "cash_take", math.min( tonumber( self.CashBox:GetValue() ) or 0, self:GetCash() ) )
				
			end
		
		elseif self.StashStyle == "Stash" and self.Stashable then
		
			self.CashButton:SetText( self.StashStyle )
			self.CashButton.OnMousePressed = function()
				
				RunConsoleCommand( "cash_stash", math.min( tonumber( self.CashBox:GetValue() ) or 0, self:GetCash() ) )
				
			end
		
		else
		
			self.CashButton:SetText( "Drop" )
			self.CashButton.OnMousePressed = function()
				
				RunConsoleCommand( "cash_drop", math.min( tonumber( self.CashBox:GetValue() ) or 0, self:GetCash() ) )
				
			end
		
		end
	
	end
	
	if ( self.StashStyle == "Stash" or self.StashStyle == "Take" ) and not self.IsLocalInv and #self:GetItems() > 0 then
		
		self.StashButton = vgui.Create( "DButton", self )
		self.StashButton:SetText( "Take All" )
		self.StashButton.OnMousePressed = function()
			
			if #self:GetItems() < 1 then return end

			for k,v in pairs( self:GetItems() ) do
				
				RunConsoleCommand( "inv_take", v:GetID(), v:GetCount() )
				
			end
		
		end
	
	end

end

function PANEL:Think()

	if self.CashBox then

		if self:GetCash() < 5 then
	
			self.CashBox:SetMinMax( 5, 5 )
			self.CashBox:SetValue( 5 )
			self.CashButton:SetDisabled( true )
			
		else
		
			self.CashBox:SetMinMax( 5, math.max( self:GetCash(), 5 ) )
			self.CashButton:SetDisabled( false )
		
		end
		
	end

end

function PANEL:AddScroll( amt )
	
	self.ScrollAmt = self.ScrollAmt + amt
	
	self.pnlCanvas:SetPos( 0, self.ScrollAmt * self:GetItemPnlSize() )

end

function PANEL:OnVScroll( offset )

	self.pnlCanvas:SetPos( 0, offset )

end

function PANEL:PerformLayout()

	local wide = self:GetWide()
	
	if ( !self.Rebuild ) then
		debug.Trace()
	end
	
	self:Rebuild()

	self.pnlCanvas:SetPos( 0, self.ScrollAmt * self:GetItemPnlSize() )
	self.pnlCanvas:SetWide( wide )
	
	self:Rebuild()

end

function PANEL:Rebuild()

	local Offset = 0
	
	if ( self.Horizontal ) then
	
		local x, y = self.Padding, self.Padding
		
		for k, panel in pairs( self.Items ) do
		
			if ( panel:IsVisible() ) then
			
				local w = self:GetItemPnlSize()
				local h = self:GetItemPnlSize()
				
				if ( x + w  > self:GetWide() ) then // move down
				
					x = self.Padding
					y = y + h + self.Spacing
				
				end
				
				panel:SetPos( x, y )
				
				x = x + w + self.Spacing
				Offset = y + h + self.Spacing
			
			end
		
		end
	
	else
	
		for k, panel in pairs( self.Items ) do
		
			if ( panel:IsVisible() ) then
				
				if ( self.m_bNoSizing ) then
					panel:SizeToContents()
					panel:SetPos( (self:GetCanvas():GetWide() - panel:GetWide()) * 0.5, self.Padding + Offset )
				else
					panel:SetSize( self:GetCanvas():GetWide() - self.Padding * 2, panel:GetTall() )
					panel:SetPos( self.Padding, self.Padding + Offset )
				end
		
				panel:InvalidateLayout( true )
				
				Offset = Offset + panel:GetTall() + self.Spacing
				
			end
		
		end
		
		Offset = Offset + self.Padding
		
	end
	
	self:GetCanvas():SetTall( self:GetTall() + Offset - self.Spacing ) 

	if ( self.m_bNoSizing and self:GetCanvas():GetTall() < self:GetTall() ) then

		self:GetCanvas():SetPos( 0, (self:GetTall()-self:GetCanvas():GetTall()) * 0.5 )
	
	end
	
	if self.StashButton then
	
		self.StashButton:SetSize( 48, 20 )
		self.StashButton:SetPos( self:GetWide() - self:GetPadding() * 2 - self.StashButton:GetWide(), self:GetTall() - self:GetPadding() * 2 - self.StashButton:GetTall() )
	
	end
	
	if self.CashBox then
	
		self.CashBox:SetPos( self:GetPadding() * 2, self:GetTall() - ( self:GetPadding() * 2 ) - 20 )
	
	end
	
	if self.CashButton then
	
		self.CashButton:SetSize( 48, 20 )
		self.CashButton:SetPos( ( self:GetPadding() * 2 ) + 5 + self.CashBox:GetWide(), self:GetTall() - ( self:GetPadding() * 2 ) - 20 )
	
	end
	
end

function PANEL:Paint()

	//draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	//draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 100 ) )
	
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 180 ) )
	
	if self.StashStyle == "Buy" then return end
	
	draw.SimpleText( "Cash: $" .. self:GetCash(), "ItemDisplayFont", self:GetPadding() * 2, self:GetTall() - ( self:GetPadding() * 2 ) - 35, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	
	//draw.TexturedQuad( { texture = surface.GetTextureID( "radbox/menu_trade" ), x = self:GetPadding() * 2, y = self:GetTall() - ( self:GetPadding() * 2 ) - 40, w = 40, h = 40, color = Color( 200, 200, 200 ) } )

end

derma.DefineControl( "ItemSheet", "A sheet for storing HUD elements", PANEL, "DPanelList" )
