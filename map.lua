Map = Entity:extend()

local mapTileset = love.graphics.newImage("ressources/mapTileset.png")

function Map:new()
  self.super.new(self)

  self.name = "map0"
  self:init("maps/map0.lua")
end

function Map:init(filename)
  local levelTmp = love.filesystem.load(filename)()

  self.grid = levelTmp.grid

  self.height = #self.grid
  self.width = #self.grid[1]

  self.tileWidth, self.tileHeight = love.graphics.getWidth()/self.width, love.graphics.getHeight()/self.height

  self.spriteBatch = love.graphics.newSpriteBatch(mapTileset, self.width * self.height)

  self.quads = {}
  self.quads[0] = love.graphics.newQuad(0, 0, self.tileWidth, self.tileHeight, mapTileset:getWidth(), mapTileset:getHeight())
  self.quads[1] = love.graphics.newQuad(self.tileWidth, 0, self.tileWidth, self.tileHeight, mapTileset:getWidth(), mapTileset:getHeight())

  self:updateSpriteBatch()
end

function Map:updateSpriteBatch()
  self.spriteBatch:clear()

  for x=1,self.width do
    for y=1,self.height do
      local quadId = nil
      if self:isSolid(x, y) then
        quadId = 0
      else
        quadId = 1
      end

      self.spriteBatch:add(self.quads[quadId], (x-1) * self.tileWidth, (y-1) * self.tileHeight)
    end
  end

  self.spriteBatch:flush()
end

function Map:update(dt)
  self.super.update(self, dt)
end

function Map:draw()
  self.super.draw(self)

  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(self.spriteBatch, 0, 0)
end

function Map:isSolid(x, y)
  x, y = math.floor(x), math.floor(y)
  if x < 1 or x > self.width or y < 1 or y > self.height then
    return true
  end

  return self.grid[y][x] == 1
end

function Map:isPixelPosSolid(pos)
  return self:isSolid(pos.x / self.tileWidth + 1, pos.y / self.tileHeight + 1)
end

function Map:getSpawnPosition()
  for x=1,self.width do
    for y=1,self.height do
      if self.grid[y][x] == 2 then
        return Vector(x * self.tileWidth, y * self.tileHeight)
      end
    end
  end

  return Vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
end


function Map:solidBetween(posFrom, posDest)
  local direction = (posDest - posFrom):normalized()
  local step = 16
  local iterations = math.ceil(posFrom:dist(posDest) / step)

  for i=0,iterations do
    local pos = posFrom + direction * step * i
    if self:isPixelPosSolid(pos) then
      return true
    end
  end

  return false
end
