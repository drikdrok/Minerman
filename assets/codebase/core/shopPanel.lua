shopPanel = class("shopPanel")

function shopPanel:initialize()
	self.image = love.graphics.newImage("assets/gfx/panels/settingsPanel.png")

	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.x = game.width / 2 - self.width / 2
	self.y = game.height / 2 - self.height / 2
end

function shopPanel:draw()
	if love.keyboard.isDown("k") then 
		player.coins = player.coins + 1
	end

	love.graphics.draw(self.image, self.x, self.y)

	love.graphics.draw(coinImage, self.x + 15, self.y + 30, 0, 4, 4)
	game:fontSize(24)
	love.graphics.print(player.coins, self.x + 60, self.y + 33)

	--Drill Upgrade
	love.graphics.draw(drillingHatImage, self.x + 15, self.y + 100, 0, 4, 4)
	for i = 0, 4 do 
		if i < player.drillBuff then 
			love.graphics.setColor(0, 1, 0)
		else
			love.graphics.setColor(56 / 255, 52 / 255, 52 / 255)
		end
		love.graphics.rectangle("fill", self.x + 55 + 27*i , self.y + 100, 24, 32, 5, 5)

		love.graphics.setColor(1,1,1)
	end

	if player.drillBuff < 5 then 
		love.graphics.print(2^(player.drillBuff+2), self.x + 220, self.y + 103)
	end

	-- Speed Upgrade
	love.graphics.draw(speedboostImage, self.x + 15, self.y + 150, 0, 1, 1)
	for i = 0, 4 do 
		if i < player.speedBuff then 
			love.graphics.setColor(0, 1, 0)
		else
			love.graphics.setColor(56 / 255, 52 / 255, 52 / 255)
		end
		love.graphics.rectangle("fill", self.x + 55 + 27*i , self.y + 150, 24, 32, 5, 5)

		love.graphics.setColor(1,1,1)
	end

	if player.speedBuff < 5 then 
		love.graphics.print(2^(player.speedBuff+2), self.x + 220, self.y + 153)
	end

	game:fontSize(17)

	gooi.draw("shopPanel")
end