
resource.AddFile( "materials/radbox/radar.vmt" )
resource.AddFile( "materials/radbox/radar_back.vtf" )
resource.AddFile( "resource/fonts/Graffiare.ttf" )
resource.AddFile( "resource/fonts/typenoksidi.ttf" )
resource.AddFile( "models/Zed/male_shared.mdl" )
resource.AddFile( "sound/nuke/redead/lastminute.mp3" )

for i=1,10 do

	resource.AddFile( "materials/toxsin/Blood" .. i .. ".vmt" )

end

for i=1,4 do

	for e=1,5 do
	
		resource.AddFile( "materials/models/Zed/Male/g" .. i .. "_0" .. e .. "_sheet.vmt" )
		
	end
	
end

local include_sound = { "warning",
"heartbeat",
"geiger_1",
"geiger_2",
"geiger_3",
"geiger_4",
"geiger_5",
"geiger_6",
"geiger_7",
"geiger_8",
"gore/blood01",
"gore/blood02",
"gore/blood03",
"gore/carnage01",
"gore/carnage02",
"gore/carnage03",
"gore/carnage04",
"gore/carnage05",
"gore/die01",
"gore/die02",
"gore/die03",
"gore/die04",
"gore/die05",
"gore/pain01",
"gore/pain02",
"gore/pain03",
"gore/pain04",
"gore/pain05",
"redead/attack_1",
"redead/attack_2",
"redead/attack_3",
"redead/attack_4",
"redead/attack_5",
"redead/attack_6",
"redead/death_1",
"redead/death_2",
"redead/death_3",
"redead/death_4",
"redead/death_5",
"redead/death_6",
"redead/pain_1",
"redead/pain_2",
"redead/pain_3",
"redead/pain_4",
"redead/pain_5",
"redead/pain_6",
"redead/idle_1",
"redead/idle_2",
"redead/idle_3",
"redead/idle_4",
"redead/idle_5",
"redead/idle_6",
"redead/idle_7",
"redead/idle_8" }

for k,v in pairs( include_sound ) do

	resource.AddFile( "sound/nuke/" .. v .. ".wav" )

end

local include_mat = { "models/weapons/v_models/shot_m3super91/shot_m3super91_norm",
"models/weapons/v_models/shot_m3super91/shot_m3super91_2_norm",
"models/weapons/v_models/shot_m3super91/shot_m3super91",
"models/weapons/v_models/shot_m3super91/shot_m3super91_2",
"models/weapons/temptexture/handsmesh1",
"models/weapons/axe",
"models/weapons/hammer",
"models/weapons/hammer2",
"models/ammoboxes/smg",
"models/Zed/Male/pupil_l",
"models/Zed/Male/pupil_r",
"models/Zed/Male/eyeball_r",
"models/Zed/Male/eyeball_l",
"models/Zed/Male/dark_eyeball_l",
"models/Zed/Male/dark_eyeball_r",
"models/Zed/Male/mouth",
"models/Zed/Male/glint",
"models/Zed/Male/citizen_sheet",
"models/Zed/Male/blood_sheet",
"models/Zed/Male/grey_sheet",
"models/Zed/Male/service_sheet",
"models/Zed/Male/plaid_sheet",
"models/Zed/Male/jackson_sheet",
"models/Zed/Male/sandro_facemap",
"models/Zed/Male/joe_facemap",
"models/Zed/Male/eric_facemap",
"models/Zed/Male/vance_facemap",
"nuke/redead/noise01",
"nuke/redead/noise02",
"nuke/redead/noise03",
"nuke/redead/commando",
"nuke/redead/engineer",
"nuke/redead/scout",
"nuke/redead/specialist",
"nuke/redead/zomb_zombie",
"nuke/redead/zomb_corpse",
"nuke/redead/zomb_banshee",
"nuke/redead/allyvision",
"nuke/gore1",
"nuke/gore2",
"radbox/radar_arm",
"radbox/radar_arrow",
"radbox/menu_quest",
"radbox/menu_loot",
"radbox/menu_trade",
"radbox/menu_cancel",
"radbox/nvg_noise",
"radbox/img_radiation",
"radbox/img_blood",
"radbox/img_health",
"radbox/img_stamina",
"radbox/img_infect",
"radbox/healthpack",
"radbox/healthpack2",
"radbox/bandage" }

for k,v in pairs( include_mat ) do

	resource.AddFile( "materials/" .. v .. ".vmt" )

end

local include_model = { "weapons/v_shot_m3super91",
"weapons/w_hammer",
"weapons/w_axe",
"weapons/v_hammer/v_hammer",
"weapons/v_axe/v_axe",
"items/boxqrounds",
"radbox/bandage",
"radbox/geiger",
"radbox/healthpack",
"radbox/healthpack2",
"Zed/malezed_04",
"Zed/malezed_06",
"Zed/malezed_08",
"Zed/weapons/v_undead",
"Zed/weapons/v_ghoul",
"Zed/weapons/v_banshee" }

for k,v in pairs( include_model ) do

	resource.AddFile( "models/" .. v .. ".mdl" )

end

