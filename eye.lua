require "enemy"

local eyeImage = love.graphics.newImage("ressources/eyeball/sprite0_strip16.png")

Eye = Enemy:extend()

local gravity = 20
local eyeMaxHealth = 5

local eyeImageScale = 0.1
local eyeWidth = 480
local eyeHeight = 480
local eyeSpriteNumber = 16
local animationSpeed = 0.05

function Eye:new(game, position)
  Eye.super.new(self, game, position, eyeMaxHealth)

  self.frames = {}

  for i=0,eyeSpriteNumber-1 do
    table.insert(self.frames, love.graphics.newQuad(i * eyeWidth, 0, eyeWidth, eyeHeight, eyeImage:getWidth(), eyeImage:getHeight()))
  end

  self.width = eyeWidth * eyeImageScale
  self.height = eyeHeight * eyeImageScale

  self.currentFrame = 1
  self.lastFrameChange = 0
  self.animationSpeed = math.random(3, 7) / 100

  self.velocity = Vector(0,0)

  self.firedBullets = {}
  self.shootCooldown = 1
  self.lastTimeShoot = 0
end

function Eye:update(dt)
  Eye.super.update(self, dt)

  self.lastTimeShoot = self.lastTimeShoot - dt

  if self.lastTimeShoot <= 0 then
    if self:canSeePlayer() then
      self:attackHero()
      self.lastTimeShoot = self.shootCooldown
    end
  end

  -- Bullets
  for i=#self.firedBullets,1,-1 do
    self.firedBullets[i]:update(dt)
		if self.firedBullets[i]:isColliding() then
			table.remove(self.firedBullets, i)
		end
  end

  -- Animation
  self.lastFrameChange = self.lastFrameChange + dt

  if self.lastFrameChange >= self.animationSpeed then
    self.currentFrame = self.currentFrame + 1
    if self.currentFrame > eyeSpriteNumber  then
      self.currentFrame = 1
    end

    self.lastFrameChange = 0
  end
end

function Eye:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(eyeImage, self.frames[self.currentFrame], self.position.x, self.position.y, 0, eyeImageScale, eyeImageScale, eyeWidth/2, eyeHeight/2)

  for i,bullet in ipairs(self.firedBullets) do
		bullet:draw()
	end

  Eye.super.draw(self)
end

function Eye:move(dt)
  Eye.super.move(self, dt)

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

function Eye:attackHero()
  table.insert(self.firedBullets, Bullet(self.game, self.position, self.game.player.position, false, 300))
end

function Eye:canSeePlayer()
  if not self.game.map:solidBetween(self.position, self.game.player.position) then
    return true
  end
end
