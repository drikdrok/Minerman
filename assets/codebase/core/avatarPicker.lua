avatarPicker = class("avatarPicker")

function avatarPicker:initialize()

	self.width = game.width - (game.width/6)
	self.height = game.height - (game.height/6)

	self.x = game.width - self.width - ((game.width/6)/2)
	self.y = game.height - self.height - ((game.height/6)/2)


	self.image = love.graphics.newImage("assets/gfx/panels/avatarPanel.png")

	self.avatars = {}


	local avatarProperties = require("assets/codebase/data/avatars")
	local files = love.filesystem.getDirectoryItems("assets/gfx/sheets/avatars")

	for i=1, #files do
		local position = i

		local sheet = love.graphics.newImage("assets/gfx/sheets/avatars/avatar"..i..".png")

		local image = love.graphics.newQuad(0, 0, 16, 16, sheet:getWidth(), sheet:getHeight()) 

		local name = avatarProperties[i]["name"]

		local desc = avatarProperties[i]["desc"]

		local unlocked = false
		local unlocksAt = avatarProperties[i]["unlocksAt"]

		if player.highscore >= unlocksAt then 
			unlocked = true 
		end

		local avatar = {position = position, sheet = sheet, image = image, name = name, desc = desc, unlocked = unlocked, unlocksAt = unlocksAt}
		table.insert(self.avatars, avatar)
	end

	local data = game:getSave()

	if self.avatars[data["avatar"]].unlocksAt <= player.highscore then 
		self.highlightedAvatar = self.avatars[data["avatar"]] 
	else
		self.highlightedAvatar = self.avatars[1]
	end

	player:setAvatar(self.highlightedAvatar.sheet)
end

function avatarPicker:update(key)
	if key == "left" then
		if self.highlightedAvatar.position > 1 then 
			self.highlightedAvatar = self.avatars[self.highlightedAvatar.position-1] -- Highlight the avatar before the current one
		else
			self.highlightedAvatar = self.avatars[#self.avatars]
		end
	elseif key == "right" then 
		if self.highlightedAvatar.position < #self.avatars then 
			self.highlightedAvatar = self.avatars[self.highlightedAvatar.position+1] -- Highlight the avatar after the current one
		else
			self.highlightedAvatar = self.avatars[1]
		end
	elseif key == "escape" then 
		avatarPickerRight:setVisible(false)
		avatarPickerLeft:setVisible(false)
		exitAvatarButton:setVisible(false)
		avatarSelect:setVisible(false)
		game.state = "menu"
	end 
end

function avatarPicker:draw()
	--love.graphics.setColor(42, 96, 183)
	--love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 8, 8)
	love.graphics.setColor(255,255,255)

	love.graphics.draw(self.image, self.x, self.y, 0)

	game:fontSize(17)

	local x = self.x + self.width/2 - (16*10.1)/2
	local y = self.y + self.height/6
	love.graphics.draw(self.highlightedAvatar.sheet, self.highlightedAvatar.image, x, y, 0, 10.1, 10.1)
	-- 10.1 instead of 10 fixes a scaling bug

	if not self.highlightedAvatar.unlocked then

		love.graphics.setColor(50/255, 50/255, 50/255,  150/255)
		love.graphics.rectangle("fill", self.x + 10, y - 25, self.width - 20, 16*10+ 84)

		local x = self.x + self.width / 2 - game.font:getWidth("Unlocks at: "..self.highlightedAvatar.unlocksAt) / 2
		local y = self.y + self.height/6 + 16*5 + game.font:getHeight("Unlocks at: "..self.highlightedAvatar.unlocksAt) / 2	
		love.graphics.setColor(255,0,0,200)
		love.graphics.print("Unlocks at: "..self.highlightedAvatar.unlocksAt, x,y )
		love.graphics.setColor(255,255,255) 
	end
	

	love.graphics.setColor(0,0,0)
	local y = 380
	love.graphics.line(self.x + 11, y, 359, y)

	game:fontSize(17)
	local x = self.x + self.width / 2 - game.font:getWidth(self.highlightedAvatar.desc) / 2
	love.graphics.print(self.highlightedAvatar.desc, x, 420)

	love.graphics.setColor(255,255,255)
	-- The score font's size fits nicely
	game:fontSize(21)
	local x = self.x + self.width/2 - game.font:getWidth(self.highlightedAvatar.name) / 2 + 5 
	love.graphics.print(self.highlightedAvatar.name, x, self.height/6 + (16*10) + 75)

	local x = self.x + self.width/2 - game.font:getWidth(self.highlightedAvatar.position.."/"..#self.avatars) / 2 
	love.graphics.print(self.highlightedAvatar.position.."/"..#self.avatars, x, self.y+20)


	gooi.setStyle(textButtonStyle)
	gooi.draw("avatarPicker")
end

function avatarPicker:select()
	if self.highlightedAvatar.unlocked then 
		player:setAvatar(self.highlightedAvatar.sheet)
		game:writeSave()

		self.visible = false
        avatarPickerLeft:setVisible(false)
        avatarPickerRight:setVisible(false)
        exitAvatarButton:setVisible(false)

        game.state = "menu"
	end
end

function avatarPicker:checkHighscore()
	for i,v in pairs(self.avatars) do
		if player.highscore >= v.unlocksAt then 
			v.unlocked = true
		else
			v.unlocked = false 
		end
	end
end