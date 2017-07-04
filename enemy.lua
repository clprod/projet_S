require "entity"

Enemy = Entity:extend()

local gravity = 20

enemyImage = love.graphics.newImage("ressources/eyeball/eyeball2processing1.png")

function Enemy:new(game)
  self.name = "eye"
  Enemy.super.new(self, game)
  self.position = Vector(663, 230)
  self.width = enemyImage:getWidth() * 0.1
	self.height = enemyImage:getHeight() * 0.1
  self.velocity = Vector(0,0)
  self.lifeCpt = 1
end

function Enemy:update(dt)
  Enemy.super.update(self, dt)
  --self:move(dt)

  -- check death
  -- if self.lifeCpt == 0 then self = nul end
end

function Enemy:draw()
  Enemy.super.draw(self)
  if self.lifeCpt > 0 then
	   love.graphics.setColor(255, 255, 255)
	    love.graphics.draw(enemyImage, self.position.x - self.width/2, self.position.y - self.height/2, 0, 0.1, 0.1, self.width/2, self.height/2)
  end

end

function Enemy:getDammeged()
  print("aie")
  self.lifeCpt = self.lifeCpt - 1
end


function Enemy:move(dt)
  -- gravity
  self.velocity.y = self.velocity.y + dt * gravity

  -- update x position
  self.position.x = self.position.x + self.velocity.x
  -- keep inside screen
  if self.position.x + self.width/2 > love.graphics.getWidth() then
    self.velocity.x = 0
    self.position.x = love.graphics.getWidth() - self.width/2
  elseif self.position.x - self.width/2 < 0 then
    self.velocity.x = 0
    self.position.x = self.width/2
  end
  -- map collision
  if self.velocity.x > 0 then
      if self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, -self.height/2+1)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, self.height/2-1)) then
        self.position.x = math.floor((self.position.x + self.width/2) / self.game.map.tileWidth) * self.game.map.tileWidth - self.width/2
        self.velocity.x = 0
      end
  elseif self.velocity.x < 0 then
      if self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, -self.height/2+1)) or self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, self.height/2-1)) then
        self.position.x = math.floor(self.position.x / self.game.map.tileWidth) * self.game.map.tileWidth + self.width/2
        self.velocity.x = 0
      end
  end

  -- update y position
  self.position.y = self.position.y + self.velocity.y
  -- keep inside screen
  if self.position.y + self.height/2 > love.graphics.getHeight() then
    self.velocity.y = 0
    self.position.y = love.graphics.getHeight() - self.height/2
  elseif self.position.y - self.height/2 < 0 then
    self.velocity.y = 0
    self.position.y = self.height/2
  end
  -- Map collision
  if self.velocity.y > 0 then
    if self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2+1, self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2-1, self.height/2)) then
      self.position.y = math.floor((self.position.y + self.height/2) / self.game.map.tileHeight) * self.game.map.tileHeight - self.height/2
      self.velocity.y = 0
    end
  elseif self.velocity.y < 0 then
    if self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2+1, -self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2-1, -self.height/2)) then
      self.position.y = math.floor(self.position.y / self.game.map.tileHeight) * self.game.map.tileHeight + self.height/2
      self.velocity.y = 0
    end
  end
end
