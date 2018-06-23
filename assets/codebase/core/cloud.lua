cloud = class("cloud")

function cloud:initialize()
	self.x = -100
	self.y = 145

	self.image = love.graphics.newImage("assets/gfx/images/cloud.png")
end

function cloud:update(dt)
	self.x = self.x + 15*dt

	if self.x > game.width then 
		self.x = -100
	end
end

function cloud:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.image, self.x, self.y, 0, 3, 3)
end