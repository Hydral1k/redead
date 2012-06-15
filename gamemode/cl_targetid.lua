
TargetedEntity = nil

local TargetedName = nil
local TargetedTime = 0
local TargetedDist = Vector(0,0,0)

ValidTargetEnts = { "prop_physics", "sent_oxygen", "sent_fuel_diesel", "sent_fuel_gas", "sent_propane_tank", "sent_propane_canister" }

function GM:GetEntityID( ent )
	
	if table.HasValue( ValidTargetEnts, ent:GetClass() ) then
	
		local tbl = item.GetByModel( ent:GetModel() )
		
		if tbl then
	
			TargetedName = tbl.Name
			TargetedEntity = ent
			TargetedTime = CurTime() + 5
			TargetedDist = Vector( 0, 0, TargetedEntity:OBBCenter():Distance( TargetedEntity:OBBMaxs() ) )
		
		end
		
	elseif ent:GetClass() == "sent_droppedgun" then
	
		local tbl = item.GetByModel( ent:GetModel() )
		
		if tbl then
	
			TargetedName = tbl.Name
			TargetedEntity = ent
			TargetedTime = CurTime() + 5
			TargetedDist = Vector( 0, 0, 10 )
		
		end
	
	elseif ent:GetClass() == "sent_lootbag" then
	
		TargetedName = "Loot"
		TargetedEntity = ent
		TargetedTime = CurTime() + 5
		TargetedDist = Vector( 0, 0, 10 )
		
	elseif ent:GetClass() == "sent_cash" then
	
		TargetedName = ent:GetNWInt( "Cash", 10 ) .. " " .. GAMEMODE.CurrencyName .. "s"
		TargetedEntity = ent
		TargetedTime = CurTime() + 5
		TargetedDist = Vector( 0, 0, 5 )
	
	elseif ent:GetClass() == "sent_antidote" then
	
		TargetedName = "Antidote Crate"
		TargetedEntity = ent
		TargetedTime = CurTime() + 5
		TargetedDist = Vector( 0, 0, 15 )
		
	elseif ent:GetClass() == "sent_supplycrate" then
	
		TargetedName = "Supply Crate"
		TargetedEntity = ent
		TargetedTime = CurTime() + 5
		TargetedDist = Vector( 0, 0, 15 )
	
	elseif ent:IsPlayer() and ent:Team() == TEAM_ARMY then
	
		TargetedName = ent:Name()
		TargetedEntity = ent
		TargetedTime = CurTime() + 5
		TargetedDist = Vector( 0, 0, 40 )
	
	end
	
end

function GM:HUDDrawTargetID()

	if not ValidEntity( LocalPlayer() ) then return end
	
	if not LocalPlayer():Alive() or LocalPlayer():Team() == TEAM_ZOMBIES then return end
	
	local tr = util.TraceLine( util.GetPlayerTrace( LocalPlayer() ) )
	
	if ValidEntity( tr.Entity ) and tr.Entity:GetPos():Distance( LocalPlayer():GetPos() ) < 1000 then
	
		GAMEMODE:GetEntityID( tr.Entity )
		
	end
	
	if ValidEntity( TargetedEntity ) and TargetedTime > CurTime() then
	
		local worldpos = TargetedEntity:LocalToWorld( TargetedEntity:OBBCenter() ) + TargetedDist
		local pos = ( worldpos ):ToScreen()
		
		//print( TargetedName .. " " .. tostring(TargetedDist) .. tostring(pos.visible) .. " - " .. pos.x .. " n " .. pos.y )
		
		if pos.visible then
			
			draw.SimpleText( TargetedName or "Error", "AmmoFontSmall", pos.x, pos.y, Color( 80, 150, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
		end
	
	end

end
