GameState = require "libraries.hump.gamestate"
Object = require "libraries.classic.classic"

require "main-menu"
require "game"

function love.load()
  GameState.registerEvents()
  GameState.switch(MainMenu)
end
