require "weapon"

Gun = Weapon:extend()

local gunImages = {}
gunImages[0] = love.graphics.newImage("ressources/gun.png")

function Gun:new(game, shootingPower, loadingTime, spreadingPower, bulletImageId, weaponImageId)
	Gun.super.new(self, game)

	self.shootingPower = shootingPower or 500
	self.loadingTime = loadingTime or 0.2
	self.spreadingPower = spreadingPower or 0

	self.lastTimeShoot = 0
	self.isShooting = false
	self.bulletImageId = bulletImageId
	self.weaponImageId = weaponImageId

	self.width, self.height = gunImages[self.weaponImageId]:getWidth(), gunImages[self.weaponImageId]:getHeight()

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

  local mouseX, mouseY = love.mouse.getPosition()
	local rotation = (Vector(mouseX, mouseY) - self.position):angleTo()
	local scale = 1
	if self.position.x > mouseX then scale = -1 end

	love.graphics.setColor(255, 255, 255)
  love.graphics.draw(gunImages[self.weaponImageId], self.position.x, self.position.y, rotation, 1, scale, self.width/2, self.height/2)

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
		local bulletTarget = Vector(mouseX, mouseY)
		local targetNormal = (bulletTarget - self.position):perpendicular():normalized()

		local spread = (math.random() - 0.5) * 2 * self.spreadingPower

		bulletTarget = bulletTarget + targetNormal * spread

		table.insert(self.firedBullets, Bullet(self.game, self.position, bulletTarget, true, self.shootingPower, self.bulletImageId))
		self.lastTimeShoot = 0
	end
end
