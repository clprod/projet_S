require "pause-menu"
require "shop-menu"

require "player"
require "map"
require "weapon"
require "gun"
require "grenade-launcher"
require "bow"
require "eye"
require "ghost"
require "grapnel"

Game = {}

local cursor = love.graphics.newImage("ressources/cursorRedduce.png")

function Game:enter()
  love.window.setTitle("Project_S - Game")

  -- Cursor is grabbed and not visible
  Tools.CursorRendering(true, false)

  self.map = Map()

  self.entities = {}

  self.player = Player(self, self.map:getSpawnPosition())
  -- Submachine
  self.player:equip(Gun(self, 600, 0.15, 10, 1, 1))
  -- Bow
  -- self.player:equip(Bow(self))
  -- Grenade launcher
  -- self.player:equip(GrenadeLauncher(self))

  table.insert(self.entities, self.player)
  table.insert(self.entities, Eye(self, Vector(663, 230)))
  table.insert(self.entities, Eye(self, Vector(163, 230)))
  table.insert(self.entities, Eye(self, Vector(363, 60)))
  table.insert(self.entities, Eye(self, Vector(400, 300)))
  table.insert(self.entities, Ghost(self, Vector(700, 500)))
  table.insert(self.entities, Ghost(self, Vector(100, 100)))
end

function Game:resume()
  love.window.setTitle("Project_S - Game")
  Tools.CursorRendering(true, false)
end

function Game:update(dt)
  self.map:update(dt)

  for i,entity in ipairs(self.entities) do
    entity:update(dt)

    if entity:isDead() then
      table.remove(self.entities, i)
    end
  end

  if self.player.lifeCpt == 0 then
    for i,entity in ipairs(self.entities) do
      table.remove(self.entities, i)
      GameState.switch(MainMenu)
    end
  end

  -- check victory conditions
  -- If only player remains
  if #self.entities == 1 then
    for i,entity in ipairs(self.entities) do
      if entity == self.player then
      -- Switch to score menu or next level
      GameState.switch(MainMenu)
      end
    end
  end
end

function Game:draw()
  self.map:draw()

  for i,entity in ipairs(self.entities) do
    entity:draw()
  end

  Tools.DrawCursor(cursor)
  -- Print debug data
  love.graphics.setColor(0, 255, 0)
  love.graphics.print("fps: "..love.timer.getFPS(), 12, 12)
end

function Game:keypressed(key)
  if key == "escape" then
    GameState.push(ShopMenu)
  end
end
