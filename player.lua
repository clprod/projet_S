require "entity"

Player = Entity:extend()

local gravity = 20
local maxDashingTime = 2
local dashingTimeRecovery = 10
local dashingPower = 10
local spaceKeyIsRealeased = true

function Player:new(game, position)
  self.name = "toto"
  Player.super.new(self, game)
  self.width, self.height = 30, 30
  self.position = Vector(position.x, position.y)
  self.velocity = Vector()
  self.acceleration = 10
  self.drag = 40
  self.maxSpeed = 4
  self.jumpPower = 10
  self.weapon = game.weapon
  self.isDashing = false
  self.dashingTimer = 9999

  self.lifeCpt = 3
  self.healthbar = Healthbar(self)

  self.isShootPressed = false
end

function Player:update(dt)
  Player.super.update(self, dt)
  self:move(dt)
  if love.mouse.isDown("1") then
    if not self.isShootPressed then
    self.isShootPressed = true
    self.weapon:onShootPressed()
    end
  else
    if self.isShootPressed then
      self.isShootPressed = false
      self.weapon:onShootReleased()
    end
  end

  -- dash timer check
  if self.dashingTimer >= maxDashingTime and self.isDashing then
    self.isDashing = false
  end
  self.healthbar:update(dt)
  self.weapon:update(dt)
end

function Player:draw()
  Player.super.draw(self)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", self.position.x - self.width/2, self.position.y - self.height/2, self.width, self.height)
  self.healthbar:draw(dt)
  self.weapon:draw()
end

function Player:equip(weapon)
  self.weapon = weapon
  self.weapon:setOwner(self)
end

function Player:getDamaged(damages)
  -- damages = damages or 0
  if self.lifeCpt - damages > 0 then
    self.lifeCpt = self.lifeCpt - damages
  else
    self.lifeCpt = 0
  end
end

function Player:isDead()
  print("On retourne ")
  return (self.lifeCpt == 0)
end

function Player:move(dt)
  self.velocity.y = self.velocity.y + dt * gravity
  if love.keyboard.isDown("q") or love.keyboard.isDown("left") then
    if self.velocity.x > 0 then
      -- Direction changed
      self.velocity.x = 0
    end
    if self.velocity.x > -self.maxSpeed then
      self.velocity.x = self.velocity.x - self.acceleration * dt
    end
  elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    if self.velocity.x < 0 then
      -- Direction changed
      self.velocity.x = 0
    end
    if self.velocity.x < self.maxSpeed then
      self.velocity.x = self.velocity.x + self.acceleration * dt
    end
  else
    -- No key pressed, slowly stop
    if self.position.y + self.height/2 >= love.graphics.getHeight() or
                                          self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2+1, self.height/2+1)) or
                                          self.game.map:isPixelPosSolid(self.position + Vector(self.width/2-1, self.height/2+1)) then
      if self.velocity.x < -1 then
        self.velocity.x = self.velocity.x + self.drag * dt
      elseif self.velocity.x > 1 then
        self.velocity.x = self.velocity.x - self.drag * dt
      else
        self.velocity.x = 0
      end
    end
  end

  if love.keyboard.isDown("z") and (self.position.y + self.height/2 >= love.graphics.getHeight() or
                                        self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2+1, self.height/2+1)) or
                                        self.game.map:isPixelPosSolid(self.position + Vector(self.width/2-1, self.height/2+1))) then
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
    else if self.velocity.x < 0 then
      self.velocity.x = self.velocity.x - dashingPower
      end
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
      if self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, -self.height/2+1)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, self.height/2-1)) then
        self.position.x = math.floor((self.position.x + self.width/2) / self.game.map.tileWidth) * self.game.map.tileWidth - self.width/2
        self.velocity.x = 0
      end
  elseif self.velocity.x < 0 then
      if self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, -self.height/2+1)) or self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, self.height/2-1)) then
        self.position.x = math.floor((self.position.x + self.width/2) / self.game.map.tileWidth) * self.game.map.tileWidth + self.width/2
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
      self.position.y = math.floor((self.position.y+self.height/2) / self.game.map.tileHeight) * self.game.map.tileHeight + self.height/2
      self.velocity.y = 0
    end
  end
end

function Player:isPositionColliding(position)
  if position.x <= self.position.x + self.width / 2
    and  position.x >= self.position.x - self.width / 2
    and position.y <= self.position.y + self.height / 2
    and  position.y >= self.position.y - self.height / 2 then
      return true
  end

  return false
end

function Player:isDead()
  return false
end
