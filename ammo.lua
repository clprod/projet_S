require "entity"

Ammo = Entity:extend()

function Ammo:new(game, direction)
	Ammo.super:new(game)
	self.initPos = game.weapon.position
	self.direction = direction
	self.velocity = Vector(0,0)
	self.position = game.weapon.position
	self.acceleration = game.weapon.shootingPower
	self.maxSpeed = 20

end

function Ammo:update(dt)
	Ammo.super.update()
	self:move(dt)
end

function Ammo:draw()
	Ammo.super.draw()
end

function Ammo:move(dt)
	print(self.velocity.x)
	self.velocity.y = self.velocity.y + dt * self.acceleration

	if self.velocity.x < -self.maxSpeed then
      -- Keep speed at max speed
      self.velocity.x = -self.maxSpeed
    end

    if self.velocity.x > self.maxSpeed  then
      -- Keep speed at max speed
      self.velocity.x = self.maxSpeed

      -- update x position
      self.position.x = self.position.x + self.velocity.x
      -- update y position
      self.position.y = self.position.y + self.velocity.y
	end

    -- Map collision
    -- if (self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, self.height/2)) )
    -- or
    -- (self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, -self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, -self.height/2)) ) then
    -- 	table.remove(self.game.weapon.firedBullets, self)
    -- 	self = nil
		--
    -- end
end
