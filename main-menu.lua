MainMenu = {}

function MainMenu:enter()
  love.window.setTitle("Project_S - MainMenu")
    -- Cursor is not grabbed and is visible
    Tools.CursorRendering(false, true)
end

function MainMenu:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf("Main menu\npress any key to continue", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
end

function MainMenu:keypressed(key)
  GameState.switch(Game)
end
