require "weapon"
require "ammo"

-- ---------------- Bow -----------------------

Bow = Weapon:extend()

function Bow:new(game)
  Bow.super.new(self, game)

  self.isLoading = false
  self.loadingTime = 0
  self.maxLoadingTime = 2

  self.minPower = 5
  self.maxPower = 20

  self.firedArrows = {}
end

function Bow:update(dt)
	Bow.super.update(self, dt)

  if self.isLoading then
    self.loadingTime = self.loadingTime + dt
    if self.loadingTime > self.maxLoadingTime then
      self.loadingTime = self.maxLoadingTime
    end
  end

	for i=#self.firedArrows,1,-1 do
		self.firedArrows[i]:update(dt)
		if self.firedArrows[i]:isColliding() then
			table.remove(self.firedArrows, i)
		end
	end
end

function Bow:draw()
	Bow.super.draw(self)

	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", self.position.x - self.width/2, self.position.y - self.height/2, self.width, self.height)

	for i,arrow in ipairs(self.firedArrows) do
		arrow:draw()
	end
end

function Bow:onShootPressed()
	Bow.super.onShootPressed(self)

  self.isLoading = true
  self.loadingTime = 0
end

function Bow:onShootReleased()
	Bow.super.onShootReleased(self)

  self.isLoading = false
  local shootPower = self.loadingTime * (self.maxPower - self.minPower) / self.maxLoadingTime + self.minPower

  local mouseX, mouseY = love.mouse.getPosition()
  table.insert(self.firedArrows, Arrow(self.game, self.position,  Vector(mouseX, mouseY), shootPower, true))
end

function Bow:shoot()
	Bow.super.shoot(self)
end

-- ---------------- Arrow -----------------------

local arrowImage = love.graphics.newImage("ressources/arrow.png")
local frameWidth, frameHeight = 32, 32
local frameNumber = 6

Arrow = Ammo:extend()

local gravity = 10

function Arrow:new(game, initialPosition, mousePos, power, isAlly)
	Arrow.super.new(self, game, initialPosition, isAlly)

  self.velocity = (mousePos - self.position):normalized() * power

	self.width = 32
	self.height = 32

  self.frames = {}

  for i=0,frameNumber-1 do
    table.insert(self.frames, love.graphics.newQuad(i * self.width, 0, frameWidth, frameHeight, arrowImage:getWidth(), arrowImage:getHeight()))
  end
end

function Arrow:update(dt)
	Arrow.super.update(self, dt)
	self:move(dt)
end

function Arrow:draw()
	Arrow.super.draw(self)

	love.graphics.setColor(255, 255, 255)
  love.graphics.draw(arrowImage, self.frames[1], self.position.x, self.position.y, self.velocity:angleTo(), 1, 1, frameWidth/2, frameHeight/2)
end

function Arrow:move(dt)
  self.velocity.y = self.velocity.y + gravity * dt

  self.position = self.position + self.velocity
end
