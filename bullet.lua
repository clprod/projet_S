Bullet = Ammo:extend()

local bulletImage = love.graphics.newImage("ressources/fire.png")

function Bullet:new(game, initialPosition, mousePos, isAlly)
	Bullet.super.new(self, game, initialPosition, isAlly)
	self.origin = initialPosition
	self.direction = (mousePos - self.position):normalized()
	self.speed = 500
	self.width = bulletImage:getWidth()
	self.height = bulletImage:getHeight()
end

function Bullet:update(dt)
	Bullet.super.update(self, dt)
	self:move(dt)
end

function Bullet:draw()
	Bullet.super.draw(self)

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(bulletImage, self.position.x, self.position.y, self.direction:angleTo(), 1, 1, self.width/2, self.height/2)

end

function Bullet:move(dt)
	self.position = self.position + self.direction * self.speed * dt
end
