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
	self.bulletCounter = 0
end

function Weapon:update(dt)
	Weapon.super:update(dt)
	self.position = self.owner.position
	--Weapon:resetBulletCounter()
end

function Weapon:draw()
	Weapon.super:draw()
	love.graphics.setColor(255, 0, 0)
  	love.graphics.rectangle("fill", self.position.x - self.width/2, self.position.y - self.height/2, self.width, self.height)
end

function Weapon:shoot()
	if love.timer.getTime() - self.loadingTime > self.lastTimeShoot then
		mouseX, mouseY = love.mouse.getPosition()
		print("shoot: ",self.bulletCounter)
		self.firedBullets[self.bulletCounter] = Bullet(self.game, self.bulletCounter, Vector(mouseX, mouseY)) 
		--table.insert(self.firedBullets, Bullet(self.game, self.bulletCounter, Vector(mouseX, mouseY)))
		self.lastTimeShoot = love.timer.getTime()
		self.bulletCounter = self.bulletCounter + 1
		print("1 + bulletCounter: ",self.bulletCounter)
	end
	return self.lastTimeShoot
end

function Weapon:setOwner(owner)
	self.owner = owner
	self.position = self.owner.position
end

function Weapon:resetBulletCounter()
	-- prevent stack overflow... maybe
	if next(self.firedBullets) == nil then
		self.bulletCounter = 0
		print("raz bulletCounter: ",self.bulletCounter)
	end
end