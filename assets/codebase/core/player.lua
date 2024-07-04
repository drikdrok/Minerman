player = class("player")

function player:initialize()

	self.imageScaleX = 4
	self.imageScaleY = 4*game.scale

	local data = game:getSave()

	self.sheet = love.graphics.newImage("assets/gfx/sheets/avatars/avatar1.png")
	
	self.x = math.floor(game.width / 2)
	self.y = math.floor(game.height / 5 * 3.5)
	self.width = math.floor(16*self.imageScaleY) - 24--16 is the frame size. Change if the frame size gets bigger!
	self.height = math.floor(16*self.imageScaleY)-- - 3*game.scale

	self.speed = 260*game.scale
	self.speedboost = 0
	self.score = 0
	self.scoreSpeed = 3
	self.highscore = data["highscore"]

	self.coins = data["coins"]

	self.grid = anim8.newGrid(16,16,self.sheet:getWidth(), self.sheet:getHeight()) -- Animation grid
	
	self:setAnimationSpeed(0.2)
	self.animation = self.animations[1]

	self.emptyPowerup = {update = function() end, draw = function() end, kind = "empty"} -- This is an ugly way, not sure if there is a more efficient though
	self.powerup = self.emptyPowerup

	self.type = "player"

	self.direction = 1

	self.drillBuff = data["drillBuff"]
	self.speedBuff = data["speedBuff"] 


	world:add(self, self.x, self.y, self.width, self.height)

end

function player:update(dt)
	if not game.stage.transitioning then 
		-- Remeber whenever you edit this change it for touch aswell!!!!
		if love.keyboard.isDown("a") or love.keyboard.isDown("left") then 
			self.x = self.x - self.speed*dt
			self.animation = self.animations[2] -- Left animation
			self.direction = 2
		end
		if love.keyboard.isDown("d") or love.keyboard.isDown("right") then 
			self.x = self.x + self.speed*dt
			self.animation = self.animations[1] -- Right animation
			self.direction = 1
		end

		if platform == "mobile" then 
			local touches = love.touch.getTouches()
			local hasMovedRight = false
			local hasMovedLeft = false

			for i, id in pairs(touches) do
				local x, y = love.touch.getPosition(id)

				if y > pauseButton.h + 10 then 
					if x < math.floor(love.graphics.getWidth()/2) and not hasMovedLeft then --Left
						self.x = self.x - self.speed*dt
						self.animation = self.animations[2] -- Left animation
						self.direction = 2
						hasMovedLeft = true
					end
					if x > math.floor(love.graphics.getWidth()/2) and not hasMovedRight then --Right
						self.x = self.x + self.speed*dt
						self.animation = self.animations[1] -- Right animation
						self.direction = 1
						hasMovedRight = true
					end
				end
			end
		end
	end




	if self.x < 0 then -- Boundry
		self.x = 0
	elseif self.x + self.width > game.width then 
		self.x = game.width - self.width
	end

	self.powerup:update(dt)

	world:update(self, self.x, self.y)

	local actualX, actualY, cols, len = world:check(self, self.x, self.y)

	if #cols > 0 then 
		for i,v in pairs(cols) do
			if v.other.type == "boulder" then 
				if self.powerup.kind == 1 and v.normal.y == 1 then -- The drill
					if game.sfx then 
						love.audio.play(drillEffect)
					end
					self.powerup.streak = self.powerup.streak + 1
					self.score = self.score + self.powerup.streak
					drillPoint:new(v.other.x, v.other.y)
					v.other:destroy("drill")
				else
					self:die()
				end
			elseif v.other.type == "coin" then 
				self.coins = self.coins + 1
				world:remove(v.other)
				coins[v.other.id] = nil
			end
		end
	end 

	self.animation:update(dt) --Update animation


	if self.score <= 320 then  --Player doesn't keep getting faster after 320
		self.speed = (240+(self.score*0.40*boulderSpeed))
	end
	self.speed = self.speed + self.speedboost*game.scale
end

function player:draw()
	love.graphics.setColor(255,255,255)

	self.animation:draw(self.sheet, self.x-(12*game.width/400), self.y, 0, self.imageScaleX, self.imageScaleY) -- -12 is just to align the drawing with the collision box.

	self.powerup:draw()

	--love.graphics.rectangle("fill", self.x, self.y, 3, 3) -- Actual point of player

	if debug then 
		local x,y,w,h = world:getRect(self)
		love.graphics.rectangle("line", x,y,w,h)
	end 
end

function player:reset()
	
	self.score = 0
	self.x = math.floor(game.width / 2)
	self.y = math.floor(game.height / 5 * 3.5)
	self.powerup = self.emptyPowerup
	self.speedboost = 0
	self:setAnimationSpeed(0.2)
 	world:add(self, self.x, self.y, self.width, self.height)
end

function player:die()
	if game.sfx then 
		love.audio.play(hitEffect)
	end
	if game.vibration then 
		love.system.vibrate(0.4)
	end
	
	game.state = "dead"
    pauseButton:setVisible(false)
    deathscreen:setVisible(true)

	if math.floor(self.score) > self.highscore then 
		self.highscore = math.floor(self.score)
		game:writeSave()	
	end

	avatarPicker:checkHighscore()
end

function player:setAnimationSpeed(speed)
	self.animationSpeed = speed  or 0.2
	self.animations = {
		anim8.newAnimation(self.grid("1-4",1), self.animationSpeed),
		anim8.newAnimation(self.grid("1-4",2), self.animationSpeed)
	}
	self.animation = self.animations[self.direction]
end	

function player:setAvatar(sheet)
	self.sheet = sheet
end