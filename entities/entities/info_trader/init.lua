ENT.Type 			= "point"
ENT.Base 			= "base_point"

ENT.BuybackScale = 1.0

function ENT:Initialize()

	self.Items = {}
	
	self.Entity:GenerateInventory()

end

function ENT:GenerateInventory()
	
	for k,v in pairs( item.GetByType( ITEM_SUPPLY ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_BUYABLE ) ) do
	
		self.Entity:AddItem( v.ID)
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_MISC ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_AMMO ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end
	
	if self.Special then
	
		for k,v in pairs( item.GetByType( ITEM_SPECIAL ) ) do
	
			self.Entity:AddItem( v.ID )
	
		end
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_WPN_COMMON ) ) do
	
		self.Entity:AddItem( v.ID )
	
	end
	
	if self.Special then
	
		for k,v in pairs( item.GetByType( ITEM_WPN_SPECIAL ) ) do
		
			self.Entity:AddItem( v.ID )
		
		end
		
	end

end

function ENT:SetSpecial( bool )

	self.Special = bool

end

function ENT:GetBuybackScale() 

	return self.BuybackScale

end

function ENT:GetItems()

	return self.Items
	
end

function ENT:AddItem( id )

	self.Items = self.Items or {}

	table.insert( self.Items, id )

end

function ENT:Think() 
	
end 

function ENT:OnUsed( ply )
	
	ply.Stash = self.Entity
	ply:ToggleStashMenu( self.Entity, true, "StoreMenu", self.Entity:GetBuybackScale() )

end

function ENT:OnExit( ply )
	
	ply:ToggleStashMenu( self.Entity, false, "StoreMenu", self.Entity:GetBuybackScale() )
	ply.Stash = nil

end

