Bullet = Ammo:extend()

local bulletImages = {}
bulletImages[0] = love.graphics.newImage("ressources/fire.png")
bulletImages[1] = love.graphics.newImage("ressources/fire2.png")

function Bullet:new(game, initialPosition, targetPosition, isAlly, speed, bulletImageId)
	Bullet.super.new(self, game, initialPosition, isAlly)

	self.direction = (targetPosition - self.position):normalized()
	self.speed = speed
	self.bulletImageId = bulletImageId or 0
	self.width = bulletImages[self.bulletImageId]:getWidth()
	self.height = bulletImages[self.bulletImageId]:getHeight()
end

function Bullet:update(dt)
	Bullet.super.update(self, dt)
	self:move(dt)
end

function Bullet:draw()
	Bullet.super.draw(self)

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(bulletImages[self.bulletImageId], self.position.x, self.position.y, self.direction:angleTo(), 1, 1, self.width/2, self.height/2)

end

function Bullet:move(dt)
	self.position = self.position + self.direction * self.speed * dt
end
