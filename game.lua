require "player"

Game = {}

function Game:init()
  love.window.setTitle("Project_S - Game")

  self.player = Player()
end

function Game:update(dt)
  self.player:update(dt)
end

function Game:draw()
  self.player:draw()
end
