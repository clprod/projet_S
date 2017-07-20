require "entity"


Shop = Entity:extend()
------------------- ShopMenu -----------------------

ShopMenu = {}

local shopEntities = {}

function ShopMenu:enter()
  -- Cursor is not grabbed and is visible
  Tools.CursorRendering(false, true)
  love.window.setTitle("Project_S - ShopMenu")
  table.insert(shopEntities, Shop())
end

function ShopMenu:draw()
  for i,entity in ipairs(shopEntities) do
    entity:draw()
  end

  love.graphics.setColor(255, 255, 255)
  love.graphics.printf("Pause\npress 'exc' to resume", 0, love.graphics.getHeight() - love.graphics.getHeight()/6, love.graphics.getWidth(), "center")
end

function ShopMenu:update(dt)
  for i,entity in ipairs(shopEntities) do
    entity:update(dt)
  end
end

function ShopMenu:keypressed(key)
  GameState.pop()
end

------------------- Shop -----------------------

local shopImage = love.graphics.newImage("ressources/shop/shop.png")
local shopFrameNumber = 12
local shopWidth, shopHeight = 256, 256
local OPENING, CLOSING, IDLE = 1, 2, 3

function Shop:new()
  self.position = Vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
  self.isOpen = false
  self.isClose = true
  self.openingTime = 2
  self.moovingTime = 0
  self.currentFrame = 1
  self.frames = {}
  self.currentState = OPENING

  for i=1, shopFrameNumber do
    table.insert(self.frames, love.graphics.newQuad(i * shopWidth, 0, shopWidth, shopHeight, shopImage:getWidth(), shopImage:getHeight()))
  end
end

function Shop:update(dt)
  elapsed_time = os.difftime(self.moovingTime - self.openingTime)
  self:setFrame()
  self:setState()
end

function Shop:draw()
  print(self.currentFrame)
  love.graphics.draw( shopImage,
                      self.frames[self.currentFrame],
                      self.position.x,
                      self.position.y,
                      0, 1, 1,
                      shopWidth/2,
                      shopHeight/2)
end

function Shop:setFrame()
  if self.currentState == OPENING then
    print((self.openingTime * (shopFrameNumber + 1)), " / ", self.moovingTime+1)
    self.currentFrame = math.floor((self.moovingTime * (shopFrameNumber + 1)) / self.openingTime + 1)
  end
  if self.currentState == CLOSING then
    self.currentFrame = math.floor((self.moovingTime * (shopFrameNumber + 1)) / (self.openingTime -self.moovingTime) + 1)
  end
  if self.currentState == IDLE and self.isClose then
    self:open()
  end
end

function Shop:setState()
  if self.currentFrame == 1 then -- Dor is full full close
    self.currentState = IDLE
    self.moovingTime = 0
    self.isClose = true
  end
  if self.currentFrame == shopFrameNumber then -- Dor is full full open
    self.currentState = IDLE
    self.moovingTime = 0
    self.isOpen = true
  end
end

function Shop:open()
  print("OPEN")
  self.currentState = OPENING
  self.moovingTime = love.timer.getTime()
end

function Shop:close()
  self.currentState = CLOSING
  self.moovingTime = love.timer.getTime()
end
------------------- ShopMan -----------------------

local shopManImage = love.graphics.newImage("ressources/shop/shop.png")
local shopManLoadingFrameNumber = 4
local shopManWidth, shopHeight = 32, 32
local shopManFrameTime = 0.1
ShopMan = Entity:extend()
