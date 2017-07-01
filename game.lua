require "player"
require "map"
require "weapon"
require "gun"



Game = {}

function Game:init()
  love.window.setTitle("Project_S - Game")

  self.map = Map()
  self.player = Player(self)
  self.weapon = Gun(self.player)

  self.player:equip(self.weapon)
end

function Game:update(dt)
  self.map:update(dt)
  self.player:update(dt)
  self.weapon:update(dt)
end

function Game:draw()
  self.map:draw()
  self.player:draw()
  self.weapon:draw()

  -- Print debug data
  love.graphics.print("fps: "..love.timer.getFPS(), 12, 12)
  

end
