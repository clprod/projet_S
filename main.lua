GameState = require "libraries.hump.gamestate"

require "main-menu"
require "game"

function love.load()
  GameState.registerEvents()
  GameState.switch(MainMenu)
end
