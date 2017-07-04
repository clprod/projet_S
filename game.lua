require "player"
require "map"
require "weapon"
require "gun"
require "grenade-launcher"
require "enemy"


Game = {}

function Game:init()
  love.window.setTitle("Project_S - Game")

  self.map = Map()

  self.entities = {}

  local player = Player(self)
  player:equip(GrenadeLauncher(self))

  table.insert(self.entities, player)
  table.insert(self.entities, Enemy(self, Vector(663, 230)))
  table.insert(self.entities, Enemy(self, Vector(163, 230)))
  table.insert(self.entities, Enemy(self, Vector(363, 60)))
  table.insert(self.entities, Enemy(self, Vector(400, 300)))
end

function Game:update(dt)
  self.map:update(dt)

  for i,entity in ipairs(self.entities) do
    entity:update(dt)
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
