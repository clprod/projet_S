require "weapon"

Gun = Weapon:extend()

function Gun:new(game, shootingPower, loadingTime, bulletType)
	Gun.super.new(self, game)

	self.shootingPower = shootingPower or 500
	self.loadingTime = loadingTime or 0.2
	self.lastTimeShoot = 0
	self.isShooting = false
	self.bulletType = bulletType

	self.firedBullets = {}
end

function Gun:update(dt)
	Gun.super.update(self, dt)

	self.lastTimeShoot = self.lastTimeShoot + dt

	if self.isShooting then
		self:shoot()
	end

	for i=#self.firedBullets,1,-1 do
		self.firedBullets[i]:update(dt)
		if self.firedBullets[i]:isColliding() then
			table.remove(self.firedBullets, i)
		end
	end
end

function Gun:draw()
	Gun.super.draw(self)

	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", self.position.x - self.width/2, self.position.y - self.height/2, self.width, self.height)

	for i,bullet in ipairs(self.firedBullets) do
		bullet:draw()
	end
end

function Gun:onShootPressed()
	Gun.super.onShootPressed(self)

	self.isShooting = true
end

function Gun:onShootReleased()
	Gun.super.onShootReleased(self)

	self.isShooting = false
end

function Gun:shoot()
	Gun.super.shoot(self)

	if self.lastTimeShoot >= self.loadingTime then
		local mouseX, mouseY = love.mouse.getPosition()
		table.insert(self.firedBullets, Bullet(self.game, self.position, Vector(mouseX, mouseY), true, self.shootingPower, self.bulletType))
		self.lastTimeShoot = 0
	end
end
