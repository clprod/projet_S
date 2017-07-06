Entity = Object:extend()

function Entity:new(game)
 self.game = game
end

function Entity:update(dt)
end

function Entity:draw()
end

function Entity:delEntity()
  for key, value in pairs(self.game.entities) do
		if value == self then
			table.remove(self.game.entities, key)
		end
	end
end
