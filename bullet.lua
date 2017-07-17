Bullet = Ammo:extend()

local bulletImages = {}
bulletImages[0] = love.graphics.newImage("ressources/fire.png")
bulletImages[1] = love.graphics.newImage("ressources/fire2.png")

function Bullet:new(game, initialPosition, targetPosition, isAlly, speed, bulletType)
	Bullet.super.new(self, game, initialPosition, isAlly)

	self.direction = (targetPosition - self.position):normalized()
	self.speed = speed
	self.bulletType = bulletType or 0
	self.width = bulletImages[self.bulletType]:getWidth()
	self.height = bulletImages[self.bulletType]:getHeight()
end

function Bullet:update(dt)
	Bullet.super.update(self, dt)
	self:move(dt)
end

function Bullet:draw()
	Bullet.super.draw(self)

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(bulletImages[self.bulletType], self.position.x, self.position.y, self.direction:angleTo(), 1, 1, self.width/2, self.height/2)

end

function Bullet:move(dt)
	self.position = self.position + self.direction * self.speed * dt
end
