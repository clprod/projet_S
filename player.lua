require "entity"

Player = Entity:extend()

local gravity = 20
local maxDashingTime = 2
local dashingTimeRecovery = 10
local dashingPower = 20
local spaceKeyIsRealeased = true

function Player:new(game)
  self.name = "toto"
  Player.super.new(self, game)
  self.width, self.height = 30, 30
  self.position = Vector(48, 48)
  self.velocity = Vector()
  self.acceleration = 10
  self.drag = 40
  self.maxSpeed = 4
  self.jumpPower = 10
  self.weapon = game.weapon
  self.isDashing = false
  self.dashingTimer = 9999
end

function Player:update(dt)
  Player.super.update(self, dt)
  self:move(dt)
  if love.mouse.isDown("1") then
    self.weapon:shoot()
  end

  -- dash timer check
  if self.dashingTimer >= maxDashingTime and self.isDashing then
    self.isDashing = false
  end
end

function Player:draw()
  Player.super.draw(self)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", self.position.x - self.width/2, self.position.y - self.height/2, self.width, self.height)
end

function Player:equip(weapon)
  self.weapon = weapon
end


function Player:move(dt)
  self.velocity.y = self.velocity.y + dt * gravity
  if love.keyboard.isDown("q") or love.keyboard.isDown("left") then
    if self.velocity.x > 0 then
      -- Direction changed
      self.velocity.x = 0
    end
    self.velocity.x = self.velocity.x - self.acceleration * dt
    if self.velocity.x < -self.maxSpeed  and not self.dashing then
      -- Keep speed at max speed
      self.velocity.x = -self.maxSpeed
    end
  elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    if self.velocity.x < 0 then
      -- Direction changed
      self.velocity.x = 0
    end
    self.velocity.x = self.velocity.x + self.acceleration * dt
    if self.velocity.x > self.maxSpeed  and not self.dashing then
      -- Keep speed at max speed
      self.velocity.x = self.maxSpeed
    end
  else
    -- No key pressed, slowly stop
    if self.velocity.x < -1 and not self.dashing then
      self.velocity.x = self.velocity.x + self.drag * dt
    elseif self.velocity.x > 1 and not self.dashing then
      self.velocity.x = self.velocity.x - self.drag * dt
    else
      self.velocity.x = 0
    end
  end

  if love.keyboard.isDown("z") and (self.position.y + self.height/2 >= love.graphics.getHeight() or
                                        self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, self.height/2+1)) or
                                        self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, self.height/2+1))) then
    self.velocity.y = -self.jumpPower
  end

  -- check space key
  if not love.keyboard.isDown('space') then
    spaceKeyIsRealeased = true
  end


  elapsed_time = os.difftime(self.dashingTimer - dashingTimeRecovery)
  if love.keyboard.isDown('space')
    and not self.isDashing
    and spaceKeyIsRealeased
    and self.dashingTimer >= dashingTimeRecovery then
    -- dashing action
    self.isDashing = true
    spaceKeyIsRealeased = false
    self.dashingTimer = love.timer.getTime()
    if self.velocity.x > 0 then
      self.velocity.x = self.velocity.x + dashingPower
    else
      self.velocity.x = self.velocity.x - dashingPower
    end
  end

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
      if self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, -self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, self.height/2)) then
        self.position.x = self.position.x - self.velocity.x
        self.velocity.x = 0
      end
  elseif self.velocity.x < 0 then
      if self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, -self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, self.height/2)) then
        self.position.x = self.position.x - self.velocity.x
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
    if self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, self.height/2)) then
      self.position.y = self.position.y - self.velocity.y
      self.velocity.y = 0
    end
  elseif self.velocity.y < 0 then
    if self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, -self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, -self.height/2)) then
      self.position.y = self.position.y - self.velocity.y
      self.velocity.y = 0
    end
  end
end
