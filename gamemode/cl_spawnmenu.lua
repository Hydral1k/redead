
function GM:InitVGUI()
	
	InventoryScreen = vgui.Create( "ItemSheet" )
	InventoryScreen:SetSize( ScrW() * 0.5 - 10, ScrH() * 0.5 - 10 )
	InventoryScreen:SetPos( 5, ScrH() * 0.5 + 5 )
	InventoryScreen:SetSpacing( 2 )
	InventoryScreen:SetPadding( 3 )
	InventoryScreen:EnableHorizontal( true )
	InventoryScreen:SetVisible( false )
	
	InfoScreen = vgui.Create( "ItemDisplay" )
	InfoScreen:SetSize( ScrW() * 0.3 - 10, ScrH() * 0.5 - 5 )
	InfoScreen:SetPos( 5, 5 )
	InfoScreen:SetVisible( false )
	
	PlayerScreen = vgui.Create( "PlayerDisplay" )
	PlayerScreen:SetSize( ScrW() * 0.3 - 10, ScrH() * 0.5 - 5 )
	PlayerScreen:SetPos( ScrW() * 0.7 + 5, 5 )
	PlayerScreen:SetVisible( false )
	PlayerScreen:SetupCam( Vector(0,96,36), Vector(0,0,36) )
	
	StashScreen = vgui.Create( "ItemSheet" )
	StashScreen:SetSize( ScrW() * 0.5 - 10, ScrH() * 0.5 - 10 )
	StashScreen:SetPos( ScrW() * 0.5 + 5, ScrH() * 0.5 + 5 )
	StashScreen:SetSpacing( 2 )
	StashScreen:SetPadding( 3 )
	StashScreen:EnableHorizontal( true )
	StashScreen:SetVisible( false )
	StashScreen:SetStashable( true, "Take" )
	StashScreen.GetCash = function() return Inv_GetStashCash() end
	
	SaleScreen = vgui.Create( "ShopMenu" )
	SaleScreen:SetSize( ScrW() * 0.5 - 10, ScrH() * 0.5 - 10 )
	SaleScreen:SetPos( ScrW() * 0.5 + 5, ScrH() * 0.5 + 5 )
	SaleScreen:SetVisible( false )
	
end

function GM:OnSpawnMenuClose()
	
	if not LocalPlayer():Alive() or LocalPlayer():Team() != TEAM_ARMY then return end
	
	if StashScreen:IsVisible() then return end
	
	if not InventoryScreen:IsVisible() then
	
		InventoryScreen:SetSize( ScrW() - 10, ScrH() * 0.5 - 10 )
		InventoryScreen:SetStashable( false, "Stash", true )
		InventoryScreen:RefreshItems( LocalInventory )
		InventoryScreen:SetVisible( true )
		InfoScreen:SetVisible( true )
		PlayerScreen:SetVisible( true )
		
		gui.EnableScreenClicker( true )
	
	else
	
		InventoryScreen:SetVisible( false )
		InfoScreen:SetVisible( false )
		PlayerScreen:SetVisible( false )

		gui.EnableScreenClicker( false )
	
	end

end

function StashMenu( msg )

	local open = msg:ReadBool()
	
	if InventoryScreen:IsVisible() and open then return end
	
	StashScreen:SetPos( ScrW() * 0.5 + 5, ScrH() * 0.5 + 5 )
	StashScreen:SetStashable( open, "Take" )
	StashScreen:SetVisible( open )
	
	InventoryScreen:SetSize( ScrW() * 0.5 - 10, ScrH() * 0.5 - 10 )
	InventoryScreen:SetStashable( open, "Stash", true )
	InventoryScreen:RefreshItems( LocalInventory )
	InventoryScreen:SetVisible( open )
	InfoScreen:SetVisible( open )
	PlayerScreen:SetVisible( open )
	
	gui.EnableScreenClicker( open )
	
	if open then
	
		StashScreen:RefreshItems( LocalStash )
		
	end
	
end
usermessage.Hook( "StashMenu", StashMenu )

function StoreMenu( msg )

	local open = msg:ReadBool()
	local scale = msg:ReadFloat()
	
	if InventoryScreen:IsVisible() and open then return end
	
	ShopMenu = open
	
	StashScreen:SetPos( 5, ScrH() * 0.5 + 5 )
	StashScreen:SetStashable( open, "Buy" )
	StashScreen:SetVisible( open )
	
	SaleScreen:SetVisible( open )
	InfoScreen:SetVisible( open )
	PlayerScreen:SetVisible( open )
	
	gui.EnableScreenClicker( open )
	
	if open then
	
		StashScreen:RefreshItems( LocalStash )
		
		surface.PlaySound( table.Random( GAMEMODE.RadioBeep ) )
		
	end

end
usermessage.Hook( "StoreMenu", StoreMenu )

function GM:SetItemToPreview( id, style, scale )

	PreviewTable = item.GetByID( id ) //table.Copy( item.GetByID( id ) )
	
	if scale and style then
	
		PreviewStyle = style
		PreviewPriceScale = scale
		
	end

end

function GM:GetItemToPreview()

	return PreviewTable, PreviewStyle, PreviewPriceScale

end