require "entity"

Player = Entity:extend()

local gravity = 20

function Player:new()
  Player.super:new()

  self.width, self.height = 32, 32
  self.position = Vector(16, 16)  
  self.velocity = Vector()
  self.acceleration = 20
  self.drag = 80
  self.maxSpeed = 10
  self.jumpPower = 10
  self.weapon = nil
end

function Player:update(dt)
  Player.super:update(dt)
  self:move(dt)
  if love.mouse.isDown("1") then
    self:shoot(dt)
  end
end

function Player:draw()
  Player.super:draw()

  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", self.position.x - self.width/2, self.position.y - self.height/2, self.width, self.height)
end

function Player:equip(weapon)
  self.weapon = weapon
end

function Player:shoot(dt)
    self.weapon:shoot(dt)
end

function Player:move(dt)
  self.velocity.y = self.velocity.y + dt * gravity

  if love.keyboard.isDown("q") or love.keyboard.isDown("left") then
    if self.velocity.x > 0 then
      -- Direction changed
      self.velocity.x = 0
    end
    self.velocity.x = self.velocity.x - self.acceleration * dt
    if self.velocity.x < -self.maxSpeed then
      -- Keep speed at max speed
      self.velocity.x = -self.maxSpeed
    end
  elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    if self.velocity.x < 0 then
      -- Direction changed
      self.velocity.x = 0
    end
    self.velocity.x = self.velocity.x + self.acceleration * dt
    if self.velocity.x > self.maxSpeed then
      -- Keep speed at max speed
      self.velocity.x = self.maxSpeed
    end
  else
    -- No key pressed, slowly stop
    if self.velocity.x < -1 then
      self.velocity.x = self.velocity.x + self.drag * dt
    elseif self.velocity.x > 1 then
      self.velocity.x = self.velocity.x - self.drag * dt
    else
      self.velocity.x = 0
    end
  end

  if love.keyboard.isDown("space") and self.position.y + self.height/2 >= love.graphics.getHeight() then
    self.velocity.y = -self.jumpPower
  end

  -- update position
  self.position = self.position + self.velocity

  -- keep inside screen
  if self.position.y + self.height/2 > love.graphics.getHeight() then
    self.velocity.y = 0
    self.position.y = love.graphics.getHeight() - self.height/2
  elseif self.position.y - self.height/2 < 0 then
    self.velocity.y = 0
    self.position.y = self.height/2
  end

  if self.position.x + self.width/2 > love.graphics.getWidth() then
    self.velocity.x = 0
    self.position.x = love.graphics.getWidth() - self.width/2
  elseif self.position.x - self.width/2 < 0 then
    self.velocity.x = 0
    self.position.x = self.width/2
  end
end
