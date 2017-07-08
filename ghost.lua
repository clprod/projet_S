Ghost = Enemy:extend()

local DEAD, ATTACKING, MOVING = 0, 1, 2

local ghostImage = love.graphics.newImage("ressources/ghostIce_all.png")

local ghostMaxHealth = 3

local ghostWidth = 32
local ghostHeight = 32
local ghostSpriteScale = 1.5
local frameNumber = {}
frameNumber[MOVING] = 4
frameNumber[ATTACKING] = 0
frameNumber[DEAD] = 9

function Ghost:new(game, position)
  Ghost.super.new(self, game, position, ghostMaxHealth)

  self.width = ghostWidth * ghostSpriteScale
  self.height = ghostHeight * ghostSpriteScale

  self.velocity = Vector(0, 0)
  self.speed = 70

  self.frames = {}
  for state=DEAD,MOVING do
    self.frames[state] = {}
    for i=0,frameNumber[state] do
      table.insert(self.frames[state], love.graphics.newQuad(i * ghostWidth, state * ghostHeight, ghostWidth, ghostHeight, ghostImage:getWidth(), ghostImage:getHeight()))
    end
  end

  self.currentState = MOVING
  self.currentFrame = 1
  self.lastFrameChange = 0
  self.animationSpeed = math.random(18, 24) / 100
end

function Ghost:update(dt)
  Ghost.super.update(self, dt)

  -- Animation
  self.lastFrameChange = self.lastFrameChange + dt

  if self.lastFrameChange >= self.animationSpeed then
    self.currentFrame = self.currentFrame + 1
    if self.currentState == MOVING then
      if self.currentFrame > frameNumber[self.currentState] then
        self.currentFrame = 1
      end
    end

    self.lastFrameChange = 0
  end

  if self.lifeCpt <= 0 then
    self.currentState = DEAD
  end
end

function Ghost:draw()
  love.graphics.setColor(255, 255, 255)

  local scale = ghostSpriteScale
  if self.position.x > self.game.player.position.x then
    scale = scale * -1
  end

  love.graphics.draw(ghostImage, self.frames[self.currentState][self.currentFrame], self.position.x, self.position.y, 0, scale, ghostSpriteScale, ghostWidth/2, ghostHeight/2)

  Ghost.super.draw(self)
end

function Ghost:move(dt)
  Ghost.super.move(self, dt)

  if self.currentState ~= MOVING then
    return
  end

  if self.position:dist(self.game.player.position) <= self.width/2 + self.game.player.width/2 then
    return
  end

  local direction = (self.game.player.position - self.position):normalized()

  self.position = self.position + direction * self.speed * dt
end

function Ghost:isPositionColliding(position)
  if self.currentState == DEAD then
    return false
  end

  return Ghost.super.isPositionColliding(self, position)
end

function Ghost:isDead()
  return self.currentState == DEAD and self.currentFrame > frameNumber[DEAD]
end
