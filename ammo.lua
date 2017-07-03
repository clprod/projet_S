require "entity"

Ammo = Entity:extend()

function Ammo:new(game, mousePos)
	Ammo.super.new(self, game)
	self.velocity = Vector(0,0)
	self.position = Vector(game.weapon.position.x, game.weapon.position.y)
	self.direction = (mousePos - self.position):normalized()
	self.acceleration = 20
	self.maxSpeed = 30
	self.speed = 0
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
	self.speed = self.speed + self.acceleration * dt

	if self.speed > self.maxSpeed then
    self.speed = self.maxSpeed
  end

	self.position = self.position + self.direction * self.speed
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
