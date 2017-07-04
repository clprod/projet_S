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

	-- enemy collision
	for i,entity in ipairs(self.game.entities) do
		if entity:is(Enemy) then
			if self.position.x <= entity.position.x + entity.width
						and  self.position.x >= entity.position.x - entity.width
						and self.position.y <= entity.position.y + entity.height
						and  self.position.y >= entity.position.y - entity.height then
				entity:getDamaged()
			  return true
			end
		end
	end

	return false
end
