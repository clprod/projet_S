Ghost = Enemy:extend()

local WALKING = 0

local ghostImage = love.graphics.newImage("ressources/ghostIce_all.png")

local ghostMaxHealth = 3

local ghostWidth = 32
local ghostHeight = 32
local ghostSpriteScale = 1.5
local walkingFrameNumber = 4

function Ghost:new(game, position)
  Ghost.super.new(self, game, position, ghostMaxHealth)

  self.width = ghostWidth * ghostSpriteScale
  self.height = ghostHeight * ghostSpriteScale

  self.velocity = Vector(0, 0)

  self.frames = {}
  self.frames[WALKING] = {}
  for i=0,walkingFrameNumber-1 do
    table.insert(self.frames[WALKING], love.graphics.newQuad(i * ghostWidth, 64, ghostWidth, ghostHeight, ghostImage:getWidth(), ghostImage:getHeight()))
  end
end

function Ghost:update(dt)
  Ghost.super.update(self, dt)
end

function Ghost:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(ghostImage, self.frames[WALKING][1], self.position.x - self.width/2, self.position.y - self.height/2, 0, ghostSpriteScale, ghostSpriteScale)

  Ghost.super.draw(self)
end

function Ghost:move(dt)
  Ghost.super.move(self, dt)
end
