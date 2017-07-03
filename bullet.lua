

Bullet = Ammo:extend()

bulletImage = love.graphics.newImage("ressources/fire.png")

function Bullet:new(game, initialPosition, mousePos)
	Bullet.super.new(self, game, initialPosition)
	self.origin = initialPosition
	self.direction = mousePos
	self.speed = 2000
	self.width = bulletImage:getWidth()
	self.height = bulletImage:getHeight()
end

function Bullet:update(dt)
	Bullet.super.update(self, dt)
	self:move(dt)
end

function Bullet:draw()
	Bullet.super.draw(self)
	--love.graphics.reset()
	love.graphics.draw(bulletImage, self.position.x, self.position.y, 1, 1, 1, self.width, self.height)

end

function Bullet:move(dt)
	self.position = self.position + self.direction * self.speed * dt
end
