boulder = class("boulder")

local hasSpawned = false

boulders = {}
boulderInterval = 1.50
boulderSpeed = 1.5

local boulderTimer = 0
local bouldersCanSpawn = true

function boulder:initialize(x, y)
	self.width = boulderImage:getWidth() * 3
	self.height = boulderImage:getHeight() * 3
	self.x = x or math.random(1, game.width-self.width)
	self.y = y or -self.height-math.random(10)


	if game.stage.layer < 3 then 
		self.image = boulderImage
		self.particleImage = boulderParticleImage
		self.scale = 3
	else
		self.image = hellSkullImage
		self.particleImage = skullParticleImage
		self.scale = 1.15
	end

	self.speed = 320*boulderSpeed*(game.height/720)
	self.rotation = math.random(0, 360)


	if math.random(1, 2) == 1 then 
		self.direction = 1
	else
		self.direction = -1
	end


	self.type = "boulder"

	self.id = #boulders + 1
	table.insert(boulders, self)
	
	world:add(self, self.x, self.y, self.width-15, self.height-10)
end 

function boulder:update(dt)
	if not game.stage.transitioning then -- Boulders stand still when transitioning. Gives the illusion of the player falling with them
		self.y = self.y + self.speed*dt
	end

	self.rotation = self.rotation + 3*dt
	world:update(self, self.x, self.y)

	if self.y > game.height + 400 then 
		self:destroy()
	end 
end

function boulder:draw()
	love.graphics.draw(self.image, self.x+self.width/2 - 10, self.y+self.height/2, self.rotation*self.direction, self.scale, self.scale, self.width/(2*self.scale), self.height/(2*self.scale))

	if debug then
		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle("line", self.x, self.y, self.width-15, self.height-10)
		love.graphics.setColor(1, 1, 1) 
	end	
end 

function boulder:destroy(reason)
	boulders[self.id] = nil
	world:remove(self)
	if reason == "drill" then 
		for i=0, math.random(5,10) do 
			particle:new(self.particleImage, self.x+self.width/2, self.y + 10*3)
		end
	end 
end 

function updateBoulders(dt)
	boulderTimer = boulderTimer + dt
	if boulderTimer >= boulderInterval then
		if not game.stage.transitioning and bouldersCanSpawn then 
			boulder:new()
			boulderTimer = 0
			hasSpawned = true
			if player.score >= 250 and player.score <= 320 then 
				boulder:new()
			end
		else
			hasSpawned = false
		end
	end
	
	for i,v in pairs(boulders) do
		v:update(dt)
	end
end

function drawBoulders()
	for i,v in pairs(boulders) do 
		v:draw()
	end
end