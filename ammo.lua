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
		-- enemy colision
	if self.position.x <= self.game.enemy.position.x + self.game.enemy.width
		and  self.position.x >= self.game.enemy.position.x - self.game.enemy.width
		and self.position.y <= self.game.enemy.position.y + self.game.enemy.height
		and  self.position.y >= self.game.enemy.position.y - self.game.enemy.height then
			self.game.enemy:getDammeged()
		  return true
		end

	return false
end
