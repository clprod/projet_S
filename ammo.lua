require "entity"

Ammo = Entity:extend()

function Ammo:new(game, mousePos)
	Ammo.super.new(self, game)
	self.position = Vector(game.weapon.position.x, game.weapon.position.y)
	self.direction = (mousePos - self.position):normalized()
	self.speed = 500
	self.width = nil
	self.height = nil
end

function Ammo:update(dt)
	Ammo.super.update(self, dt)
	self:move(dt)
end

function Ammo:draw()
	Ammo.super.draw(self)
end

function Ammo:move(dt)
	self.position = self.position + self.direction * self.speed * dt
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
