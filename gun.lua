require "weapon"

Gun = Weapon:extend()

function Gun:new(owner)
	Gun.super:new(owner)
	self.loadingTime = 1
	self.name = "gun"
end

function Gun:update(dt)
	Gun.super:update(dt)
end

function Gun:draw()
	Gun.super:update()
end

function Gun:shoot()
	if self.lastTimeShoot + self.loadingTime > love.timer.getTime() then
		Gun.super:shoot(self.lastTimeShoot, self.loadingTime)
	end
end

