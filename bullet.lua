

Bullet = Ammo:extend()

bulletSpeed = 10

function Bullet:new(game, direction)
	Bullet.super:new(game, direction)
	self.maxSpeed = 20
	print("Bullet created")
end

function Bullet:update(dt)
	print("bullet is moving")
	Bullet.super:update(dt)
end

function Bullet:draw()
	print("draw")
	Bullet.super:draw()
	love.graphics.setColor(255, 0, 0)
  	love.graphics.circle("fill", self.position.x, self.position.y, 50, 6)
end

--function Bullet:shoot()
--	self.lastTimeShoot = Gun.super:shoot(self.lastTimeShoot, self.loadingTime)
--end
