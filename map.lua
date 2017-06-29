Map = Entity:extend()

function Map:new()
  self.super:new()

  self:init("maps/map0.lua")
end

function Map:init(filename)
  local levelTmp = love.filesystem.load(filename)()

  self.grid = levelTmp.grid

  self.height = #self.grid
  self.width = #self.grid[1]

  self.tileWidth, self.tileHeight = love.graphics.getWidth()/self.width, love.graphics.getHeight()/self.height
end

function Map:update(dt)
  self.super:update(dt)
end

function Map:draw()
  self.super:draw()

  for x=1,self.width do
    for y=1,self.height do
      if self:isSolid(x, y) then
        love.graphics.setColor(0, 0, 0)
      else
        love.graphics.setColor(50, 50, 50)
      end

      love.graphics.rectangle("fill", (x-1) * self.tileWidth, (y-1) * self.tileHeight, self.tileWidth, self.tileHeight)
    end
  end
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
