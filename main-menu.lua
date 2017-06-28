MainMenu = {}

function MainMenu:init()
  love.window.setTitle("Project_S - MainMenu")
end

function MainMenu:update(dt)
end

function MainMenu:draw()
end

function MainMenu:keypressed(key)
  GameState.switch(Game)
end
