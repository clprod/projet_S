require "weapon"
require "ammo"

-- ---------------- GrenadeLauncher -----------------------

GrenadeLauncher = Weapon:extend()

function GrenadeLauncher:new(game)
  GrenadeLauncher.super.new(self, game)

	self.shootingPower = 13
	self.loadingTime = 1
	self.lastTimeShoot = 0

	self.firedGrenades = {}
end

function GrenadeLauncher:update(dt)
	GrenadeLauncher.super.update(self, dt)

  self.lastTimeShoot = self.lastTimeShoot - dt

	for i=#self.firedGrenades,1,-1 do
		self.firedGrenades[i]:update(dt)
		if self.firedGrenades[i]:explode() then

      local grenadePosition = self.firedGrenades[i].position
      local grenadeExplosionRange = self.firedGrenades[i].explosionRange
      local grenadeExplosionPower = self.firedGrenades[i].explosionPower
      
      for i,entity in ipairs(self.game.entities) do
        local explosionDistance = entity.position:dist(grenadePosition)
        if explosionDistance < grenadeExplosionRange then
          local explosionDirection = (entity.position - grenadePosition):normalized()
          entity.velocity = entity.velocity + explosionDirection * grenadeExplosionPower * (grenadeExplosionRange - explosionDistance) / grenadeExplosionRange
        end
      end

			table.remove(self.firedGrenades, i)
		end
	end
end

function GrenadeLauncher:draw()
	GrenadeLauncher.super.draw(self)

	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", self.position.x - self.width/2, self.position.y - self.height/2, self.width, self.height)

	for i,grenade in ipairs(self.firedGrenades) do
		grenade:draw()
	end
end

function GrenadeLauncher:shoot()
	GrenadeLauncher.super.shoot(self)

	if self.lastTimeShoot <= 0 then
		local mouseX, mouseY = love.mouse.getPosition()
		table.insert(self.firedGrenades, Grenade(self.game, self.position, Vector(mouseX, mouseY), self.shootingPower))
		self.lastTimeShoot = self.loadingTime
	end
end

-- ---------------- Grenade -----------------------
Grenade = Ammo:extend()

local gravity = 20

function Grenade:new(game, initialPosition, mousePos, power)
	Grenade.super.new(self, game, initialPosition)

  self.velocity = (mousePos - self.position):normalized() * power
  self.drag = 5
  self.dragThreshold = 0.2
  self.bounciness = 0.3

  self.timeToExplode = 1.3
  self.timeAfterSpawn = 0
  self.explosionPower = 20
  self.explosionRange = 100

	self.width = 12
	self.height = 12
end

function Grenade:update(dt)
	Grenade.super.update(self, dt)
	self:move(dt)

  self.timeAfterSpawn = self.timeAfterSpawn + dt
end

function Grenade:draw()
	Grenade.super.draw(self)

	love.graphics.setColor(0, 255, 0)
  love.graphics.circle("fill", self.position.x, self.position.y, self.width/2, 10)
end

function Grenade:move(dt)
  self.velocity.y = self.velocity.y + gravity * dt

  if self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2+1, self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2-1, self.height/2)) then
    if self.velocity.x > self.dragThreshold then
      self.velocity.x = self.velocity.x - self.drag * dt
    elseif self.velocity.y < -self.dragThreshold then
      self.velocity.x = self.velocity.x + self.drag * dt
    else
      self.velocity.x = 0
    end
  end

  -- update x position
  self.position.x = self.position.x + self.velocity.x
  -- keep inside screen
  if self.position.x + self.width/2 > love.graphics.getWidth() then
    self.velocity.x = -self.velocity.x * self.bounciness
    self.position.x = love.graphics.getWidth() - self.width/2
  elseif self.position.x - self.width/2 < 0 then
    self.velocity.x = -self.velocity.x * self.bounciness
    self.position.x = self.width/2
  end
  -- map collision
  if self.velocity.x > 0 then
      if self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, -self.height/2+1)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2, self.height/2-1)) then
        self.position.x = math.floor((self.position.x + self.width/2) / self.game.map.tileWidth) * self.game.map.tileWidth - self.width/2
        self.velocity.x = -self.velocity.x * self.bounciness
      end
  elseif self.velocity.x < 0 then
      if self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, -self.height/2+1)) or self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2, self.height/2-1)) then
        self.position.x = math.floor((self.position.x + self.width/2) / self.game.map.tileWidth) * self.game.map.tileWidth + self.width/2
        self.velocity.x = -self.velocity.x * self.bounciness
      end
  end

  -- update y position
  self.position.y = self.position.y + self.velocity.y
  -- keep inside screen
  if self.position.y + self.height/2 > love.graphics.getHeight() then
    self.velocity.y = -self.velocity.y * self.bounciness
    self.position.y = love.graphics.getHeight() - self.height/2
  elseif self.position.y - self.height/2 < 0 then
    self.velocity.y = -self.velocity.y * self.bounciness
    self.position.y = self.height/2
  end
  -- Map collision
  if self.velocity.y > 0 then
    if self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2+1, self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2-1, self.height/2)) then
      self.position.y = math.floor((self.position.y + self.height/2) / self.game.map.tileHeight) * self.game.map.tileHeight - self.height/2
      self.velocity.y = -self.velocity.y * self.bounciness
    end
  elseif self.velocity.y < 0 then
    if self.game.map:isPixelPosSolid(self.position + Vector(-self.width/2+1, -self.height/2)) or self.game.map:isPixelPosSolid(self.position + Vector(self.width/2-1, -self.height/2)) then
      self.position.y = math.floor((self.position.y + self.height/2) / self.game.map.tileHeight) * self.game.map.tileHeight + self.height/2
      self.velocity.y = -self.velocity.y * self.bounciness
    end
  end
end

function Grenade:explode()
  return self.timeAfterSpawn >= self.timeToExplode
end
