require "entity"
require "ammo"
require "bullet"

Weapon = Entity:extend()

function Weapon:new(game)
	Entity.super:new(game)
	self.position = nill
	self.owner = nill
	self.width, self.height = 8, 8
	self.loadingTime = nil
	self.shootingPower = nil
	self.lastTimeShoot = love.timer.getTime()
	self.loadingTime = nil
	self.firedBullets = {}
end

function Weapon:update(dt)
	Weapon.super:update(dt)
	self.position = self.owner.position

end

function Weapon:draw()
	Weapon.super:draw()
	love.graphics.setColor(255, 0, 0)
  	love.graphics.rectangle("fill", self.position.x - self.width/2, self.position.y - self.height/2, self.width, self.height)
end

function Weapon:shoot()
	if love.timer.getTime() - self.loadingTime > self.lastTimeShoot then
		mouseX, mouseY = love.mouse.getPosition()
		table.insert(self.firedBullets, Bullet(self.game, Vector(mouseX, mouseY)))
		self.lastTimeShoot = love.timer.getTime()
		print("pan")
	end
	return self.lastTimeShoot
end

function Weapon:setOwner(owner)
	self.owner = owner
	self.position = self.owner.position
end
