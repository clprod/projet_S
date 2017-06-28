GameState = require "libraries.hump.gamestate"
Vector = require "libraries.hump.vector"
Object = require "libraries.classic.classic"

require "main-menu"
require "game"

function love.load()
  GameState.registerEvents()
  GameState.switch(MainMenu)
end
