particle = class("particle") 

particles = {}

function particle:initialize(image, x, y, lifetime, dynamicSpeed)
	self.image = image
	self.x = x or 10 
	self.y = y or 10

	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.scale = self.width*(0.35*(game.width/400))

	self.rotation = math.random(0,360)
	self.xvel = math.random(-105, 105)
	self.yvel = math.random(-250, 50)

	self.age = 0
	self.lifetime = lifetime or 4

	self.dynamicSpeed = dynamicSpeed or true

	--goodRandom()

	self.id = #particles+1
	table.insert(particles, self)
end

function particle:update(dt)
	if self.dynamicSpeed then 
		self.yvel = self.yvel + 585*boulderSpeed*dt
	else
		self.yvel = 300*dt
	end

	self.x = self.x + self.xvel*dt
	self.y = self.y + self.yvel*dt 


	self.rotation = self.rotation + 4*dt

	self.age = self.age + dt

	if self.age >= self.lifetime then 
		particles[self.id] = nil
	end 
end

function particle:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale, self.scale, self.width/2, self.height/2)
end

function updateParticles(dt)
	for i, v in pairs(particles) do
		v:update(dt)
	end 
end

function drawParticles()
	for i, v in pairs(particles) do
		v:draw()
	end
end