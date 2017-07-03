

Bullet = Ammo:extend()

function Bullet:new(game, initialPosition, mousePos)
	Bullet.super.new(self, game, initialPosition)
	self.direction = (mousePos - self.position):normalized()
	self.speed = 500
	self.width = 5
	self.height = 5
end

function Bullet:update(dt)
	Bullet.super.update(self, dt)

	self:move(dt)
end

function Bullet:draw()
	Bullet.super.draw(self)
	love.graphics.setColor(255, 0, 0)
	love.graphics.circle("fill", self.position.x, self.position.y, self.width, 6)
end

function Bullet:move(dt)
	self.position = self.position + self.direction * self.speed * dt
end
