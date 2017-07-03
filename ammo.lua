require "entity"

Ammo = Entity:extend()

function Ammo:new(game, initialPosition)
	Ammo.super.new(self, game)
	self.position = Vector(initialPosition.x, initialPosition.y)
end

function Ammo:update(dt)
	Ammo.super.update(self, dt)
end

function Ammo:draw()
	Ammo.super.draw(self)
end

function Ammo:isColliding()
  -- Map collision
  if (self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, self.height/2)) )
  or
  (self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, -self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, -self.height/2)) ) then
		return true
  end

	return false
end
