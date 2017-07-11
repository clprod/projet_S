require "weapon"
require "ammo"

-- ---------------- Bow -----------------------
local bowImage = love.graphics.newImage("ressources/bow.png")
local bowLoadingFrameNumber = 4
local bowWidth, bowHeight = 32, 32
local bowShootFrameTime = 0.1

Bow = Weapon:extend()

function Bow:new(game)
  Bow.super.new(self, game)

  self.isLoading = false
  self.loadingTime = 0
  self.maxLoadingTime = 2

  self.minPower = 5
  self.maxPower = 20

  self.firedArrows = {}

  self.lastShootTime = 0
  self.currentFrame = 1
  self.frames = {}
  for i=0,bowLoadingFrameNumber do
    table.insert(self.frames, love.graphics.newQuad(i * bowWidth, 0, bowWidth, bowHeight, bowImage:getWidth(), bowImage:getHeight()))
  end
end

function Bow:update(dt)
	Bow.super.update(self, dt)

  self.lastShootTime = self.lastShootTime + dt
  if self.lastShootTime >= bowShootFrameTime then
    self.currentFrame = 1
  end

  if self.isLoading then
    self.loadingTime = self.loadingTime + dt
    if self.loadingTime > self.maxLoadingTime then
      self.loadingTime = self.maxLoadingTime
    end

    self.currentFrame = math.floor(self.loadingTime * (bowLoadingFrameNumber - 1) / self.maxLoadingTime + 1)
  end

	for i=#self.firedArrows,1,-1 do
		self.firedArrows[i]:update(dt)
		if self.firedArrows[i]:canBeDestroyed() then
			table.remove(self.firedArrows, i)
		end
	end
end

function Bow:draw()
	Bow.super.draw(self)

  local mouseX, mouseY = love.mouse.getPosition()

	love.graphics.setColor(255, 255, 255)
  love.graphics.draw(bowImage, self.frames[self.currentFrame], self.position.x, self.position.y, (Vector(mouseX, mouseY) - self.position):angleTo(), 1, 1, bowWidth/2, bowHeight/2)

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

  self.lastShootTime = 0
  if self.currentFrame >= bowLoadingFrameNumber / 2 then
    self.currentFrame = bowLoadingFrameNumber + 1
  else
    self.currentFrame = 1
  end

  self.isLoading = false
  local shootPower = self.loadingTime * (self.maxPower - self.minPower) / self.maxLoadingTime + self.minPower

  local mouseX, mouseY = love.mouse.getPosition()
  table.insert(self.firedArrows, Arrow(self.game, self.position,  Vector(mouseX, mouseY), shootPower, true))
end

function Bow:shoot()
	Bow.super.shoot(self)
end

-- ---------------- Arrow -----------------------
local MOVING, HIT = 1, 2

local arrowImage = love.graphics.newImage("ressources/arrow.png")
local arrowWidth, arrowHeight = 32, 32
local arrowframeNumber = 6
local movingAnimationSpeed = 1/24
local hitAnimationSpeed = 1/12

Arrow = Ammo:extend()

local gravity = 10

function Arrow:new(game, initialPosition, mousePos, power, isAlly)
	Arrow.super.new(self, game, initialPosition, isAlly)

  self.velocity = (mousePos - self.position):normalized() * power

	self.width = 32
	self.height = 32

  self.hitEntity = nil
  self.positionOffset = nil

  self.frames = {}
  self.currentState = MOVING
  self.currentFrame = 1
  self.lastFrameChange = 0
  self.animationSpeed = movingAnimationSpeed

  for i=MOVING,HIT do
    self.frames[i] = {}
    for j=0,arrowframeNumber-1 do
      table.insert(self.frames[i], love.graphics.newQuad(j * arrowWidth, (i-1) * arrowHeight, arrowWidth, arrowHeight, arrowImage:getWidth(), arrowImage:getHeight()))
    end
  end
end

function Arrow:update(dt)
	Arrow.super.update(self, dt)
	self:move(dt)

  if self.currentState == MOVING and self:isColliding() then
    self.currentState = HIT
    self.currentFrame = 1
    self.animationSpeed = hitAnimationSpeed
    self.lastFrameChange = 0
  end

  -- Animation
  self.lastFrameChange = self.lastFrameChange + dt

  if self.lastFrameChange >= self.animationSpeed then
    self.currentFrame = self.currentFrame + 1
    if self.currentFrame > arrowframeNumber then
      if  self.currentState == MOVNG then
        self.currentFrame = 1
      else
        self.currentFrame = arrowframeNumber
      end
    end

    self.lastFrameChange = 0
  end
end

function Arrow:draw()
	Arrow.super.draw(self)

	love.graphics.setColor(255, 255, 255)
  love.graphics.draw(arrowImage, self.frames[self.currentState][self.currentFrame], self.position.x, self.position.y, self.velocity:angleTo(), 1, 1, arrowWidth/2, arrowHeight/2)
end

function Arrow:move(dt)
  if self.currentState == MOVING then
    self.velocity.y = self.velocity.y + gravity * dt
    self.position = self.position + self.velocity
  else
    if self.hitEntity ~= nil then
      self.position = self.hitEntity.position - self.positionOffset
    end
  end
end

function Arrow:isColliding()
  local headPosition = self.position + self.velocity:normalized() * self.width/2

  -- Map collision
  if self.game.map:isPixelPosSolid(headPosition) then
		return true
	end

	-- enemy collision
	for i,entity in ipairs(self.game.entities) do
		if self.isAlly and entity:is(Enemy) then
			if entity:isPositionColliding(headPosition) then
        self.hitEntity = entity
        self.positionOffset = entity.position - self.position
				entity:getDamaged(1)
			  return true
			end
		elseif not self.isAlly and entity:is(Player) then
			if entity:isPositionColliding(headPosition) then
        self.hitEntity = entity
        self.positionOffset = entity.position - self.position
				entity:getDamaged(1)
			  return true
			end
		end
	end

	return false
end

function Arrow:canBeDestroyed()
  return self.currentState == HIT and self.currentFrame == arrowframeNumber
end
