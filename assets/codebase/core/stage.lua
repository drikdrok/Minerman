stage = class("stage")

function stage:initialize()

	self.backgrounds = {
		 love.graphics.newImage("assets/gfx/backgrounds/mountains.png"),
		 self:decideCave(),
		 love.graphics.newImage("assets/gfx/backgrounds/hell.png"),
	}

	self.grounds = {
		love.graphics.newImage("assets/gfx/grounds/mountainGround.png"),
		love.graphics.newImage("assets/gfx/grounds/caveGround.png"),
		love.graphics.newImage("assets/gfx/grounds/hellGround.png"),
	}

	self.layer = 1
	self.backgroundImage = self.backgrounds[1]
	self.sky = verticalGradient(game.width, game.height, {117/255, 172/255, 198/255}, {178/255, 220/255, 243/255})
	
	self.transitionTimer = 0
	self.transitioning = false
	self.transitionBackgroundImage = self.backgroundImage
	self.caveTime = math.random(95, 130)
	self.hellTime = math.random(350, 400)

	self.backgroundImageY = 0
	self.transitionBackgroundImageY = game.height

	self.groundY = player.y+player.height
	self.groundImage = self.grounds[1]
end

function stage:update(dt)
	if math.floor(player.score) == self.caveTime or math.floor(player.score) == self.hellTime then 
		if not self.transitioning then 
			self:startTransition()
		end
	end

	if self.transitioning then 
		self.transitionTimer = self.transitionTimer + dt
		self.transitionBackgroundImageY = self.transitionBackgroundImageY - game.height/1.5*dt
		self.backgroundImageY = self.backgroundImageY - game.height/1.5*dt

		self.groundY = self.groundY - game.height/1.5*dt

		if self.transitionBackgroundImageY <= 0 then  -- Transition is done
			self.transitioning = false
			self.backgroundImage = self.transitionBackgroundImage
			self.backgroundImageY = 0
			self.groundY = player.y+player.height
			self.transitionBackgroundImageY = game.height
		end 
	end 
end

function stage:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.sky, 0, 0)
	cloud:draw()
	love.graphics.draw(self.backgroundImage, 0, self.backgroundImageY, 0, 4, 4)
	love.graphics.draw(self.transitionBackgroundImage, 0, self.transitionBackgroundImageY, 0, 4, 4)
	

	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.groundImage, 0, self.groundY, 0, 4, 4)
end

function stage:startTransition()
	if game.sfx then 
		love.audio.play(groundShatterEffect)
	end

	for i=0, game.width/4 do 
		particle:new(boulderParticleImage, math.random(5, game.width), math.random(self.groundY, game.height), 4, false)
	end	
	

	self.layer = self.layer + 1

	if self.layer == 3 then 
		player.scoreSpeed = 6
	end

	self.transitionBackgroundImage = self.backgrounds[self.layer]
	self.transitioning = true
	self.transitionTimer = 0

	self.groundY = game.height + player.y+player.height
	self.groundImage = self.grounds[self.layer]
end 

function stage:reset()
	self.layer = 1
	self.backgroundImage = self.backgrounds[1]
	self.groundColor = {9, 178, 7}

	self.transitionTimer = 0
	self.transitioning = false
	self.transitionBackgroundImage = self.backgroundImage

	self.backgroundImageY = 0
	self.transitionBackgroundImageY = game.height

	self.groundY = player.y+player.height
	self.groundImage = self.grounds[1]

	self.caveTime = math.random(95, 130)
	self.hellTime = math.random(350, 400)

	self.backgrounds[2] = self:decideCave()
end

function stage:decideCave()
	local n = math.random(1,2)

	return love.graphics.newImage("assets/gfx/backgrounds/cave"..tostring(n)..".png")
end
