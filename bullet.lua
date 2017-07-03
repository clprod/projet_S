

Bullet = Ammo:extend()

function Bullet:new(game, mousePos)
	Bullet.super.new(self, game, mousePos)
	self.maxSpeed = 30
	self.width = 5
	self.height = 5
end

function Bullet:update(dt)
	Bullet.super.update(self, dt)
end

function Bullet:draw()
	Bullet.super.draw(self)
	love.graphics.setColor(255, 0, 0)
	love.graphics.circle("fill", self.position.x, self.position.y, self.width, 6)
end
