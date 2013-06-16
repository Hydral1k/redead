
module( "item", package.seeall )

local ItemTables = {}
local ID = 1

function Register( tbl )
	
	tbl.Functions = tbl.Functions or {}
	tbl.ID = ID
	ItemTables[ ID ] = tbl
	
	util.PrecacheModel( tbl.Model )
	
	ID = ID + 1
	
end

function GetList()

	return ItemTables

end

function GetByID( id )

	if not id then return end
	
	if !ItemTables[ id ] then return end

	return ItemTables[ id ]
	
end

function GetByModel( model )
	
	for k,v in pairs( ItemTables ) do
		
		if string.lower( v.Model ) == string.lower( model ) or ( v.DropModel and string.lower( v.DropModel ) == string.lower( model ) ) then
		
			return v
		
		end
		
	end

end

function GetByClass( class )
	
	for k,v in pairs( ItemTables ) do
		
		if v.TypeOverride and string.lower( v.TypeOverride ) == string.lower( class ) then
		
			return v
		
		end
		
	end

end

function GetByName( name )

	for k,v in pairs( ItemTables ) do
		
		if string.lower( v.Name ) == string.lower( name ) then
		
			return v
		
		end
		
	end

end

function GetByType( itemtype )

	local tbl = {}
	
	for k,v in pairs( ItemTables ) do
		
		if v.Type == itemtype then
		
			table.insert( tbl, v )
		
		end
		
	end
	
	return tbl

end

function RandomItem( itemtype )

	if not itemtype then return table.Random( ItemTables ) end

	local tbl = GetByType( itemtype )
	local rand = table.Random( tbl )
	
	while math.Rand(0,1) < rand.Rarity do
	
		rand = table.Random( tbl )
	
	end

	return rand

end






