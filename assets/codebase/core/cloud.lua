cloud = class("cloud")

function cloud:initialize()
	self.x = -100
	self.y = 145
	self.speed = math.random(10, 30)

	self.image = love.graphics.newImage("assets/gfx/images/cloud.png")
end

function cloud:update(dt)
	self.x = self.x + self.speed*dt

	if self.x > game.width then 
		self.x = -100
		self.speed = math.random(10, 30)
	end
end

function cloud:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.image, self.x, self.y, 0, 3, 3)
end