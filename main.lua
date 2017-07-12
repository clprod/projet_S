GameState = require "libraries.hump.gamestate"
Vector = require "libraries.hump.vector"
Object = require "libraries.classic.classic"
Tools = require "libraries.tools"

require "main-menu"
require "game"


function love.load()
  GameState.registerEvents()
  GameState.switch(MainMenu)
end
