

Bullet = Ammo:extend()

bulletSpeed = 10

function Bullet:new(game, mousePos)
	Bullet.super:new(game, mousePos)
	self.maxSpeed = 30
	self.width = 5
	self.super.width = self.width
	self.height = 5
	self.super.height = self.width
end

function Bullet:update(dt)
	Bullet.super:update(dt)
end

function Bullet:draw()
	Bullet.super:draw()
	love.graphics.setColor(255, 0, 0)
  	love.graphics.circle("fill", self.position.x, self.position.y, self.width, 6)
end
