require "entity"

Ammo = Entity:extend()

function Ammo:new(game, initialPosition, isAlly)
	Ammo.super.new(self, game)
	self.position = Vector(initialPosition.x, initialPosition.y)

	self.isAlly = isAlly
end

function Ammo:update(dt)
	Ammo.super.update(self, dt)
end

function Ammo:draw()
	Ammo.super.draw(self)
end

function Ammo:isColliding()
  -- Map collision
  if self.game.map:isPixelPosSolid(self.position) then
		return true
	end

	-- enemy collision
	for i,entity in ipairs(self.game.entities) do
		if self.isAlly and entity:is(Enemy) then
			if entity:isPositionColliding(self.position) then
				entity:getDamaged(1)
			  return true
			end
		elseif not self.isAlly and entity:is(Player) then
			if entity:isPositionColliding(self.position) then
				entity:getDamaged(1)
			  return true
			end
		end
	end

	return false
end
