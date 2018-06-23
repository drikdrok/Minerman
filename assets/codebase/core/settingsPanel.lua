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

	if not game.sfx then 
		love.graphics.draw(crossImage, settingsPanel.x + settingsPanel.width / 2 - 76/2, settingsPanel.y + settingsPanel.height - 76 - 30, 0, 76/32, 76/32)
	end 
	if not game.vibration then 
		love.graphics.draw(crossImage, settingsPanel.x + settingsPanel.width - 76 - 25, settingsPanel.y + settingsPanel.height - 76 - 30, 0, 76/32, 76/32)
	end 
	
	if not game.music then 
		love.graphics.draw(crossImage, settingsPanel.x + 25, settingsPanel.y + settingsPanel.height - 76 - 30, 0, 76/32, 76/32)
	end

	if not game.arrowHelp then 
		love.graphics.draw(crossImage, settingsPanel.x + 25, settingsPanel.y + settingsPanel.height - 76*2 - 40, 0, 76/32, 76/32)
	end

	love.graphics.setFont(game.fonts["text"])
	love.graphics.print("Christian Schwenger    ".. version, math.floor(self.x + 5), self.y + self.height - game.fonts["text"]:getHeight("Christian Schwenger    ".. version) - 2)
end