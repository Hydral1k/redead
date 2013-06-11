
AddCSLuaFile()

local PLAYER = {} 

function PLAYER:GetHandsModel()

	return { model = "models/weapons/c_arms_cstrike.mdl", skin = 1, body = "0100000" }

end

function PLAYER:Spawn()

end

player_manager.RegisterClass( "player_army", PLAYER, "player_baseclass" )