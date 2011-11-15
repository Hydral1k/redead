
for i=1,10 do

	resource.AddFile( "materials/toxsin/Blood" .. i .. ".vmt" )

end

resource.AddFile( "materials/radbox/radar.vmt" )
resource.AddFile( "materials/radbox/radar_back.vtf" )
resource.AddFile( "resource/fonts/Graffiare.ttf" )
resource.AddFile( "resource/fonts/typenoksidi.ttf" )
resource.AddFile( "models/Zed/male_shared.mdl" )

resource.AddFile( "sound/radbox/warning.wav" )
resource.AddFile( "sound/radbox/heartbeat.wav" )
resource.AddFile( "sound/toxsin/blood01.wav" )
resource.AddFile( "sound/toxsin/blood02.wav" )
resource.AddFile( "sound/toxsin/blood03.wav" )
resource.AddFile( "sound/toxsin/carnage01.wav" )
resource.AddFile( "sound/toxsin/carnage02.wav" )
resource.AddFile( "sound/toxsin/carnage03.wav" )
resource.AddFile( "sound/toxsin/carnage04.wav" )
resource.AddFile( "sound/toxsin/carnage05.wav" )
resource.AddFile( "sound/toxsin/hit01.wav" )
resource.AddFile( "sound/toxsin/hit02.wav" )
resource.AddFile( "sound/toxsin/hit03.wav" )
resource.AddFile( "sound/toxsin/hit04.wav" )
resource.AddFile( "sound/toxsin/hit05.wav" )
resource.AddFile( "sound/toxsin/die01.wav" )
resource.AddFile( "sound/toxsin/die02.wav" )
resource.AddFile( "sound/toxsin/die03.wav" )
resource.AddFile( "sound/toxsin/die04.wav" )
resource.AddFile( "sound/toxsin/die05.wav" )
resource.AddFile( "sound/toxsin/pain01.wav" )
resource.AddFile( "sound/toxsin/pain02.wav" )
resource.AddFile( "sound/toxsin/pain03.wav" )
resource.AddFile( "sound/toxsin/pain04.wav" )
resource.AddFile( "sound/toxsin/pain05.wav" )
resource.AddFile( "sound/toxsin/lastminute.mp3" )

for i=1,8 do

	resource.AddFile( "sound/radbox/geiger_" .. i .. ".wav" )

end

for i=1,4 do

	for e=1,5 do
	
		resource.AddFile( "materials/models/Zed/Male/g" .. i .. "_0" .. e .. "_sheet.vmt" )
		
	end
	
end

local include_mat = { "materials/models/weapons/v_models/shot_m3super91/shot_m3super91_norm",
"materials/models/weapons/v_models/shot_m3super91/shot_m3super91_2_norm",
"materials/models/weapons/v_models/shot_m3super91/shot_m3super91",
"materials/models/weapons/v_models/shot_m3super91/shot_m3super91_2",
"materials/models/weapons/temptexture/handsmesh1",
"materials/models/weapons/axe",
"materials/models/weapons/hammer",
"materials/models/weapons/hammer2",
"materials/models/ammoboxes/smg",
"materials/models/Zed/Male/pupil_l",
"materials/models/Zed/Male/pupil_r",
"materials/models/Zed/Male/eyeball_r",
"materials/models/Zed/Male/eyeball_l",
"materials/models/Zed/Male/dark_eyeball_l",
"materials/models/Zed/Male/dark_eyeball_r",
"materials/models/Zed/Male/mouth",
"materials/models/Zed/Male/glint",
"materials/models/Zed/Male/citizen_sheet",
"materials/models/Zed/Male/blood_sheet",
"materials/models/Zed/Male/grey_sheet",
"materials/models/Zed/Male/service_sheet",
"materials/models/Zed/Male/plaid_sheet",
"materials/models/Zed/Male/jackson_sheet",
"materials/models/Zed/Male/sandro_facemap",
"materials/models/Zed/Male/joe_facemap",
"materials/models/Zed/Male/eric_facemap",
"materials/models/Zed/Male/vance_facemap",
"materials/toxsin/noise01",
"materials/toxsin/noise02",
"materials/toxsin/noise03",
"materials/toxsin/airdrop",
"materials/toxsin/commando",
"materials/toxsin/scout",
"materials/toxsin/specialist",
"materials/toxsin/zomb_zombie",
"materials/toxsin/zomb_corpse",
"materials/toxsin/zomb_banshee",
"materials/toxsin/gore1",
"materials/toxsin/gore2",
"materials/toxsin/allyvision",
"materials/radbox/radar_arm",
"materials/radbox/radar_arrow",
"materials/radbox/menu_quest",
"materials/radbox/menu_loot",
"materials/radbox/menu_trade",
"materials/radbox/menu_cancel",
"materials/radbox/nvg_noise",
"materials/radbox/img_radiation",
"materials/radbox/img_blood",
"materials/radbox/img_health",
"materials/radbox/img_stamina",
"materials/radbox/img_infect",
"materials/radbox/healthpack",
"materials/radbox/healthpack2",
"materials/radbox/bandage" }

for k,v in pairs( include_mat ) do

	resource.AddFile( v..".vmt" )
	resource.AddFile( v..".vtf" )

end

local include_model = { "models/weapons/v_shot_m3super91",
"models/weapons/w_hammer",
"models/weapons/w_axe",
"models/weapons/v_hammer/v_hammer",
"models/weapons/v_axe/v_axe",
"models/items/boxqrounds",
"models/radbox/bandage",
"models/radbox/geiger",
"models/radbox/healthpack",
"models/radbox/healthpack2",
"models/Zed/malezed_04",
"models/Zed/malezed_06",
"models/Zed/malezed_08",
"models/Zed/weapons/v_undead",
"models/Zed/weapons/v_ghoul",
"models/Zed/weapons/v_banshee" }

for k,v in pairs( include_model ) do

	resource.AddFile( v..".vvd" )
	resource.AddFile( v..".sw.vtx" )
	resource.AddFile( v..".mdl" )
	resource.AddFile( v..".dx80.vtx" )
	resource.AddFile( v..".dx90.vtx" )

end

