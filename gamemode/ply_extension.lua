
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:Notice( text, col, len, delay )

	if delay then
	
		local function Notice( ply, col, len )
		
			if not IsValid( ply ) then return end
		
			umsg.Start( "ToxNotice", ply )
			umsg.String( text )
			umsg.Short( col.r )
			umsg.Short( col.g )
			umsg.Short( col.b )
			umsg.Short( len or 3 )
			umsg.End() 
			
		end
		
		timer.Simple( delay, function() Notice( self, col, len ) end )
		
		return
		
	end

	umsg.Start( "ToxNotice", self )
	umsg.String( text )
	umsg.Short( col.r )
	umsg.Short( col.g )
	umsg.Short( col.b )
	umsg.Short( len or 3 )
	umsg.End() 
	
end

function meta:NoticeOnce( text, col, len, delay )

	local crc = util.CRC( self:SteamID() .. text ) 
	
	if not table.HasValue( self.NoticeList or {}, crc ) then
	
		self:Notice( text, col, len, delay )
	
		self.NoticeList = self.NoticeList or {}
		table.insert( self.NoticeList, crc )
	
	end

end

function meta:DrawBlood()

	local num = math.random(1,3)
	
	umsg.Start( "BloodStain", self )
	umsg.Short( num )
	umsg.End()

end

function meta:ClientSound( snd, pitch )

	umsg.Start( "Radio", self )
	umsg.String( snd )
	umsg.Short( pitch or 100 )
	umsg.End()

	//self:SendLua( "LocalPlayer():EmitSound( \"" .. snd .. "\", 100, " .. ( pitch or 100 ) .. " )" ) 

end

function meta:VoiceSound( snd, lvl, pitch )

	if ( self.SoundDelay or 0 ) < CurTime() then
	
		self.SoundDelay = CurTime() + 1.25
		self:EmitSound( snd, lvl, pitch )
		
	end

end

function meta:RadioSound( vtype, override )

	if not self:Alive() then return end
	
	if ( ( self.RadioTimer or 0 ) < CurTime() or override ) then
	
		local sound = table.Random( GAMEMODE.Radio[ vtype ] )
		
		self:EmitSound( table.Random( GAMEMODE.VoiceStart ), math.random( 90, 110 ) )
		timer.Simple( 0.2, function() if IsValid( self ) then self:EmitSound( sound, 90 ) end end )
		timer.Simple( SoundDuration( sound ) + math.Rand( 0.6, 0.8 ), function() if IsValid( self ) then self:EmitSound( table.Random( GAMEMODE.VoiceEnd ), math.random( 90, 110 ) ) end end )
				
		self.RadioTimer = CurTime() + SoundDuration( sound ) + 1
	
	end

end

function meta:VoiceThink()

	if ( self.VoiceTbl[ VO_IDLE ] or 0 ) < CurTime() then
	
		if GAMEMODE.EvacAlert then
		
			self:RadioSound( VO_EVAC )
		
		else
	
			self:RadioSound( VO_IDLE )
			
		end
		
		self.VoiceTbl[ VO_IDLE ] = CurTime() + math.Rand( 120, 240 )
	
	end
	
	if ( self.VoiceTbl[ VO_ALERT ] or 0 ) < CurTime() then
	
		self.VoiceTbl[ VO_ALERT ] = CurTime() + math.Rand( 120, 240 )
	
		for k,v in pairs( ents.FindByClass( "npc_zombie*" ) ) do
		
			if v:GetPos():Distance( self:GetPos() ) < 100 then
			
				self:RadioSound( VO_ALERT )
			
			end
		
		end
	
	end

end

function meta:GetWeight()
	return 0//self:GetNWFloat( "Weight", 0 ) 
end

function meta:SetWeight( num )
	//self:SetNWFloat( "Weight", num )
end

function meta:AddWeight( num )
	//self:SetWeight( self:GetWeight() + num ) 
end

function meta:GetAmmo( ammotype )
	return self:GetNWInt( "Ammo"..ammotype, 0 ) 
end

function meta:SetAmmo( ammotype, num )
	self:SetNWInt( "Ammo"..ammotype, num )
end

function meta:AddAmmo( ammotype, num, dropfunc )

	self:SetAmmo( ammotype, self:GetAmmo( ammotype ) + num ) 
	
	for k,v in pairs( item.GetByType( ITEM_AMMO ) ) do
		
		if v.Ammo == ammotype and num < 0 and not dropfunc then
			
			local count = math.floor( self:GetAmmo( ammotype ) / v.Amount )
	
			while self:HasItem( v.ID ) and self:GetItemCount( v.ID ) > count do
				
				self:RemoveFromInventory( v.ID )
			
			end
		
		end
	
	end
	
end

function meta:GetStats()

	return self.Stats or {}

end

function meta:InitStats()

	self.Stats = {}

end

function meta:AddStat( name, count )

	count = count or 1
	
	self:SetStat( name, self:GetStat( name ) + count )

end

function meta:GetStat( name )

	return self.Stats[ name ] or 0
	
end

function meta:SetStat( name, count )

	self.Stats[ name ] = count
	
end

function meta:GetCash()
	return self:GetNWInt( "Cash", 0 ) 
end

function meta:SetCash( num )
	self:SetNWInt( "Cash", math.Clamp( num, -32000, 32000 ) )
end

function meta:AddCash( num )

	if self:Team() == TEAM_ZOMBIES then return end
	
	self:SetCash( self:GetCash() + num ) 
	
	if num < 0 then
	
		self:EmitSound( Sound( "Chain.ImpactSoft" ), 100, math.random( 90, 110 ) )
		self:AddStat( "Spent", -num )
		
	else
	
		if num > 1 then
	
			self:Notice( "+" .. num .. " " .. GAMEMODE.CurrencyName .. "s", GAMEMODE.Colors.Yellow )
			
		elseif num != 0 then
		
			self:Notice( "+" .. num .. " " .. GAMEMODE.CurrencyName, GAMEMODE.Colors.Yellow )
		
		end

	end
	
end

function meta:HasShotgun()

	local wep = self:GetActiveWeapon()
	
	if IsValid( wep ) then
	
		if wep.AmmoType == "Buckshot" or wep.WorldModel == "models/weapons/w_snip_awp.mdl" then
		
			return true
		
		end
	
	end
	
	return false

end

function meta:AddHeadshot()

	if self:HasShotgun() then return end

	self.Headshots = ( self.Headshots or 0 ) + 1
	
	self:AddStat( "Headshot" )
	
	if GAMEMODE.HeadshotCombos[ self.Headshots ] then
	
		self:Notice( self.Headshots .. " headshot combo", GAMEMODE.Colors.Blue )
		self:AddCash( GAMEMODE.HeadshotCombos[ self.Headshots ] ) 
	
	end

end

function meta:ResetHeadshots()

	self.Headshots = 0

end

function meta:ViewBounce( scale )
    self:ViewPunch( Angle( math.Rand( -0.2, -0.1 ) * scale, math.Rand( -0.05, 0.05 ) * scale, 0 ) )
end

function meta:GetStamina()
	return self:GetNWInt( "Stamina", 0 ) 
end

function meta:SetStamina( num )
	self:SetNWInt( "Stamina", math.Clamp( num, 0, 150 ) )
end

function meta:AddStamina( num )
	self:SetStamina( self:GetStamina() + num ) 
end

function meta:GetRadiation()
	return self:GetNWInt( "Radiation", 0 ) 
end

function meta:SetRadiation( num )
	self:SetNWInt( "Radiation", math.Clamp( num, 0, 5 ) )
end

function meta:AddRadiation( num )

	if self:Team() != TEAM_ARMY then return end
	
	if self:HasItem( "models/items/combine_rifle_cartridge01.mdl" ) and num > 0 then return end
	
	if num > 0 then
	
		self.PoisonFade = CurTime() + 30
		
		self:EmitSound( table.Random{ "Geiger.BeepLow", "Geiger.BeepHigh" }, 100, math.random( 90, 110 ) )
		
		self:NoticeOnce( "You have been irradiated", GAMEMODE.Colors.Red, 5 )
		self:NoticeOnce( "You can cure radiation sickness with vodka", GAMEMODE.Colors.Blue, 5, 2 )
		self:NoticeOnce( "Radiation sickness will fade over time", GAMEMODE.Colors.Blue, 5, 4 )
		
	end

	self:SetRadiation( self:GetRadiation() + num ) 
	
end

function meta:AddHealth( num )
	
	if self:Health() + num <= 0 then
	
		self:Kill()
		return
	
	end

	self:SetHealth( math.Clamp( self:Health() + num, 1, self:GetMaxHealth() ) )
	
end

function meta:SetInfected( bool )

	if self:Team() != TEAM_ARMY then bool = false end

	if bool then
	
		self:NoticeOnce( "You have been infected by the undead", GAMEMODE.Colors.Red, 5 )
		self:NoticeOnce( "You can cure infection with the antidote", GAMEMODE.Colors.Blue, 5, 2 )
		self:NoticeOnce( "The antidote location is marked on your screen", GAMEMODE.Colors.Blue, 5, 4 )
		
		self:AddStat( "Infections" )
	
	end

	self:SetNWBool( "Infected", bool )
	
end

function meta:IsInfected()
	return self:GetNWBool( "Infected", false )
end

function meta:SetBleeding( bool )

	if self:Team() != TEAM_ARMY then bool = false end

	if bool and IsValid( self.Stash ) and ( string.find( self.Stash:GetClass(), "npc" ) or self.Stash:GetClass() == "info_storage" ) then return end
	
	if bool then
	
		self:NoticeOnce( "You are bleeding to death", GAMEMODE.Colors.Red, 5 )
		self:NoticeOnce( "You can cover wounds with bandages", GAMEMODE.Colors.Blue, 5, 2 )
	
	end

	self:SetNWBool( "Bleeding", bool )
	
end

function meta:IsBleeding()
	return self:GetNWBool( "Bleeding", false )
end

function meta:SetPlayerClass( num )
	self.Class = num
end

function meta:GetPlayerClass()
	return self.Class or CLASS_SCOUT
end

function meta:IsIndoors()

	local tr = util.TraceLine( util.GetPlayerTrace( self, Vector(0,0,1) ) )
	
	if tr.HitSky or not tr.Hit then return false end
	
	return true

end

function meta:SetLord( bool )

	self:SetNWBool( "Lord", bool )

end

function meta:IsLord()

	return self:GetNWBool( "Lord", false )

end

function meta:SetZedDamage( num )

	self:SetNWInt( "ZedDamage", num )

end

function meta:GetZedDamage()

	return self:GetNWInt( "ZedDamage", 0 )

end

function meta:AddZedDamage( num )

	if self:IsLord() then

		self:SetZedDamage( self:GetZedDamage() + num )
		
		if self:GetZedDamage() > GAMEMODE.RedemptionDamage then
		
			self:NoticeOnce( "You have redeemed yourself", GAMEMODE.Colors.Green, 5 )
			self:NoticeOnce( "You will respawn as a human", GAMEMODE.Colors.Green, 5, 2 )
		
		end
		
	end

end

function meta:Gib()

	local dmg = DamageInfo()
	dmg:SetDamage( 500 )
	dmg:SetDamageType( DMG_BLAST )
	dmg:SetAttacker( self )
	dmg:SetInflictor( self )
	
	self:TakeDamageInfo( dmg )

end

function meta:OnSpawn()

	self.VoiceTbl = {}
	self.VoiceTbl[ VO_IDLE ] = CurTime() + math.random( 30, 60 )
	self.VoiceTbl[ VO_ALERT ] = CurTime() + math.random( 30, 60 )
	
	self:SetRadiation( 0 )
	self:SetInfected( false )
	self:SetBleeding( false )

	if self:Team() == TEAM_ARMY then
	
		if self:GetPlayerClass() == CLASS_SCOUT then
	
			self:SetCash( 25 )
		
		else
		
			self:SetCash( 15 )
		
		end
		
		if self:IsLord() then
		
			self:SetCash( 200 )
			
		end
		
		self:InitStats()
		self:SetEvacuated( false )
		self:SetLord( false )

		self:SetMaxHealth( 150 )
		self:SetHealth( 150 )
		
		self:SetStamina( 150 )
		
		self:SetWalkSpeed( GAMEMODE.WalkSpeed )
		self:SetRunSpeed( GAMEMODE.RunSpeed )
		
		self:SetModel( GAMEMODE.ClassModels[ self:GetPlayerClass() ] )
		
	else
		
		if self.NextClass then
		
			self:SetPlayerClass( self.NextClass )
			
			self.NextClass = nil
		
		end
	
		if self:IsLord() then
		
			self:NoticeOnce( "Harm the humans to fill your blood meter", GAMEMODE.Colors.Blue, 5, 15 )
			self:NoticeOnce( "Once your meter is full you will be redeemed", GAMEMODE.Colors.Blue, 5, 17 )
			self:NoticeOnce( "Killing a human will fill your meter faster", GAMEMODE.Colors.Blue, 5, 19 )
		
		end
	
		self:SetMaxHealth( GAMEMODE.ZombieHealth[ self:GetPlayerClass() ] )
		self:SetHealth( GAMEMODE.ZombieHealth[ self:GetPlayerClass() ] )
		
		self:SetWalkSpeed( GAMEMODE.ZombieSpeed[ self:GetPlayerClass() ] )
		self:SetRunSpeed( GAMEMODE.ZombieSpeed[ self:GetPlayerClass() ] )
		
		self:SetModel( GAMEMODE.ZombieModels[ self:GetPlayerClass() ] )
		
		self:NoticeOnce( "You can choose your class by pressing F2", GAMEMODE.Colors.Blue, 5, 2 )
	
	end

end

function meta:GetItemLoadout()

	if self:GetPlayerClass() == CLASS_ENGINEER then
	
		return { ITEM_SUPPLY }
	
	end

	return { ITEM_FOOD, ITEM_SUPPLY, ITEM_SUPPLY }

end

function meta:OnLoadout()

	if self:Team() == TEAM_ARMY then

		self:GiveAmmo( 200, "Pistol" )
		self:Give( "rad_knife" )
		//self:Give( "rad_inv" )

		local gun = ents.Create( "prop_physics" )
		gun:SetPos( self:GetPos() )
		gun:SetModel( GAMEMODE.ClassWeapons[ self:GetPlayerClass() ] )
		gun:Spawn()
		
		self:AddToInventory( gun )
		
		local ammobox = ents.Create( "prop_physics" )
		ammobox:SetPos( self:GetPos() )
		ammobox:SetModel( "models/items/357ammo.mdl" )
		ammobox:Spawn()
		
		self:AddToInventory( ammobox )
		
		if self:GetPlayerClass() == CLASS_ENGINEER then
		
			local hammer = ents.Create( "prop_physics" )
			hammer:SetPos( self:GetPos() )
			hammer:SetModel( "models/weapons/w_hammer.mdl" )
			hammer:Spawn()
			
			self:AddToInventory( hammer )
		
		end
		
		local load = self:GetItemLoadout()
		local items = {}
		
		for k,v in pairs( load ) do
		
			local tbl = item.RandomItem( v )
		
			table.insert( items, tbl.ID )
		
		end
		
		self:AddMultipleToInventory( items )
		
	else
	
		self:Give( GAMEMODE.ZombieWeapons[ self:GetPlayerClass() ] )
	
	end
	
end

function meta:GetDroppedItems()

	local inv = self:GetInventory()

	if not inv[1] then
		
		local rand = item.RandomItem( ITEM_FOOD )
		
		return { rand.ID } 
	
	end
	
	return inv

end

function meta:DropLoot()

	if not self:GetInventory() then return end

	local tbl = self:GetDroppedItems()
	local gun = nil
	
	for k,v in pairs( tbl ) do
	
		local itbl = item.GetByID( v )
		
		if itbl.Weapon then
		
			gun = itbl.Model
			table.remove( tbl, k )
			
			break
		
		end
	
	end
	
	if gun then
	
		local prop = ents.Create( "sent_droppedgun" )
		prop:SetPos( self:GetPos() + Vector(0,0,40) )
		prop:SetModel( gun )
		prop:Spawn()
	
	end
	
	local ent = ents.Create( "sent_lootbag" )
	
	for k,v in pairs( tbl ) do
	
		ent:AddItem( v )
	
	end
	
	ent:SetPos( self:GetPos() + Vector(0,0,25) )
	ent:SetAngles( self:GetForward():Angle() )
	ent:SetRemoval( 60 * 5 )
	ent:Spawn()
	ent:SetCash( self:GetCash() )
	
end

function meta:DoIgnite( att )

	if self:OnFire() then return end

	self.BurnTime = CurTime() + 5
	self.BurnAttacker = att

	local ed = EffectData()
	ed:SetEntity( self )
	util.Effect( "immolate", ed, true, true )
	
	self:EmitSound( table.Random( GAMEMODE.Burning ), 100, 80 )

end

function meta:OnFire()

	return ( self.BurnTime or 0 ) > CurTime()

end

function meta:Think()

	if not self:Alive() then return end
	
	if self:OnFire() and ( self.BurnInt or 0 ) < CurTime() then
	
		self.BurnInt = CurTime() + 0.5
	
		if self:Team() == TEAM_ARMY then

			local dmginfo = DamageInfo()
			dmginfo:SetDamage( math.random(1,5) )
			dmginfo:SetDamageType( DMG_BURN ) 
			dmginfo:SetAttacker( self )
		
			self:TakeDamageInfo( dmginfo )
		
		elseif IsValid( self.BurnAttacker ) then
		
			self:TakeDamage( 5, self.BurnAttacker )
		
		end
	
	end
	
	if self:Team() == TEAM_ZOMBIES then
	
		if ( self.HealTime or 0 ) < CurTime() then

			self.HealTime = CurTime() + 1.5
			
			self:AddHealth( 1 )
			
		end
		
		return
	
	end
	
	self:VoiceThink()
	
	if ( self.HealTime or 0 ) < CurTime() then // health regen - affected by bleeding and infection

		self.HealTime = CurTime() + 3.0
		
		if self:IsInfected() and math.random(1,5) == 1 then
		
			self:AddStamina( -2 )
			self:AddHealth( -2 )
			self:ViewBounce( math.random( 10, 15 ) )
			self:VoiceSound( table.Random( GAMEMODE.Coughs ), 100, math.random( 90, 100 ) )
		
		end
			
		if self:IsBleeding() then
			
			self:AddHealth( -1 )
			self.HealTime = CurTime() + 2.5
			
		elseif not self:IsBleeding() and not self:IsInfected() and self:GetRadiation() < 1 and self:Health() > 50 then // health regen only works if you arent affected by anything and >50 hp
			
			self:AddHealth( 1 )
		
		end
	
	end
	
	if ( self.PoisonTime or 0 ) < CurTime() then // radiation 
	
		self.PoisonTime = CurTime() + 1.5
	
		if self:GetRadiation() > 0 then
			
			local paintbl = { 0, 0, -1, -2, -2 }
			local stamtbl = { -1, -2, -2, -2, -3 }
		
			self:AddHealth( paintbl[ self:GetRadiation() ] )
			self:AddStamina( stamtbl[ self:GetRadiation() ] )
			
			if ( self.PoisonFade or 0 ) < CurTime() then
			
				self:AddRadiation( -1 )
				
				self.PoisonFade = CurTime() + 20
			
			end
			
		end
		
	end
	
	if ( self.StamTime or 0 ) < CurTime() then 
	
		self.StamTime = CurTime() + 1.0
		
		if self:KeyDown( IN_SPEED ) and self:GetVelocity():Length() > 1 then
			
			self:AddStamina( -1 )
			self.StamTime = CurTime() + 0.2
		
		elseif self:GetRadiation() < 1 then
		
			self:AddStamina( 1 )
			
			if self:GetPlayerClass() == CLASS_SCOUT then
				
				self.StamTime = CurTime() + 0.85
				
			end
						
			if self:GetStamina() <= 50 or self:IsInfected() then
			
				self.StamTime = CurTime() + 1.35
				
				if self:IsInfected() then
				
					self:NoticeOnce( "The infection slows your stamina regeneration", GAMEMODE.Colors.Red, 5 )
				
				else
				
					self:NoticeOnce( "Your stamina has dropped below 30%", GAMEMODE.Colors.Red, 5 )
					self:NoticeOnce( "Stamina replenishes slower when below 30%", GAMEMODE.Colors.Blue, 5, 2 )
					
				end
			
			end
			
		end
	
	end

end

function meta:AddToShipment( tbl )

	self.Shipment = table.Add( self.Shipment, tbl )

end

function meta:RemoveFromShipment( id )

	for k,v in pairs( self.Shipment or {} ) do
	
		if v == id then
		
			table.remove( self.Shipment, k )
			
			return
		
		end
	
	end

end

function meta:GetShipment()

	return self.Shipment or {}

end

function meta:SendShipment()

	if not self:GetShipment()[1] then
	
		self:Notice( "You haven't ordered any shipments", GAMEMODE.Colors.Red ) 
		return
	
	end
	
	if self:IsIndoors() then 
	
		self:Notice( "You can't order shipments while indoors", GAMEMODE.Colors.Red ) 
		return 
		
	end
	
	if GAMEMODE.RadioBlock and GAMEMODE.RadioBlock > CurTime() then
		
		self:Notice( "Radio communications are offline", GAMEMODE.Colors.Red )
		return
		
	end
	
	local droptime = 12 + ( table.Count( self.Shipment ) * 0.5 )
	
	self:Notice( "Your shipment is due in " .. math.Round( droptime ) .. " seconds", GAMEMODE.Colors.Green )
	
	local prop = ents.Create( "sent_dropflare" )
	prop:SetPos( self:GetPos() + Vector(0,0,10) )
	prop:SetDieTime( droptime )
	prop:Spawn()
	
	local function DropBox( ply, pos, tbl )
	
		ply:Notice( "Your shipment has been airdropped", GAMEMODE.Colors.Green, 5 )
	
		local box = ents.Create( "sent_supplycrate" )
		box:SetPos( pos ) 
		box:SetUser( ply )
		box:Spawn()
		box:SetContents( tbl ) 
		
	end
	
	local tr = util.TraceLine( util.GetPlayerTrace( self, Vector(0,0,1) ) )
	local ship = self:GetShipment()
	
	timer.Simple( droptime + 1, function() DropBox( self, tr.HitPos + Vector(0,0,-100), ship ) end )
	timer.Simple( droptime - 1, function() sound.Play( table.Random( GAMEMODE.Choppers ), self:GetPos(), 100, 100, 0.8 ) end )
	
	self.Shipment = {}

end

function meta:InitializeInventory()

	self.Inventory = {}
	self:SynchInventory()

end

function meta:GetInventory()

	return self.Inventory or {}
	
end

function meta:GetUniqueInventory()

	local tbl = {}
	
	for k,v in pairs( self.Inventory or {} ) do
	
		if not table.HasValue( tbl, v ) then
		
			table.insert( tbl, v )
		
		end
	
	end
	
	return tbl

end

function meta:SynchInventory()

	//datastream.StreamToClients( { self }, "InventorySynch", self:GetInventory() )
	
	net.Start( "InventorySynch" )
		
		net.WriteTable( self:GetInventory() )
		
	net.Send( self )

end

function meta:AddMultipleToInventory( items )

	for k,v in pairs( items ) do

		local tbl = item.GetByID( v )
		
		if tbl then
		
			if ( tbl.PickupFunction and tbl.PickupFunction( self, tbl.ID ) ) or not tbl.PickupFunction then
			
				table.insert( self.Inventory, tbl.ID )
				self:AddWeight( tbl.Weight )
	
			end
			
			self:Notice( "Picked up " .. tbl.Name, GAMEMODE.Colors.Green )
		
		end
	
	end
	
	self:SynchInventory()
	self:EmitSound( Sound( "items/itempickup.wav" ) )
	self:AddStat( "Loot", #items )

end

function meta:RemoveMultipleFromInventory( items )

	for k,v in pairs( items ) do
	
		local tbl = item.GetByID( v )
	
		for c,d in pairs( self:GetInventory() ) do
		
			if d == v then
				
				self:AddWeight( -tbl.Weight )
		
				table.remove( self.Inventory, c )
				
				break
				
			end
		
		end
	
	end
	
	self:SynchInventory()

end

function meta:AddIDToInventory( id )

	local tbl = item.GetByID( id )
	
	if not tbl then return end
	
	if tbl.PickupFunction then
	
		if not tbl.PickupFunction( self, id ) then return end
	
	end

	table.insert( self.Inventory, id )
	self:AddWeight( tbl.Weight )
	self:Notice( "Picked up " .. tbl.Name, GAMEMODE.Colors.Green )
	
	self:SynchInventory()
	self:EmitSound( Sound( "items/itempickup.wav" ) )
	self:AddStat( "Loot" )
	
end

function meta:AddToInventory( prop )

	local tbl = item.GetByModel( prop:GetModel() )
	
	if not tbl or ( tbl and tbl.AllowPickup ) then return end
	
	if tbl.PickupFunction then
	
		if not tbl.PickupFunction( self, tbl.ID ) then 
		
			if IsValid( prop ) then
	
				prop:Remove()
	
			end
		
			return 
			
		end
	
	end

	table.insert( self.Inventory, tbl.ID )
	self:AddWeight( tbl.Weight )
	self:Notice( "Picked up " .. tbl.Name, GAMEMODE.Colors.Green )
	
	if IsValid( prop ) then
	
		prop:Remove()
	
	end
	
	self:SynchInventory()
	self:EmitSound( Sound( "items/itempickup.wav" ) )
	self:AddStat( "Loot" )
	
end

function meta:RemoveFromInventory( id )

	for k,v in pairs( self:GetInventory() ) do
	
		if v == id then		
		
			local tbl = item.GetByID( id )
		
			table.remove( self.Inventory, k )
			
			self:SynchInventory()
			self:AddWeight( -tbl.Weight )
			
			return
		
		end
	
	end

end

function meta:GetItemDropPos()

	local trace = {}
	trace.start = self:GetShootPos()
	trace.endpos = trace.start + self:GetAimVector() * 30
	trace.filter = self
	
	local tr = util.TraceLine( trace )
	
	return tr.HitPos

end

function meta:GetItemCount( id )

	local count = 0

	for k,v in pairs( self:GetInventory() ) do
	
		if v == id then
		
			count = count + 1
		
		end
	
	end
	
	return count

end

function meta:GetWood()

	local tbl = item.GetByName( "Wood" )

	return self:HasItem( "Wood" ), tbl.ID

end

function meta:HasItem( thing )

	for k,v in pairs( ( self:GetInventory() ) ) do
	
		local tbl = item.GetByID( v )
	
		if ( type( thing ) == "number" and v == thing ) or ( type( thing ) == "string" and string.lower( tbl.Model ) == string.lower( thing ) ) or ( type( thing ) == "string" and string.lower( tbl.Name ) == string.lower( thing ) ) then
		
			return true
			
		end
		
	end
	
	return false
	
end

function meta:SynchCash( amt )

	if not amt then return end

	umsg.Start( "CashSynch", self )
	umsg.Short( amt )
	umsg.End()

end

function meta:SynchStash( ent )

	//datastream.StreamToClients( { self }, "StashSynch", ent:GetItems() )
	
	net.Start( "StashSynch" )
		
		net.WriteTable( ent:GetItems() )
		
	net.Send( self )

end

function meta:ToggleStashMenu( ent, open, menutype, pricemod )
	
	if open then
	
		if menutype != "StoreMenu" then
	
			self:SetMoveType( MOVETYPE_NONE )
			
		end
		
		self:SynchInventory()
		self:SynchStash( ent )
		self.Stash = ent
	
	else
	
		self:SetMoveType( MOVETYPE_WALK )
		self.Stash = nil
	
	end
	
	umsg.Start( menutype, self )
	umsg.Bool( open )
	
	if pricemod then
		umsg.Float( pricemod )
	end
	
	umsg.End()

end

function meta:SetEvacuated( bool )

	self.Evacuated = bool

end

function meta:IsEvacuated()

	return self.Evacuated

end

function meta:Evac()

	self:Notice( "You were successfully evacuated", GAMEMODE.Colors.Green, 5 )
	
	self:SetEvacuated( true )
	self:Freeze( true )
	self:Flashlight( false )
	self:SetModel( "models/shells/shell_9mm.mdl" )
	self:Spectate( OBS_MODE_ROAMING )
	self:StripWeapons()
	self:GodEnable()
	
end

function meta:OnDeath()

	umsg.Start( "DeathScreen", self )
	umsg.Short( self:Team() )
	umsg.End()
	
	self.NextSpawn = CurTime() + 15

	if self:Team() == TEAM_ARMY then

		if IsValid( self.Stash ) then
		
			if self.Stash:GetClass() == "info_trader" then
			
				self.Stash:OnExit( self )
			
			else
		
				self:ToggleStashMenu( self.Stash, false, "StashMenu" )
				
			end
		
		end
		
		self.Stash = nil
		
		self:DropLoot()
		self:SetWeight( 0 )
		self:SetCash( 0 )
		self:Flashlight( false )
		self:SetPlayerClass( CLASS_RUNNER )
		self.Inventory = {}
		self:SynchInventory()
		
		for k,v in pairs{ "Buckshot", "Rifle", "SMG", "Pistol", "Sniper", "Prototype" } do
		
			self:SetAmmo( v, 0 )
		
		end

	else
	
		if self:GetPlayerClass() == CLASS_CONTAGION then
		
			self:SetModel( "models/zombie/classic_legs.mdl" )
			self:EmitSound( table.Random( GAMEMODE.GoreSplash ), 90, math.random( 60, 80 ) )
			
			local got = false
			
			for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
				if v:GetPos():Distance( self:GetPos() ) < 200 then
		
					self:AddZedDamage( 50 )
					v:TakeDamage( 25, self )
					v:SetInfected( true )
			
					umsg.Start( "Drunk", v )
					umsg.Short( 2 )
					umsg.End()
		
					got = true
		
				end
	
			end
			
			if got then
			
				self:Notice( "You infected a human", GAMEMODE.Colors.Green )
			
			end
	
			local ed = EffectData()
			ed:SetOrigin( self.Entity:GetPos() )
			util.Effect( "puke_explosion", ed, true, true )
		
		elseif self:GetPlayerClass() == CLASS_LEAPER then
		
			self:SetModel( "models/player/zombiefast.mdl" )
		
		end
	
	end

end