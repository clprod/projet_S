Healthbar = Object:extend()

function Healthbar:new(owner, maxHealth)
  self.owner = owner

  self.maxHealth = maxHealth or owner.lifeCpt
  self.currentHealth = maxHealth or owner.lifeCpt

  self.positionOffset = Vector(0, -35)
  self.position = owner.position + self.positionOffset
  self.maxWidth = 50
  self.height = 5
end

function Healthbar:update(dt)
  self.currentHealth = self.owner.lifeCpt
  self.position = self.owner.position + self.positionOffset
end

function Healthbar:draw()
  if self.maxHealth == self.currentHealth then
    return
  end

  local width = self.currentHealth * self.maxWidth / self.maxHealth

  local currentHealthRatio = self.currentHealth / self.maxHealth

  if currentHealthRatio <= 0.25 then
    love.graphics.setColor(255, 0, 0)
  elseif currentHealthRatio <= 0.5 then
    love.graphics.setColor(125, 125, 0)
  elseif currentHealthRatio <= 0.75 then
    love.graphics.setColor(55, 200, 0)
  else
    love.graphics.setColor(0, 255, 0)
  end

  love.graphics.rectangle("fill", self.position.x - width/2, self.position.y - self.height/2, width, self.height)
end
