require "player"
require "map"
require "weapon"
require "gun"



Game = {}

function Game:init()
  love.window.setTitle("Project_S - Game")

  self.map = Map()

  self.weapon = Gun(self)
  self.player = Player(self)

  self.player:equip(self.weapon)
  self.weapon:setOwner(self.player)
end

function Game:update(dt)
  self.map:update(dt)
  self.player:update(dt)
  self.weapon:update(dt)
  for key, value in pairs(self.weapon.firedBullets) do
  	value.update(dt)
  end
end

function Game:draw()
  self.map:draw()
  self.player:draw()
  self.weapon:draw()
  for key, value in pairs(self.weapon.firedBullets) do
  	value.draw(dt)
  end

  
  -- Print debug data
  love.graphics.setColor(0, 255, 0)
  love.graphics.print("fps: "..love.timer.getFPS(), 12, 12)
  

end
