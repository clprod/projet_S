PauseMenu = {}

function PauseMenu:init()
  love.window.setTitle("Project_S - PauseMenu")
end

function PauseMenu:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf("Pause\npress 'exc' to resume", love.graphics.getWidth()/4, love.graphics.getHeight()/2, love.graphics.getWidth()/2, "center")
end

function PauseMenu:keypressed(key)
  GameState.switch(Game)
end
