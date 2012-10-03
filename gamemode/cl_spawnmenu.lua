
GM.Elements = {}
GM.Cart = {}
GM.CartItems = {}
GM.OptionPanels = {}

GM.Categories = { 
{ Name = "Weapons", Icon = "icon16/gun.png", Categories = { ITEM_WPN_COMMON, ITEM_WPN_SPECIAL } },
{ Name = "Ammunition", Icon = "icon16/package.png", Categories = { ITEM_AMMO } },
{ Name = "Supplies", Icon = "icon16/pill.png", Categories = { ITEM_SUPPLY, ITEM_SPECIAL } },
{ Name = "Miscellaneous", Icon = "icon16/bin.png", Categories = { ITEM_MISC, ITEM_BUYABLE } } 
}

function GM:CreateElement( name )

	local element = vgui.Create( name )
	
	table.insert( GAMEMODE.Elements, element )
	
	return element

end

function GM:AddToCart( tbl, amt )

	for i=1,amt do
	
		table.insert( GAMEMODE.Cart, tbl.ID )
		
		local btn = GAMEMODE:CreateElement( "SideButton" )
		btn:SetPos( 765, 5 + 35 * ( table.Count( GAMEMODE.Cart ) - 1 ) )
		btn:SetSize( 250, 30 )
		btn:SetImage( "icon16/cross.png" )
		btn:SetText( tbl.Name )
		btn:SetFunction( function() RunConsoleCommand( "inv_refund", tbl.ID ) btn:Remove() GAMEMODE:ClearCartItem( tbl.ID ) end )
		
		table.insert( GAMEMODE.CartItems, btn )
	
	end
	
	GAMEMODE:CheckCartButton()

end

function GM:RefreshCart()

	local cart = GAMEMODE.CartItems
	
	GAMEMODE.CartItems = {}
	
	for k,v in pairs( cart ) do
	
		if IsValid( v ) then
		
			table.insert( GAMEMODE.CartItems, v )
			
			v:SetPos( 765, 5 + 35 * ( table.Count( GAMEMODE.CartItems ) - 1 ) )
		
		end
	
	end

end

function GM:CheckCartButton()

	if GAMEMODE.CartButton then
	
		GAMEMODE.CartButton:Remove()
	
	end
	
	if table.Count( GAMEMODE.Cart ) < 1 then return end

	local btn = GAMEMODE:CreateElement( "SideButton" )
	btn:SetPos( 765, 5 + 35 * ( table.Count( GAMEMODE.Cart ) ) )
	btn:SetSize( 250, 30 )
	btn:SetImage( "icon16/cart.png" )
	btn:SetText( "Airdrop  Items" )
	btn:SetFunction( function() RunConsoleCommand( "ordershipment" ) GAMEMODE:ClearCart() btn:Remove() end )
	
	GAMEMODE.CartButton = btn

end

function GM:ClearCartItem( id )

	for k,v in pairs( GAMEMODE.Cart ) do
	
		if v == id then
		
			table.remove( GAMEMODE.Cart, k )
			
			GAMEMODE:RefreshCart()
			GAMEMODE:CheckCartButton()
			
			return
		
		end
	
	end

end

function GM:ClearCart()

	GAMEMODE.Cart = {}

	for k,v in pairs( GAMEMODE.CartItems ) do
	
		if IsValid( v ) then
		
			v:Remove()
		
		end
		
	end

end

function GM:ClearElements()

	for k,v in pairs( GAMEMODE.Elements ) do
	
		v:Remove()
		
	end
	
	GAMEMODE.Elements = {}

end

function GM:ElementsVisible()

	if GAMEMODE.Elements[1] then return true end
	
	return false

end

function GM:SetItemToPreview( id, style, scale, count )

	//print( debug.traceback() )

	PreviewTable = item.GetByID( id ) //table.Copy( item.GetByID( id ) )
	
	if scale and style then
	
		PreviewStyle = style
		PreviewPriceScale = scale
		
	end

	GAMEMODE:RebuildOptions( PreviewTable or {}, style, count or 1 )
	
end

function GM:GetItemToPreview()

	return PreviewTable, PreviewStyle, PreviewPriceScale

end

function GM:RebuildOptions( tbl, style, count )

	for k,v in pairs( GAMEMODE.OptionPanels ) do
	
		v:Remove()
	
	end
	
	local ypos = 400
	
	if style == "Buy" then
	
		for k,v in pairs{ 1, 3, 5, 10 } do
	
			if v == 1 or not tbl.Weapon then
	
				local btn = GAMEMODE:CreateElement( "SideButton" )
				btn:SetPos( 510, ypos )
				btn:SetSize( 250, 30 )
				btn:SetImage( "icon16/money.png" )
				
				if v == 1 then
					btn:SetText( "Buy" )
				else
					btn:SetText( "Buy  " .. v )
				end
				
				btn:SetFunction( function() RunConsoleCommand( "inv_buy", tbl.ID, v ) GAMEMODE:AddToCart( tbl, v ) end )
				
				table.insert( GAMEMODE.OptionPanels, btn )
				
				ypos = ypos + 5 + 30
				
			end
			
		end
	
	else
	
		for k,v in pairs{ 1, 3, 5, 10 } do
		
			if not tbl.Weapon and count >= v then
		
				local btn = GAMEMODE:CreateElement( "SideButton" )
				btn:SetPos( 510, ypos )
				btn:SetSize( 250, 30 )
				btn:SetImage( "icon16/arrow_down.png" )
					
				if v == 1 then
					btn:SetText( "Drop" )
				else
					btn:SetText( "Drop  " .. v )
				end
					
				btn:SetFunction( function() RunConsoleCommand( "inv_drop", tbl.ID, v ) end )
					
				table.insert( GAMEMODE.OptionPanels, btn )
					
				ypos = ypos + 5 + 30
			
			end
			
		end
		
		if count > 1 then
		
			local btn = GAMEMODE:CreateElement( "SideButton" )
			btn:SetPos( 510, ypos )
			btn:SetSize( 250, 30 )
			btn:SetImage( "icon16/box.png" )
			btn:SetText( "Drop  All"	)
			btn:SetFunction( function() RunConsoleCommand( "inv_drop", tbl.ID, count ) end )
			
			table.insert( GAMEMODE.OptionPanels, btn )
			
			ypos = ypos + 5 + 30
			
		end
		
		for k,v in pairs( tbl.Functions ) do
		
			local btn = GAMEMODE:CreateElement( "SideButton" )
			btn:SetPos( 510, ypos )
			btn:SetSize( 250, 30 )
			btn:SetImage( v( 0, 0, 0, true ) )
			btn:SetText( v( 0, 0, true ) )
			btn:SetFunction( function() RunConsoleCommand( "inv_action", tbl.ID, k ) end )
			
			table.insert( GAMEMODE.OptionPanels, btn )
				
			ypos = ypos + 5 + 30
		
		end
	
	end

end

function GM:OnSpawnMenuClose()
	
	if not LocalPlayer():Alive() or LocalPlayer():Team() != TEAM_ARMY then return end
	
	if GAMEMODE:ElementsVisible() then
	
		gui.EnableScreenClicker( false )
	
		GAMEMODE:ClearElements()
	
	else
	
		gui.EnableScreenClicker( true )
	
		local ypos = 5
	
		for k,v in pairs( GAMEMODE.Categories ) do
			
			local toggle = GAMEMODE:CreateElement( "CategoryButton" )
			toggle:SetPos( 510, ypos )
			toggle:SetText( v.Name )
			toggle:SetImage( v.Icon )
			toggle:SetSize( 250, 30 )
			toggle:SetSelectedState( true, true )
			toggle.OnToggle = function( pnl, bool )
			
				if GAMEMODE.ItemSheet then
					
					GAMEMODE.ItemSheet:ToggleVisible( v.Categories, bool )
					GAMEMODE.ItemSheet:RefreshItems( LocalInventory )
				
				end
			
			end
				
			ypos = ypos + 5 + 30
			
		end
		
		local inv = GAMEMODE:CreateElement( "ItemSheet" )
		inv:SetSize( 500, ScrH() - 125 )
		inv:SetPos( 5, 5 )
		inv:SetSpacing( 0 )
		inv:SetPadding( 0 )
		inv:EnableHorizontal( true )
		inv:SetStashable( false, "Stash", true )
		inv:RefreshItems( LocalInventory )
		//inv:EnableVerticalScrollbar()
		
		GAMEMODE.ItemSheet = inv
		
		local disp = GAMEMODE:CreateElement( "ItemDisplay" )
		disp:SetSize( 250, 250 )
		disp:SetPos( 510, 145 )
		
		local scrollup = GAMEMODE:CreateElement( "Scroller" )
		scrollup:SetSize( 30, 30 )
		scrollup:SetPos( 475, ScrH() - 115 )
		scrollup:SetTarget( inv )
		scrollup:SetImage( "icon16/arrow_up.png" )
		
		local scrolldown = GAMEMODE:CreateElement( "Scroller" )
		scrolldown:SetSize( 30, 30 )
		scrolldown:SetPos( 440, ScrH() - 115 )
		scrolldown:SetTarget( inv )
		scrolldown:SetScrollUp( false )
		scrolldown:SetImage( "icon16/arrow_down.png" )
	
	end
	
	--[[if not InventoryScreen:IsVisible() then
	
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
	
	end]]

end

function StoreMenu( msg )

	local open = msg:ReadBool()
	local scale = msg:ReadFloat()
	
	if GAMEMODE:ElementsVisible() then

		GAMEMODE:ClearElements()
	
	end	
	
	if open then
	
		gui.EnableScreenClicker( true )
	
		local ypos = 5
	
		for k,v in pairs( GAMEMODE.Categories ) do
			
			local toggle = GAMEMODE:CreateElement( "CategoryButton" )
			toggle:SetPos( 510, ypos )
			toggle:SetText( v.Name )
			toggle:SetImage( v.Icon )
			toggle:SetSize( 250, 30 )
			toggle:SetSelectedState( true, true )
			toggle.OnToggle = function( pnl, bool )
			
				if GAMEMODE.ItemSheet then
					
					GAMEMODE.ItemSheet:ToggleVisible( v.Categories, bool )
					GAMEMODE.ItemSheet:RefreshItems( LocalStash )
				
				end
			
			end
				
			ypos = ypos + 5 + 30
			
		end
		
		local inv = GAMEMODE:CreateElement( "ItemSheet" )
		inv:SetSize( 500, ScrH() - 125 )
		inv:SetPos( 5, 5 )
		inv:SetSpacing( 0 )
		inv:SetPadding( 0 )
		inv:EnableHorizontal( true )
		inv:SetStashable( open, "Buy" )
		inv:RefreshItems( LocalStash )
		//inv:EnableVerticalScrollbar()
		
		GAMEMODE.ItemSheet = inv
		
		local disp = GAMEMODE:CreateElement( "ItemDisplay" )
		disp:SetSize( 250, 250 )
		disp:SetPos( 510, 145 )
		
		local scrollup = GAMEMODE:CreateElement( "Scroller" )
		scrollup:SetSize( 30, 30 )
		scrollup:SetPos( 475, ScrH() - 115 )
		scrollup:SetTarget( inv )
		scrollup:SetImage( "icon16/arrow_up.png" )
		
		local scrolldown = GAMEMODE:CreateElement( "Scroller" )
		scrolldown:SetSize( 30, 30 )
		scrolldown:SetPos( 440, ScrH() - 115 )
		scrolldown:SetTarget( inv )
		scrolldown:SetScrollUp( false )
		scrolldown:SetImage( "icon16/arrow_down.png" )
		
		surface.PlaySound( table.Random( GAMEMODE.RadioBeep ) )
		
		local cart = GAMEMODE.Cart
		GAMEMODE.Cart = {}
		
		for k,v in pairs( cart ) do
		
			local tbl = item.GetByID( v )
		
			GAMEMODE:AddToCart( tbl, 1 )
			
		end
	
	else
	
		gui.EnableScreenClicker( false )
	
	end
	
	--[[ShopMenu = open
	
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
		
	end]]

end
usermessage.Hook( "StoreMenu", StoreMenu )

function GM:InitVGUI() //obsolete
	
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
	
	local ypos = 5
	
	for k,v in pairs( GAMEMODE.Categories ) do
	
		local toggle = vgui.Create( "CategoryButton" )
		toggle:SetPos( 5, ypos )
		toggle:SetText( v.Name )
		toggle:SetImage( v.Icon )
		toggle:SetSize( 500, 30 )
		
		ypos = ypos + 5 + 30
	
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

