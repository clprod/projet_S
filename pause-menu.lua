PauseMenu = {}

function PauseMenu:enter()
  love.window.setTitle("Project_S - PauseMenu")
end

function PauseMenu:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf("Pause\npress 'exc' to resume", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
end

function PauseMenu:keypressed(key)
  GameState.pop()
end
