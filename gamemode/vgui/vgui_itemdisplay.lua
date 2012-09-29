local PANEL = {}

surface.CreateFont ( "ItemDisplayFont", { size = 12, weight = 300, antialias = true, additive = true, font = "Verdana" } )

function PANEL:Init()

	//self:ShowCloseButton( false )
	self:SetKeyboardInputEnabled( false )
	//self:SetDraggable( false ) 
	
	self.Text = "Click an item to see its description." 
	self.Title = "N/A"
	self.Style = "Stash"
	self.PriceScale = 1
	self.Price = 0
	self.Weight = 0
	
end

function PANEL:SetItemDesc( text, title, style, scale, price, weight )

	self.Text = text
	self.Title = title
	self.Style = style
	self.PriceScale = scale
	self.Price = price
	self.Weight = weight

end

function PANEL:SetModel( model, campos, origin )

	if not self.ModelPanel then
	
		self.ModelPanel = vgui.Create( "GoodModelPanel", self )
		
	end
	
	self.ModelPanel:SetModel( model )
	self.ModelPanel:SetCamPos( Vector(20,10,5) )
	self.ModelPanel:SetLookAt( Vector(0,0,0) )
	self.ModelPanel.LayoutEntity = function( this, ent ) end
	
	--[[if string.find( model, "models/weapons/w_" ) then
	
		self.ModelPanel.LayoutEntity = function( this, ent ) if IsValid( ent ) then ent:SetAngles( Angle( 0, 0, 0 ) ) end end
		
	else
	
		self.ModelPanel.LayoutEntity = function( this, ent ) if IsValid( ent ) then ent:SetAngles( Angle( 0, RealTime() * 10, 0 ) ) end end
	
	end]]
	
	if CamPosOverride then
	
		campos = CamPosOverride
	
	end
	
	if CamOrigOverride then
	
		origin = CamOrigOverride
	
	end
	
	if campos then
	
		self.ModelPanel:SetCamPos( campos )
		
	end
	
	if origin then
	
		self.ModelPanel:SetLookAt( origin )
		
	end
	
	self:InvalidateLayout()

end

function PANEL:OnMousePressed( mc )

end

function PANEL:Think()

	local tbl, style, scale = GAMEMODE:GetItemToPreview()
	
	if tbl then
		
		self:SetModel( tbl.Model, tbl.CamPos, tbl.CamOrigin )
		self:SetItemDesc( tbl.Description, tbl.Name, style, scale, tbl.Price, tbl.Weight )
		
		//GAMEMODE:SetItemToPreview()
		
	end

end

function PANEL:PerformLayout()
	
	if self.ModelPanel then
	
		local size = math.Min( self:GetWide(), self:GetTall() * 0.85 )
		local pos = ( self:GetWide() - size ) / 2
	
		self.ModelPanel:SetPos( pos, 25 )
		self.ModelPanel:SetSize( size, size )
	
	end

	self:SizeToContents()
	
end

function PANEL:GetPadding()

	return 5

end

function PANEL:Paint()

	//draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	//draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 100 ) )
	
	//draw.RoundedBox( 4, 10, ( self:GetTall() * 0.85 ) - 10, self:GetWide() - 20, self:GetTall() * 0.15, Color( 0, 0, 0, 255 ) )
	//draw.RoundedBox( 4, 11, ( self:GetTall() * 0.85 ) - 9, self:GetWide() - 22, self:GetTall() * 0.15 - 2, Color( 150, 150, 150, 150 ) )
	
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 180 ) )
	draw.RoundedBox( 0, 35, 40, self:GetWide() - 70, self:GetTall() - 80, Color( 80, 80, 80, 50 ) )
	
	surface.SetDrawColor( 200, 200, 200, 200 )
	surface.DrawOutlinedRect( 35, 40, self:GetWide() - 70, self:GetTall() - 80 )
	
	draw.SimpleText( self.Title or "N/A", "ItemDisplayFont", self:GetWide() * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	if self.Style != "Stash" then
	
		if not self.Price or self.Price == 0 then
			
			draw.SimpleText( "Cost: N/A", "ItemDisplayFont", self:GetWide() * 0.5, 25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
		else
		
			draw.SimpleText( "Cost: "..self.Price.." "..GAMEMODE.CurrencyName.."s", "ItemDisplayFont", self:GetWide() * 0.5, 25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
		end
		
	end
	
	draw.SimpleText( self.Text or "N/A", "ItemDisplayFont", self:GetWide() * 0.5, self:GetTall() - 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "ItemDisplay", "A HUD Element with a big model in the middle and a label", PANEL, "PanelBase" )
