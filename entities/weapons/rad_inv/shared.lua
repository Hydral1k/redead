if SERVER then

	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Quick Inventory"
	SWEP.IconLetter = "H"
	SWEP.Slot = 0
	SWEP.Slotpos = 1
	
end

SWEP.HoldType = "normal"
SWEP.Base = "rad_base"

SWEP.ViewModel			= ""
SWEP.WorldModel			= ""

SWEP.IsSniper = false
SWEP.AmmoType = "Knife"

SWEP.Primary.ClipSize		= 1

SWEP.Scroll = Sound( "ui/buttonrollover.wav" )
SWEP.Selection = Sound( "ui/buttonclickrelease.wav" )
SWEP.Cancel = Sound( "common/wpn_denyselect.wav" )

SWEP.YPos = 10
SWEP.XPos = 10
SWEP.NumPanels = 5
SWEP.PanelSize = 80

function SWEP:Holster()

	if SERVER then return true end
	
	if self.Deployed then
	
		self.Deployed = false
		
		self.Weapon:RemovePanels()
	
	end

	return true

end

function SWEP:Deploy()

	if SERVER then 
	
		self.Weapon:SetNWInt( "InvPos", 1 )
		self.Weapon:SetNWBool( "Synch", false )
		self.Weapon:SetNWBool( "UseMode", false )
	
		self.Owner:SynchInventory()
		
		self.Owner:NoticeOnce( "Right click to scroll through your inventory", GAMEMODE.Colors.Blue, 5, 2 )  
		self.Owner:NoticeOnce( "Left click to select an item and use it", GAMEMODE.Colors.Blue, 5, 4 )  
	
		return true 
		
	end
	
	if not self.Deployed then
	
		self.Deployed = true
		self.LastInv = Inv_Size()
		self.InvPos = 1
		
		self.Weapon:GeneratePanels()
	
	end
	
	return true 
	
end

function SWEP:GeneratePanels()

	self.InvPanels = {}
	self.YPosTbl = {}
	self.InvItems = Inv_UniqueItems()
	
	if Inv_Size() == 0 then return end
	
	for i=1, math.min( self.NumPanels, #self.InvItems ) do
		
		local id = self.Weapon:GetNWInt( "InvPos", 1 ) + i - 1
		
		if id > #self.InvItems then
		
			id = math.Clamp( id - #self.InvItems, 1, #self.InvItems )
		
		end
		
		local panel = vgui.Create( "ItemPanel" )
		panel:SetItemTable( item.GetByID( self.InvItems[id] ) )
		
		if i == 1 then
			
			panel:SetPos( -self.PanelSize, self.YPos )
			panel:SetSize( self.PanelSize * 1.5, self.PanelSize * 1.5 )
			panel:SetSizeOverride( self.PanelSize * 1.5 )
			panel.YPos = self.YPos
			
		else
			
			panel:SetPos( -self.PanelSize, self.YPos + ( self.PanelSize * ( i - 1 ) ) + ( self.PanelSize * 1.5 ) + ( 5 * i ) )
			panel:SetSize( self.PanelSize, self.PanelSize )
			panel:SetSizeOverride( self.PanelSize )
			panel.YPos = self.YPos + ( self.PanelSize * ( i - 2 ) ) + ( self.PanelSize * 1.5 ) + ( 5 * i )
			
		end
		
		self.YPosTbl[i] = panel.YPos
		
		table.insert( self.InvPanels, panel )
		
	end

end

function SWEP:AddPanel() // call after removing a panel

	local id = self.Weapon:GetNWInt( "InvPos", 1 ) - 1
	local inv = Inv_UniqueItems()
	
	if id < 1 then
	
		id = #inv
	
	end

	local i = #self.InvPanels
	local tbl = item.GetByID( inv[id] )
	
	local panel = vgui.Create( "ItemPanel" )
	panel:SetItemTable( tbl )
	panel:SetPos( -self.PanelSize, self.YPosTbl[ i + 1 ] )
	panel:SetSize( self.PanelSize, self.PanelSize )
	panel:SetSizeOverride( self.PanelSize )
	panel.YPos = self.YPosTbl[ i + 1 ]
	
	table.insert( self.InvPanels, panel )
	
end

function SWEP:RemovePanels()

	for k,v in pairs( self.InvPanels ) do
		
		v:Remove()
	
	end
	
	self.InvPanels = {}
	self.InvItems = {}
	self.YPosTbl = {}

end

function SWEP:RemovePanel()

	if not self.InvPanels[1] then return end
	
	self.InvPanels[1].Removal = true

end

function SWEP:RemoveAllPanels()

	for k,v in pairs( self.InvPanels ) do
	
		v.Removal = true
	
	end

end

function SWEP:SecondaryAttack()

	if CLIENT then return end
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
	
	if self.Weapon:GetNWBool( "UseMode", false ) then
	
		local inv = self.Owner:GetUniqueInventory()
		local pos = self.Weapon:GetNWInt( "InvPos", 1 )
		local tbl = item.GetByID( inv[pos] )
	
		self.Weapon:SetNWInt( "FuncPos", self.Weapon:GetNWInt( "FuncPos", 1 ) + 1 )
		
		if tbl.Weapon then
		
			if self.Weapon:GetNWInt( "FuncPos", 1 ) > 2 then
			
				self.Weapon:SetNWInt( "FuncPos", 1 )
			
			end
			
			return
		
		end
		
		if self.Weapon:GetNWInt( "FuncPos", 1 ) > ( #self.Functions + 2 ) then
		
			self.Weapon:SetNWInt( "FuncPos", 1 )
		
		end
	
	else
	
		local size = #self.Owner:GetUniqueInventory()
		local pos = self.Weapon:GetNWInt( "InvPos", 1 ) + 1
		
		if pos > size then
			
			pos = 1
			
		end
		
		self.Weapon:SetNWInt( "InvPos", pos )
		
	end
	
	self.Owner:ClientSound( self.Scroll )

end

function SWEP:PrimaryAttack()

	if CLIENT then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
	
	local inv = self.Owner:GetUniqueInventory()
	local pos = self.Weapon:GetNWInt( "InvPos", 1 ) 
	local tbl = item.GetByID( inv[pos] )
	
	if not tbl then return end
	
	if self.Weapon:GetNWBool( "UseMode", false ) then

		local fpos = self.Weapon:GetNWInt( "FuncPos", 1 )
		
		if tbl.Weapon then
		
			if fpos == 1 then
			
				self.Owner:ClientSound( self.Cancel )
			
			else
			
				self.Functions[1]( self.Owner, tbl.ID )
			
			end
			
			self.Weapon:SetNWBool( "UseMode", false )
			self.Weapon:SetNWInt( "FuncPos", 1 )
			self.Weapon:SetNWInt( "InvPos", 1 )
			self.Weapon:Synch()
		
			return
		
		end
		
		if fpos == 1 then
			
			self.Owner:ClientSound( self.Cancel )
		
		elseif fpos == 2 then
		
			self.Weapon:DropItem( tbl.ID, 1 )
		
		else
		
			self.Functions[ fpos - 2 ]( self.Owner, tbl.ID )
		
		end
		
		self.Weapon:SetNWBool( "UseMode", false )
		self.Weapon:SetNWInt( "FuncPos", 1 )
		self.Weapon:SetNWInt( "InvPos", 1 )
		self.Weapon:Synch()
		
	else
	
		self.Weapon:SetNWBool( "UseMode", !self.Weapon:SetNWBool( "UseMode", false ) )
		
		self.Functions = tbl.Functions
		
		self.Owner:ClientSound( self.Selection )
	
	end
	
end

function SWEP:DropItem( id, count )
	
	if not self.Owner:HasItem( id ) then return end
	
	local tbl = item.GetByID( id )
	
	if count == 1 then
	
		if self.Owner:HasItem( id ) then
		
			local makeprop = true
		
			if tbl.DropFunction then
			
				makeprop = tbl.DropFunction( self.Owner, id, true )
			
			end
			
			if makeprop then
		
				local prop = ents.Create( "prop_physics" )
				prop:SetPos( self.Owner:GetItemDropPos() )
				prop:SetAngles( self.Owner:GetAimVector():Angle() )
				prop:SetModel( tbl.Model ) 
				prop:SetCollisionGroup( COLLISION_GROUP_WEAPON )
				prop:Spawn()
				prop.IsItem = true
				prop.Removal = CurTime() + 5 * 60
				
			end
			
			self.Owner:RemoveFromInventory( id, true )
			self.Owner:EmitSound( Sound( "items/ammopickup.wav" ) )
		
		end
		
		return
	
	end
	
	local items = {}
	
	for i=1, count do
	
		if self.Owner:HasItem( id ) then
		
			table.insert( items, id )
		
		end
		
	end
	
	local loot = ents.Create( "sent_lootbag" )
	
	for k,v in pairs( items ) do
	
		loot:AddItem( v )
	
	end
	
	loot:SetAngles( self.Owner:GetAimVector():Angle() )
	loot:SetPos( self.Owner:GetItemDropPos() )
	loot:SetRemoval( 60 * 5 )
	loot:Spawn()
	
	self.Owner:EmitSound( Sound( "items/ammopickup.wav" ) )
	self.Owner:RemoveMultipleFromInventory( items )
	
	if tbl.DropFunction then
		
		tbl.DropFunction( self.Owner, id )
		
	end

end

function SWEP:Synch()

	umsg.Start( "InvSWEP", self.Owner ) 
	umsg.End()
	
end

function RecvSynch()

	InvSWEPSynch = true

end
usermessage.Hook( "InvSWEP", RecvSynch )

function SWEP:Think()	

	if SERVER then return end
	
	if not self.Deployed then return end
	
	local removing = false
	
	if InvSWEPSynch or self.LastInv != Inv_Size() then
	
		removing = true
		InvSWEPSynch = false
		
		self.Weapon:RemoveAllPanels()
	
	end
	
	self.LastInv = Inv_Size()
	
	if #self.InvPanels < 1 then
	
		self.Weapon:GeneratePanels()
	
	end
	
	if removing then return end
	
	if self.Shuffle and #self.InvPanels < 5 then
	
		for k,v in pairs( self.InvPanels ) do
		
			v.YPos = self.YPosTbl[k]
		
		end
		
		self.Weapon:AddPanel()
		
		self.Shuffle = false
	
	end
	
	if self.InvPos != self.Weapon:GetNWInt( "InvPos", 1 ) then
	
		self.InvPos = self.Weapon:GetNWInt( "InvPos", 1 )
		
		self.Weapon:RemovePanel()
	
	end
	
end

function SWEP:DrawOption( i, name )

	surface.SetFont( "InventoryFont" )
	
	local w,h = surface.GetTextSize( name )
	local col = Color( 255, 255, 255 )
	
	if i == self.Weapon:GetNWInt( "FuncPos", 1 ) then
	
		col = Color( 50, 255, 50 )
	
	end

	draw.RoundedBox( 4, self.PanelSize * 1.5 + 20, 12 + ( i - 1 ) * 25, w + 8, h, Color( 0, 0, 0, 200 ) )
	draw.SimpleText( name, "InventoryFont", self.PanelSize * 1.5 + 24 + ( w * 0.5 ), 12 + ( i - 1 ) * 25 + ( h * 0.5 ), col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

function SWEP:DrawHUD()

	if self.Weapon:GetNWBool( "UseMode", false ) then
	
		local inv = Inv_UniqueItems()
		local tbl = item.GetByID( inv[ self.Weapon:GetNWInt( "InvPos", 1 ) ] )
		
		if not tbl then return end
		
		if tbl.Weapon then
		
			self.Weapon:DrawOption( 1, "cancel" )
			self.Weapon:DrawOption( 2, "drop" )
			
			return
		
		end
		
		for i=1, #tbl.Functions + 2 do
		
			if i == 1 then
			
				self.Weapon:DrawOption( i, "cancel" )
			
			elseif i == 2 then
			
				self.Weapon:DrawOption( i, "drop" )
			
			else
			
				self.Weapon:DrawOption( i, string.lower( tbl.Functions[ i - 2 ]( 0, 0, true ) ) )
			
			end
		
		end
	
	end
	
	for k,v in pairs( self.InvPanels or {} ) do
	
		v.LastX = math.Clamp( math.max( ( v.LastX or self.PanelSize + self.XPos ) - ( FrameTime() * 700 ), 1 ), 0, self.PanelSize + self.XPos )
		v.LastY = math.Clamp( math.max( ( v.LastY or self.YPos ) - ( FrameTime() * 700 ), 1 ), 0, self.PanelSize + self.YPos )
		
		if v.LastX != 0 or v.LastY != 0 then // automatically bring the panel into the screen
	
			v:SetPos( self.XPos - v.LastX, v.YPos - v.LastY )
			
			if v.YPos == self.YPosTbl[1] then
			
				v:SetSize( self.PanelSize * 1.5, self.PanelSize * 1.5 )
				v:SetSizeOverride( self.PanelSize * 1.5 )
			
			end
			
		end
		
		if v.Removal then
		
			v.RemoveX = math.Clamp( ( v.RemoveX or self.XPos ) - ( FrameTime() * 700 ), -1 * ( self.PanelSize * 2 ), self.PanelSize + self.XPos )
		
			if v.RemoveX != -1 * ( self.PanelSize * 2 ) then
	
				v:SetPos( v.RemoveX, v.YPos )
			
			else
				
				v:Remove()
				
				table.remove( self.InvPanels, k )
				
				local all = true
				
				for c,d in pairs( self.InvPanels ) do
				
					if not d.Removal then
					
						all = false
					
					end
				
				end
				
				if not all then
				
					self.Shuffle = true
					
				end
				
				break
			
			end
		
		end
	
	end
	
end
