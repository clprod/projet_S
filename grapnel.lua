require "weapon"
require "ammo"

-- ---------------- Grapnel -----------------------

Grapnel = Weapon:extend()
local shootPower = 12
local ropeImage = love.graphics.newImage("ressources/hook/rope.png")
local gravity = 8
local hookImageScale = 0.4

function Grapnel:new(game)
  Grapnel.super.new(self, game)

  self.firedHook = nil
  self.firedRope = {}

end

function Grapnel:update(dt)
	Grapnel.super.update(self, dt)

  if self.firedHook ~= nil then
    self.firedHook:update(dt)
    if self.firedHook:canBeDestroyed() then
      self.firedHook = nil
      for i=#self.firedRope,1,-1 do
    			table.remove(self.firedRope, i)
    	end
    end
  end
end

function Grapnel:draw()
	Grapnel.super.draw(self)

	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", self.position.x - self.width/2, self.position.y - self.height/2, self.width, self.height)
  if self.firedHook ~= nil then
    self.firedHook:draw()
    table.insert(self.firedRope, {self.firedHook:getPosAndAngle()})
    for i, tabValues in ipairs(self.firedRope) do
      if i ~= #self.firedRope then
        love.graphics.draw(ropeImage, tabValues[1], tabValues[2], tabValues[3], hookImageScale, hookImageScale, 16, 16)
      end
    end
  end
end

function Grapnel:onShootPressed()
	Grapnel.super.onShootPressed(self)
  local mouseX, mouseY = love.mouse.getPosition()
  if self.firedHook == nil then
    self.firedHook = Hook(self.game, self.position,  Vector(mouseX, mouseY), shootPower, true)
  end

end

function Grapnel:onShootReleased()
	Grapnel.super.onShootReleased(self)

end

function Grapnel:shoot()
	Grapnel.super.shoot(self)
end

-- ---------------- Hook -----------------------
local MOVING, HIT = 1, 2

local hookImage = love.graphics.newImage("ressources/hook/hook.png")
local frameWidth, frameHeight = 32, 32
local frameNumber = 1
local movingAnimationSpeed = 1/24
local hitAnimationSpeed = 1/12

Hook = Ammo:extend()



function Hook:new(game, initialPosition, mousePos, power, isAlly)
	Hook.super.new(self, game, initialPosition, isAlly)

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
    for j=0,frameNumber-1 do
      table.insert(self.frames[i], love.graphics.newQuad(j * frameWidth, (i-1) * frameHeight, frameWidth, frameHeight, hookImage:getWidth(), hookImage:getHeight()))
    end
  end

end

function Hook:update(dt)
	Hook.super.update(self, dt)
	self:move(dt)

  if self.currentState == MOVING and self:isColliding() then
    self.currentState = HIT
  end
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
    if self.currentFrame > frameNumber then
      if  self.currentState == MOVING then
        self.currentFrame = 1
      else
        self.currentFrame = frameNumber
      end
    end

    self.lastFrameChange = 0
  end
end

function Hook:getPosAndAngle()
  return self.position.x, self.position.y, self.velocity:angleTo()
end

function Hook:draw()
	Hook.super.draw(self)
	love.graphics.setColor(255, 255, 255)
  love.graphics.draw(hookImage, self.frames[self.currentState][self.currentFrame], self.position.x, self.position.y, self.velocity:angleTo(), hookImageScale, hookImageScale, frameWidth/2, frameHeight/2)


end

function Hook:move(dt)

  if self.currentState == MOVING then
    self.velocity.y = self.velocity.y + gravity * dt
    self.position = self.position + self.velocity
  else
    if self.hitEntity ~= nil then
      self.position = self.hitEntity.position - self.positionOffset
    end
  end
end

function Hook:isColliding()
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

function Hook:canBeDestroyed()
  return self.currentState == HIT and self.currentFrame == frameNumber
end
