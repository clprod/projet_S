require "player"
require "map"
require "weapon"
require "gun"

Game = {}

function Game:init()
  love.window.setTitle("Project_S - Game")

  self.map = Map()
  love.window.setTitle("Project_S - Game")
  self.player = Player()
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
end
