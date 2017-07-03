require "weapon"

Gun = Weapon:extend()

function Gun:new(game)
	Gun.super.new(self, game)
	self.loadingTime = 0.2
	self.name = "gun"
	self.shootingPower = 50

	self.super.loadingTime = self.loadingTime
end

function Gun:update(dt)
	Gun.super.update(self, dt)
end

function Gun:draw()
	Gun.super.draw(self)
end

function Gun:shoot()
	self.lastTimeShoot = Gun.super.shoot(self, self.lastTimeShoot, self.loadingTime)
end

function Gun:setOwner(owner)
	Gun.super.setOwner(self, owner)
end
