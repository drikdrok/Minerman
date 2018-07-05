deathscreen = class("deathscreen") 

function deathscreen:initialize()
	gooi.setStyle(imageButtonStyle)
	self.restartButton =  gooi.newButton({text = "", x = game.width / 2 - 256/1.5/2, y = game.height / 6 * 2.5, w = 256/1.5, h = 64/1.5, icon = "assets/gfx/icons/restartButton.png"} -- Avatar button
        ):onRelease(function()
        	game.state = "playing"
        	game:reset()

        	self:setVisible(false)
        end):setGroup("deathscreen")

    self.menuButton =  gooi.newButton({text = "", x = game.width / 2 - 256/1.5/2, y = game.height / 6 * 3.3, w = 256/1.5, h = 64/1.5, icon = "assets/gfx/icons/menuButton.png"} -- Avatar button
        ):onRelease(function()
        	game.state = "menu"

        	self:setVisible(false)
        end):setGroup("deathscreen")
end

function deathscreen:draw()
	love.graphics.draw(redOverlay, 0, 0, 0, 5, 5) --The scaling is not optimal, whatever

	love.graphics.setFont(game.fonts["hud"])
	love.graphics.print("YOU DIED!", findMiddle("YOU DIED!", "hud"), game.height/6)
	love.graphics.setFont(game.fonts["deathScore"])
	love.graphics.print("Score: "..math.floor(player.score), findMiddle("Score: "..math.floor(player.score), "deathScore"), game.height/4.5)

	love.graphics.setFont(game.fonts["button"])
	gooi.draw("deathscreen")
end

function deathscreen:setVisible(visible)
	if visible then 
		self.restartButton:setVisible(true)
		self.menuButton:setVisible(true)
	elseif not visible then 
		self.restartButton:setVisible(false)
		self.menuButton:setVisible(false)
	end
end