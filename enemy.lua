require "entity"
require "healthbar"

Enemy = Entity:extend()

function Enemy:new(game, position, maxHealth)
  Enemy.super.new(self, game)

  self.position = Vector(position.x, position.y)
  self.width = 0
  self.height = 0

  self.lifeCpt = maxHealth
  self.healthbar = Healthbar(self)
  self.firedBullets = {}

end

function Enemy:update(dt)
  Enemy.super.update(self, dt)
  self:move(dt)

  self.healthbar:update(dt)
  if self:canSeePlayer() then
    self:attackHero()
  end

  for i=#self.firedBullets,1,-1 do
    self.firedBullets[i]:update(dt)
  end
end

function Enemy:draw()
  Enemy.super.draw(self)

  self.healthbar:draw()
  for i,bullet in ipairs(self.firedBullets) do
		bullet:draw()
	end
end

function Enemy:getDamaged(damages)
  damages = damages or 0
  self.lifeCpt = self.lifeCpt - damages
end

function Enemy:isDead()
  return (self.lifeCpt <= 0)
end

function Enemy:move(dt)
end

function Enemy:isPositionColliding(position)
  if position.x <= self.position.x + self.width / 2
    and  position.x >= self.position.x - self.width / 2
    and position.y <= self.position.y + self.height / 2
    and  position.y >= self.position.y - self.height / 2 then
      return true
  end

  return false
end

function Enemy:attackHero()
  table.insert(self.firedBullets, Bullet(self.game, self.position, self.game.player.position))
end

function Enemy:canSeePlayer()
  if self.game.map:solidBetween(self.position, self.game.player.position) then
    return true
  end
end
