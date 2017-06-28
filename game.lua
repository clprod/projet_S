require "player"
require "map"

Game = {}

function Game:init()
  love.window.setTitle("Project_S - Game")

  self.map = Map()
  self.player = Player()
end

function Game:update(dt)
  self.map:update(dt)
  self.player:update(dt)
end

function Game:draw()
  self.map:draw()
  self.player:draw()
end
