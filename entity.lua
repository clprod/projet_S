Entity = Object:extend()

function Entity:new(game)
 self.game = game
end

function Entity:update(dt)
end

function Entity:draw()
end

function Entity:delEntity(entity)
  for key, value in pairs(entity.game.entities) do
		if value == entity then
			table.remove(entity.game.entities, key)
		end
	end
end
