require "entity"
require "ammo"
require "bullet"

Weapon = Entity:extend()

function Weapon:new(game)
	Weapon.super.new(self, game)
	self.position = nil
	self.owner = nil
	self.width, self.height = 8, 8
end

function Weapon:update(dt)
	Weapon.super.update(self, dt)
	self.position = self.owner.position
end

function Weapon:draw()
	Weapon.super.draw(self)
end

function Weapon:onShootPressed()
end

function Weapon:onShootReleased()
end

function Weapon:shoot()
end

function Weapon:setOwner(owner)
	self.owner = owner
	self.position = self.owner.position
end
