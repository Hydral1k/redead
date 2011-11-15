
LocalInventory = {}
LocalStash = {}
LocalStashCash = 0
PreviewStyle = "Stash"
PreviewPriceScale = 1

function Inv_HasItem( id )

	for k,v in pairs( LocalInventory ) do
	
		local tbl = item.GetByID( v )
	
		if ( type( id ) == "number" and tbl.ID == id ) or ( type( id ) == "string" and tbl.Model == id ) then
		
			return tbl
		
		end
	
	end

end

function Inv_ItemCount( id )

	local count = 0
	
	for k,v in pairs( LocalInventory ) do
	
		if v == id then
		
			count = count + 1
		
		end
	
	end
	
	return count

end

function Inv_Get( pos )

	return LocalInventory[ pos ]

end

function Inv_UniqueItems()

	local ids = {}
	
	for k,v in pairs( LocalInventory ) do
	
		if not table.HasValue( ids, v ) then
		
			table.insert( ids, v )
		
		end
	
	end
	
	return ids

end

function Inv_Size()

	return #LocalInventory

end

function Inv_GetStashCash()

	return LocalStashCash
	
end

function Inv_SetStashCash( amt )

	LocalStashCash = amt

end