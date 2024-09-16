settingsPanel = class("settingsPanel")

function settingsPanel:initialize()
	self.image = love.graphics.newImage("assets/gfx/panels/settingsPanel.png")

	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.x = game.width / 2 - self.width / 2
	self.y = game.height / 2 - self.height / 2
end


function settingsPanel:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.image, self.x, self.y, 0)

	gooi.draw("settingsPanel")

	game:fontSize(14)

	if not game.sfx then 
		love.graphics.draw(crossImage, self.x + self.width - 76 - 25, self.y + self.height - 76*2 - 85, 0, 76/32, 76/32)
	end 	

	love.graphics.print("SFX", self.x + self.width - 76 + 14 - (game.font:getWidth("SFX")/2), self.y + self.height - 76*2)

	if not game.vibration then 
		--love.graphics.draw(crossImage, self.x + self.width - 76 - 25, self.y + self.height - 76 - 55, 0, 76/32, 76/32)
		love.graphics.draw(crossImage, self.x + self.width / 2 - 76/2, self.y + self.height - 76*2 - 85, 0, 76/32, 76/32)
	end 
	love.graphics.print("Vibrate", self.x + self.width / 2 - (game.font:getWidth("Vibrate")/2) + 2, self.y + self.height - 76*2)
	--love.graphics.print("Vibrate", self.x + self.width - 76 + 15 - (game.font:getWidth("Vibrate")/2) + 2, self.y + self.height - 76 + 30)
	
	if not game.music then 
		love.graphics.draw(crossImage, self.x + 25, self.y + self.height - 76 - 55, 0, 76/32, 76/32)
	end
	love.graphics.print("Music", self.x + 25 + 76/2 - (game.font:getWidth("Music")/2), self.y + self.height - 76 + 30)

	if not game.arrowHelp then 
		love.graphics.draw(crossImage, self.x + 25, self.y + self.height - 76*2 - 85, 0, 76/32, 76/32)
	end
	love.graphics.print("Guide", self.x + 25 + 76/2 - (game.font:getWidth("Guide")/2), self.y + self.height - 76*2)

	--[[
	if not game.notch then 
		love.graphics.draw(crossImage, self.x + self.width / 2 - 76/2, self.y + self.height - 76*2 - 85, 0, 76/32, 76/32)
	end

	if not game.stretch then 
		love.graphics.draw(crossImage, self.x + self.width - 76 - 25, self.y + self.height - 76*2 - 85, 0, 76/32, 76/32)
	end 
	if  os ~= "iOS" then 
		love.graphics.print("Stretch", self.x + self.width - 76 + 14 - (game.font:getWidth("Stretch")/2), self.y + self.height - 76*2)
	end
	]]
	
	--love.graphics.print("Notch", self.x + self.width / 2 - 76/2 - 17 + (game.font:getWidth("Notch")/2) + 2, self.y + self.height - 76*2)



	game:fontSize(16)
	love.graphics.print("Christian Schwenger    ".. version, math.floor(self.x + 5), self.y + self.height - game.font:getHeight("Christian Schwenger        ".. version) - 2)
end