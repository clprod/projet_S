require "entity"
require "ammo"
require "bullet"

Weapon = Entity:extend()

function Weapon:new(game)
	Weapon.super:new(game)
	self.position = nil
	self.owner = nil
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

	for i=#self.firedBullets,1,-1 do
		self.firedBullets[i]:update(dt)
		if self.firedBullets[i]:isColliding() then
			table.remove(self.firedBullets, i)
		end
	end
end

function Weapon:draw()
	Weapon.super:draw()
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", self.position.x - self.width/2, self.position.y - self.height/2, self.width, self.height)

	for i,bullet in ipairs(self.firedBullets) do
		bullet:draw()
	end
end

function Weapon:shoot()
	if love.timer.getTime() - self.loadingTime > self.lastTimeShoot then
		mouseX, mouseY = love.mouse.getPosition()
		table.insert(self.firedBullets, Bullet(self.game, Vector(mouseX, mouseY)))
		self.lastTimeShoot = love.timer.getTime()
	end
	return self.lastTimeShoot
end

function Weapon:setOwner(owner)
	self.owner = owner
	self.position = self.owner.position
end
