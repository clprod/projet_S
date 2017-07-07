require "enemy"

local enemyImage = love.graphics.newImage("ressources/eyeball/eyeball2processing1.png")

Eye = Enemy:extend()

local gravity = 20
local eyeMaxHealth = 5
local eyeImageScale = 0.1

function Eye:new(game, position)
  Eye.super.new(self, game, position, eyeMaxHealth)

  self.name = "eye"
  self.width = enemyImage:getWidth() * eyeImageScale
	self.height = enemyImage:getHeight() * eyeImageScale

  self.velocity = Vector(0,0)
end

function Eye:update(dt)
  Eye.super.update(self, dt)
end

function Eye:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(enemyImage, self.position.x - self.width/2, self.position.y - self.height/2, 0, eyeImageScale, eyeImageScale, self.width/2, self.height/2)

  Eye.super.draw(self)
end

function Eye:move(dt)
  self.super.move(self, dt)

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
