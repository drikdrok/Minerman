game = class("game")

-- WAAY to much stuff.

local buttonPressed = false

function game:initialize()

	debug = false
	love.filesystem.setIdentity("secret")


	self.width = 405
	self.height = 720

 	self.scale = self.width/405
	self.scaleY = self.height/720

	self.actualHeight = self.height -- I have no idea what to call this other than actualHeight?

	os = love.system.getOS()
	platform = "pc"
	self.menuMessage = "Press space to "
	if os == "Android" or os == "iOS"then
		platform = "mobile"
		--self.width, self.height = love.window.getDesktopDimensions()
		love.window.setFullscreen(true)
		self.menuMessage = "Tap to "
	end

	self.state = "menu"

	self.fonts = {}
	self.font = love.graphics.newFont("assets/gfx/fonts/pixelmix.ttf", 12)
	love.graphics.setFont(self.font)


	self.titleY = -100
	self.titleMayScroll = true



	self.sfx = false
	self.music = false
	self.vibration = false 
	self.arrowHelp = false
	self.stretch = false
	self.notch = false

	self.textTimer = 5
	local data = self:getSave()

	if data["sfx"] then 
		self.sfx = true --Self.sfx = data["sfx"] won't work because data["sfx"] might not exist!!
	end
	if data["vibration"] then 
		self.vibration = true
	end
	if data["music"] then 
		self.music = true
	end 

	if data["arrows"] then
		self.arrowHelp = true
	end

	if data["stretch"] then 
		self.stretch = data["stretch"]
	end

	if data["notch"] then 
		self.notch = data["notch"]
	end

	if self.stretch then 
		self.actualHeight = self.height
	else
		self.actualHeight = love.graphics.getHeight()
	end

	if self.notch then 
		self.notchOffset = 25
	else
		self.notchOffset = 0
	end 



	love.graphics.setLineWidth(3)

	world = bump.newWorld(50)


end

function game:update(dt)
	gooi.update(dt)
	updateGUI()
	cloud:update(dt)
	if self.state == "playing" then 
		player:update(dt)
		player.score = player.score+dt*player.scoreSpeed

		updateBoulders(dt)
		updateParticles(dt)
		updatePowerups(dt)
		updateDrillPoints(dt)

		self.stage:update(dt)

		-- This could be done better, but it works.
		if player.score > 50 and player.score < 80 then 
			boulderSpeed = 1.7
			boulderInterval = 1
		elseif player.score > 80 and player.score < 125 then 
			boulderSpeed = 2.3
			boulderInterval = 0.9
		elseif player.score > 125 and player.score < 200 then 
			boulderSpeed = 2.7
			boulderInterval = 0.8 
		elseif player.score > 200 and player.score < 230 then
			boulderInterval = 0.75 
			boulderSpeed = 2.9
		elseif player.score > 230 and player.score < 260 then
			boulderInterval = 0.65
		elseif player.score > 260 and player.score <= 320 then
			boulderInterval = 0.5
		elseif player.score > 320 then 
			boulderInterval = 0.4
		end

		self.textTimer = self.textTimer - dt


	elseif self.state == "menu" then 
		if self.titleY < self.height/9 + self.notchOffset then 
			self.titleY = self.titleY + 170*dt
		elseif self.titleY > self.height/9 then 
			self.titleY = self.height/9 + self.notchOffset
		end
	elseif self.state == "settingsPanel" then
		if self.titleY < self.height/9  then 
			self.titleY = self.titleY + 170*dt
		elseif self.titleY > self.height/9 then 
			self.titleY = self.titleY - 170*dt
		end

		if self.titleY < self.height / 9 + 2 and self.titleY > self.height / 9 - 2 then
			self.titleY = self.height / 9
		end

	end
end

function game:draw()
	self.stage:draw()	
	

	-- Drawing everything in this huge if statement, is horrible. The game grew bigger than I first expected.	
	if self.state == "playing" then 
		player:draw()
		drawBoulders()
		drawParticles()
		drawPowerups()
		drawDrillPoints()

		--HUD / GUI
		love.graphics.setColor(255,255,255)
		self:fontSize(22)
		love.graphics.print(math.floor(player.score), findMiddle(math.floor(player.score), "score"), self.height/7)
		if player.powerup.kind ~= "empty" then --Powerup timer
			local p = player.powerup

			local imgX = self.width-p.image:getWidth()*p.scale-10
			
			love.graphics.draw(p.image, imgX, 10 + self.notchOffset, 0, p.scale, p.scale)
			
			self:fontSize(17)
			
			local x = math.ceil(imgX + p.image:getWidth()*p.scale/2 - (self.font:getWidth(p.lifetime - math.floor(p.age)) / 2))
			love.graphics.print(p.lifetime - math.floor(p.age), x, p.image:getHeight()*p.scale + 15 + self.notchOffset)
		end

		--Arrow Overlay

		if self.arrowHelp then 
			love.graphics.setColor(1, 1, 1, 0.75)
			love.graphics.draw(arrowLeftImage, 10, self.actualHeight-130, 0, 7, 7)
			love.graphics.draw(arrowRightImage, game.width-10-(arrowRightImage:getWidth()*7), self.actualHeight-130, 0, 7, 7)
			self:fontSize(17)
			love.graphics.setColor(1,1,1, self.textTimer)
			love.graphics.print("Tap & hold to move", findMiddle("Tap & hold to move", "text"), self.actualHeight-self.actualHeight/20)
		end

		love.graphics.setColor(1, 1, 1, 1)
		gooi.setStyle(imageButtonStyle)
		gooi.draw("playing")

	elseif self.state == "paused" then 

		player:draw()
		drawBoulders()
		drawParticles()
		drawPowerups()
		

		if player.powerup.kind ~= "empty" then -- Powerup timer
			local p = player.powerup

			love.graphics.draw(p.image, self.width-p.image:getWidth()*p.scale-5*p.scale, 10, 0, p.scale, p.scale)
			
			self:fontSize(17)
			
			local x = (self.width-p.image:getWidth()*p.scale-5*p.scale) + ((p.image:getWidth()*p.scale-5*p.scale)/2) + (self.font:getWidth(p.lifetime - math.floor(p.age))/6)  -- There must be a shorter way to find an x coord
			love.graphics.print(p.lifetime - math.floor(p.age), x, p.image:getHeight()*p.scale + 15)
		end

		love.graphics.draw(darkOverlay, 0, 0, 0, 10, 10) --Scaling is very bad I know I just wanna release the game gimme a break

		self:fontSize(23)
		love.graphics.print("Paused", findMiddle("paused", "score"), self.height/7)

		self:fontSize(17)
		love.graphics.print(self.menuMessage.."resume!", findMiddle(self.menuMessage.."resume!","text"), self.actualHeight-self.actualHeight/20)

	
	elseif self.state == "menu" then 
		love.graphics.setColor(255,255,255)
		love.graphics.draw(titleImage, game.width/2 - (titleImage:getWidth()/2*(2.5)), self.titleY, 0, 2.5, 2.5)

		self:fontSize(17)
		love.graphics.print(self.menuMessage.."start!", findMiddle(self.menuMessage.."start!","text"), self.actualHeight-self.actualHeight/20)
		love.graphics.print("Highscore: "..player.highscore, 10, 10 + self.notchOffset)

		--gooi.setStyle(textButtonStyle) --Might be needed!
		gooi.draw("menu")

	elseif self.state == "avatarPicker" then 

		love.graphics.setColor(255,255,255)
		self:fontSize(17)
		love.graphics.print("Highscore: "..player.highscore, 10, 10 + self.notchOffset)
		love.graphics.print("Choose an avatar!", findMiddle("Choose an avatar!","text"), self.actualHeight-self.actualHeight/20)

		avatarPicker:draw()
	elseif self.state == "settingsPanel" then 
		love.graphics.setColor(255,255,255)
		love.graphics.draw(titleImage, game.width/2 - (titleImage:getWidth()/2*2.5), self.titleY, 0, 2.5, 2.5)

		self:fontSize(17)
		love.graphics.print("Settings", findMiddle("Settings","text"), self.actualHeight-self.actualHeight/20)
		love.graphics.print("Highscore: "..player.highscore, 10, 10 + self.notchOffset)
		

		settingsPanel:draw()
	elseif self.state == "dead" then 
		deathscreen:draw()
	end 
end

function game:keypressed(key)
	if self.state == "playing" then 
		if key == "escape" and platform == "pc" then 
			self.state = "menu"
		end
	elseif self.state == "menu" then 
		if key == "space" then 
			self.state = "playing"
			self:reset()
		elseif key == "escape" then
			love.event.quit()
		end

	elseif self.state == "paused" then 
		if key == "space" then 
			self.state = "playing"
		end
	elseif self.state == "avatarPicker" then 
		avatarPicker:update(key)
	elseif self.state == "dead" then 
		if key == "escape" and platform == "pc" then 
			self.state = "menu"
			deathscreen:setVisible(false)
		elseif key == "r" then 
			self.state = "playing" 
			self:reset()
			deathscreen:setVisible(false) 
		end
	elseif self.state == "settingsPanel" then 
		if key == "escape" then 
			self.state = "menu"
		end
	end
	updateGUI()
end

function game:touchpressed()
	if self.state == "playing" then 

	elseif self.state == "menu" then 
		gooi.released()
		if self.state == "menu" then  -- No buttons were pressed
			self.state = "playing"
			self:reset()
			updateGUI()
		end 
	elseif self.state == "paused" then 
		self.state = "playing"
	end
end

function game:reset()
	world = bump.newWorld(50)

	boulderSpeed = 1.5
	self.titleY = -100
	self.textTimer = 5
	self.stage:reset()
	
	player:reset()
	boulders = {}
	boulderInterval = 1.5
	particles = {}
	powerups = {}
	drillPoints = {}
	

	powerup:new()

    pauseButton:setVisible(true)
end 	

function game:writeSave()
	if love.filesystem.getInfo("save.lua") then 
		love.filesystem.remove("save.lua")
	end
	love.filesystem.newFile("save.lua")

	love.filesystem.write("save.lua", "return {highscore = "..player.highscore.. ", sfx = "..tostring(self.sfx)..", music = "..tostring(self.music)..",  vibration = "..tostring(self.vibration)..", avatar = "..avatarPicker.highlightedAvatar.position..", arrows = "..tostring(self.arrowHelp)..", stretch = "..tostring(self.stretch)..", notch = "..tostring(self.notch).."}")
end

function game:getSave()
	if love.filesystem.getInfo("save.lua") then 

		local data = love.filesystem.load("save.lua")
		data = data()
		if data["highscore"] ~= nil and data["sfx"] ~= nil and data["vibration"] ~= nil and data["avatar"] ~= nil and data["arrows"] ~= nil and data["stretch"] ~= nil and data["notch"] ~= nil then 
			return data
		else
			return {highscore = 0, sfx = true, music = true, vibration = true, avatar = 1, arrows = true, stretch = true, notch = false}
		end 
	else
		love.filesystem.newFile("save.lua")
		return {highscore = 0, sfx = true, music = true, vibration = true, avatar = 1, arrows = true, stretch = true, notch = false}
	end	
end

function game:fontSize(size)
	if not self.fonts[size] then
		self.fonts[size] = love.graphics.newFont("assets/gfx/fonts/pixelmix.ttf", size)
	end
	self.font = self.fonts[size]
	love.graphics.setFont(self.font)

	return self.font
end


function findMiddle(text, font) -- returns x coordinate for text to be in middle
	return math.floor(game.width/2-game.font:getWidth(text)/2)
end
