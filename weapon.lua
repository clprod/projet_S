require "entity"

Weapon = Object:extend()

function Weapon:new(owner)
	self.owner = owner
	self.position = owner.position

	self.width, self.height = 8, 8
	self.lastTimeShoot = 0
	self.loadingTime = nil
end

function Weapon:update(dt)
	Weapon.super:update(dt)
	self.position = owner.position

end

function Weapon:draw()
	Weapon.super:update()
	love.graphics.setColor(100, 255, 255)
  	love.graphics.rectangle("fill", self.position.x - self.width/2, self.position.y - self.height/2, self.width, self.height)
end

function Weapon:shoot(lastTimeShoot, loadingTime)
	if lastTimeShoot + loadingTime > love.timer.getTime() then
		print "pan"
	end
end


			