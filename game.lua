require "pause-menu"

require "player"
require "map"
require "weapon"
require "gun"
require "grenade-launcher"
require "eye"
require "ghost"

Game = {}

function Game:init()
  self.map = Map()

  self.entities = {}

  self.player = Player(self, self.map:getSpawnPosition())
  self.player:equip(Gun(self))

  table.insert(self.entities, self.player)
  table.insert(self.entities, Eye(self, Vector(663, 230)))
  table.insert(self.entities, Eye(self, Vector(163, 230)))
  table.insert(self.entities, Eye(self, Vector(363, 60)))
  table.insert(self.entities, Eye(self, Vector(400, 300)))
  table.insert(self.entities, Ghost(self, Vector(700, 500)))
end

function Game:enter()
  love.window.setTitle("Project_S - Game")
end

function Game:update(dt)
  self.map:update(dt)

  for i,entity in ipairs(self.entities) do
    entity:update(dt)

    if entity:isDead() then
      table.remove(self.entities, i)
    end
  end
end

function Game:draw()
  self.map:draw()

  for i,entity in ipairs(self.entities) do
    entity:draw()
  end

  -- Print debug data
  love.graphics.setColor(0, 255, 0)
  love.graphics.print("fps: "..love.timer.getFPS(), 12, 12)
end

function Game:keypressed(key)
  if key == "escape" then
    GameState.switch(PauseMenu)
  end
end
