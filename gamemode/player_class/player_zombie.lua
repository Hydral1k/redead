
AddCSLuaFile()

local PLAYER = {} 

function PLAYER:UpdateAnimation( velocity, maxseqgroundspeed )	

	local len = velocity:Length()
	local movement = 1.0

	if len > 0.2 then
	
		movement = len / maxseqgroundspeed 
		
	end

	rate = math.min( movement, 2 )

	if self.Player:WaterLevel() >= 2 then
	
		rate = math.max( rate, 0.5 )
		
	elseif !self.Player:IsOnGround() and len >= 1000 then 
	
		rate = 0.1
		
	end

	local weapon = self.Player:GetActiveWeapon()

	self.Player:SetPlaybackRate( rate )

	if CLIENT then
	
		self:GrabEarAnimation()
		self:MouthMoveAnimation()
		
	end

end

function PLAYER:CalcMainActivity( velocity )

	self.Player.CalcIdeal = ACT_MP_STAND_IDLE
	self.Player.CalcSeqOverride = self.Player:LookupSequence( "zombie_idle" )

	local len2d = velocity:Length2D()
	
	if len2d > 1 then
	
		self.Player.CalcSeqOverride = self.Player:LookupSequence( "zombie_run" )
		
	end

	return self.Player.CalcIdeal, self.Player.CalcSeqOverride

end

function PLAYER:DoAnimationEvent( event, data )

	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then

		self.Player:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_RANGE_ZOMBIE, true )

		return ACT_VM_PRIMARYATTACK

	elseif event == PLAYERANIMEVENT_ATTACK_SECONDARY then

		return ACT_VM_SECONDARYATTACK

	elseif event == PLAYERANIMEVENT_JUMP then

		self.Player.m_bJumping = true
		self.Player.m_bFirstJumpFrame = true
		self.Player.m_flJumpStartTime = CurTime()
		
		self.Player:AnimRestartMainSequence()

		return ACT_INVALID

	elseif event >= PLAYERANIMEVENT_FLINCH_CHEST and event <= PLAYERANIMEVENT_FLINCH_RIGHTLEG then

		self.Player:AnimRestartGesture( GESTURE_SLOT_FLINCH, ACT_FLINCH_PHYSICS, true )

		return ACT_INVALID

	end

	return nil

end

player_manager.RegisterClass( "player_zombie", PLAYER, "player_base" )