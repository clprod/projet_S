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

  self.player = Player(self)
  self.player:equip(GrenadeLauncher(self))

  self.enemy = Enemy(self)
end

function Game:update(dt)
  self.map:update(dt)
  self.player:update(dt)
  self.enemy:update(dt)
end

function Game:draw()
  self.map:draw()
  self.player:draw()
  self.enemy:draw()

  -- Print debug data
  love.graphics.setColor(0, 255, 0)
  love.graphics.print("fps: "..love.timer.getFPS(), 12, 12)
end
