
EFFECT.Mat = Material( "trails/plasma" )
EFFECT.Sprite = Material( "effects/yellowflare" )

function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	
	local dir = self.StartPos - self.EndPos
	dir:Normalize()
	
	self.Dir = dir
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	self.Alpha = 100
	self.Color = Color( 250, 150, 50, self.Alpha )
	
	local dlight = DynamicLight( self:EntIndex() )
	
	if dlight then
	
		dlight.Pos = self.StartPos
		dlight.r = 255
		dlight.g = 150
		dlight.b = 50
		dlight.Brightness = 3
		dlight.Decay = 256
		dlight.size = 256 * math.Rand( 0.5, 1.0 )
		dlight.DieTime = CurTime() + 5
		
	end

end

function EFFECT:Think( )

	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )

	self.Alpha = self.Alpha - FrameTime() * 200
	self.Color = Color( 250, 150, 50, self.Alpha )
	
	return self.Alpha > 0

end

function EFFECT:Render( )

	if self.Alpha < 1 then return end
	
	--[[self.Length = ( self.StartPos - self.EndPos ):Length()
	
	render.SetMaterial( self.Mat )
	render.DrawBeam( self.StartPos, self.EndPos, ( 100 / self.Alpha ) * 0.5 + 0.5, 0, 0, self.Color )]]
	
	if ( self.Alpha < 1 ) then return end

	self.Length = (self.StartPos - self.EndPos):Length()
		
	local texcoord = CurTime() * -0.2
	
	for i = 1, 10 do
	
		render.SetMaterial( self.Mat )
		
		texcoord = texcoord + i * 0.05 * texcoord
	
		render.DrawBeam( self.StartPos, 										
						self.EndPos,											
						i * self.Alpha * 0.03,									
						texcoord,												
						texcoord + (self.Length / (128 + self.Alpha)),		
						self.Color )
						
		render.SetMaterial( self.Sprite )

		render.DrawSprite( self.StartPos + self.Dir * i, i * 5, i * 5, Color( self.Color.r, self.Color.g, self.Color.b, self.Alpha ) )
		render.DrawSprite( self.EndPos, i * 5, i * 5, Color( self.Color.r, self.Color.g, self.Color.b, self.Alpha ) )
	
	end

end
