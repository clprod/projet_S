require "entity"

Ammo = Entity:extend()

function Ammo:new(game, mousePos)
	Ammo.super:new(game)
	self.initPos = game.weapon.position
	self.velocity = Vector(0,0)
	self.position = game.weapon.position
	self.direction = (mousePos - self.position):normalized()
	self.acceleration = game.weapon.shootingPower
	self.maxSpeed = 20
	self.speed = 0
end

function Ammo:update(dt)
	Ammo.super.update()
	self:move(dt)
end

function Ammo:draw()
	Ammo.super.draw()
end

function Ammo:move(dt)
	self.speed = self.speed + self.acceleration * dt

	if self.speed > self.maxSpeed then
      self.speed = self.maxSpeed
  end

	self.position = self.position + self.direction * self.speed

    -- Map collision
    -- if (self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, self.height/2)) )
    -- or
    -- (self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, -self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, -self.height/2)) ) then
    -- 	table.remove(self.game.weapon.firedBullets, self)
    -- 	self = nil
		--
    -- end
end
