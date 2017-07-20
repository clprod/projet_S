require "entity"


Shop = Entity:extend()
------------------- ShopMenu -----------------------

ShopMenu = {}

local shopEntities = {}

function ShopMenu:init()
  self.shop = Shop()
  table.insert(shopEntities, self.shop)
end

function ShopMenu:enter()
  -- Cursor is not grabbed and is visible
  Tools.CursorRendering(false, true)
  love.window.setTitle("Project_S - ShopMenu")
end

function ShopMenu:draw()
  for i,entity in ipairs(shopEntities) do
    entity:draw()
  end

  love.graphics.setColor(255, 255, 255)
  love.graphics.printf("Shop\npress 'exc' to resume game\npress 'o' to open shop\npress 'c' to close shop", 0, love.graphics.getHeight() - love.graphics.getHeight()/6, love.graphics.getWidth(), "center")
end

function ShopMenu:update(dt)
  for i,entity in ipairs(shopEntities) do
    entity:update(dt)
  end
end

function ShopMenu:keypressed(key)
  if key == "escape" then
    GameState.pop()
  elseif key == "o" then
    self.shop:open()
  elseif key == "c" then
    self.shop:close()
  end
end

------------------- Shop -----------------------

local shopImage = love.graphics.newImage("ressources/shop/shop.png")
local shopFrameNumber = 12
local shopAnimationSpeed = 1/12
local shopWidth, shopHeight = 256, 256
local OPENING, CLOSING, IDLE = 1, 2, 3

function Shop:new()
  self.position = Vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2)

  self.currentFrame = 1
  self.lastFrameChange = 0
  self.frames = {}

  self.currentState = IDLE

  local framePerLine = shopImage:getWidth() / shopWidth
  for i=0, shopFrameNumber-1 do
    table.insert(self.frames, love.graphics.newQuad((i % framePerLine) * shopWidth, math.floor(i / framePerLine) * shopHeight, shopWidth, shopHeight, shopImage:getWidth(), shopImage:getHeight()))
  end
end

function Shop:update(dt)
  self.lastFrameChange = self.lastFrameChange - dt
  self:updateFrame(dt)
  self:updateState()
end

function Shop:draw()
  love.graphics.draw( shopImage,
                      self.frames[self.currentFrame],
                      self.position.x,
                      self.position.y,
                      0, 1, 1,
                      shopWidth/2,
                      shopHeight/2)
end

function Shop:updateFrame(dt)
  if self.lastFrameChange <= 0 then
    self.lastFrameChange = shopAnimationSpeed
    if self.currentState == OPENING then
      if self.currentFrame < shopFrameNumber then
        self.currentFrame = self.currentFrame + 1
      end
    end
    if self.currentState == CLOSING then
      if self.currentFrame > 1 then
        self.currentFrame = self.currentFrame - 1
      end
    end
  end
end

function Shop:updateState()
  if self.currentState == OPENING and self.currentFrame == shopFrameNumber then
    self:setState(IDLE)
  elseif self.currentState == CLOSING and self.currentFrame == 1 then
    self:setState(IDLE)
  end
end

function Shop:open()
  self:setState(OPENING)
end

function Shop:close()
  self:setState(CLOSING)
end

function Shop:setState(state)
  self.currentState = state
end

------------------- ShopMan -----------------------

local shopManImage = love.graphics.newImage("ressources/shop/shop.png")
local shopManLoadingFrameNumber = 4
local shopManWidth, shopHeight = 32, 32
local shopManFrameTime = 0.1
ShopMan = Entity:extend()