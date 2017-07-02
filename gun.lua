require "weapon"

Gun = Weapon:extend()

function Gun:new(game)
	Gun.super:new(game)
	self.loadingTime = 1
	self.name = "gun"
	self.shootingPower = 10	

	self.super.loadingTime = self.loadingTime

end

function Gun:update(dt)
	Gun.super:update(dt)
end

function Gun:draw()
	Gun.super:draw()
end

function Gun:shoot()
	self.lastTimeShoot = Gun.super:shoot(self.lastTimeShoot, self.loadingTime)
end

function Gun:setOwner(owner)
	Gun.super:setOwner(owner)
end



