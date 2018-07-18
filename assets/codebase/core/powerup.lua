powerup = class("powerup")

powerups = {}

local hasSpawned = false
tryTimer = 0

function powerup:initialize(kind, x, y, lifetime)
	self.kind = kind or math.random(1,2)
	self.x = x or math.random(10, game.width-50)
	self.y = y or -30

	self.xvel = 0
	self.yvel = 0

	self.rotation = 0
	
	if math.random(1, 2) == 1 then 
		self.direction = 1
	else
		self.direction = -1
	end


	if self.kind == 1 then 
		self.image = drillingHatImage
		self.scale = 4

		self.sheet = love.graphics.newImage("assets/gfx/sheets/drillsheet.png")
		self.grid = anim8.newGrid(8, 8, self.sheet:getWidth(), self.sheet:getHeight())
		self.animation = anim8.newAnimation(self.grid("1-3", 1), 0.1)
	elseif self.kind == 2 then 
		self.image = speedboostImage
		self.scale = 1
	elseif self.kind == 3 then 
		self.image = love.graphics.newImage("assets/gfx/images/shield.png")
		self.scale = 4
	end
	
	self.width = self.image:getWidth()*self.scale
	self.height = self.image:getHeight()*self.scale
	
	self.speed = math.random(150, 350)*(game.height/720)


	self.age = 0
	if self.kind == 2 then 
		self.lifetime = 10
	else
		self.lifetime = 8
	end 

	self.type = "powerup" 

	self.state = "falling"

	self.streak = 0

	self.id = #powerups+1
	table.insert(powerups, self)

	world:add(self, self.x, self.y, self.width, self.height)
end

function powerup:update(dt)
	if self.state == "falling" then 
		if not game.stage.transitioning then 
			self.y = self.y + self.speed*dt
			world:update(self, self.x, self.y)

			local actualX, actualY, cols, len = world:check(self, self.x, self.y)

			if #cols > 0 then 
				for i,v in pairs(cols) do
					if v.other.type == "player" and v.other.powerup.kind == "empty" then 
						self:pickUp()
					end
				end
			end


			if self.y > game.height + 200 then 
				powerups[self.id] = nil
				world:remove(self)
			end
		end
	elseif self.state == "activated" then 
		if self.kind == 1 then -- If drill 
			self:decidePosition()
			self.animation:update(dt)
		elseif self.kind == 3 then 
			self:decidePosition()
		end
		
		if not game.stage.transitioning then 
			self.age = self.age + dt
			if math.floor(self.age) >= self.lifetime then  -- Powerup expires
				player.powerup = player.emptyPowerup
				if self.kind == 1 then --Drill
					self.state = "used"
					self.xvel = math.random(-50, 50)
					self.yvel = -150
					powerups[self.id] = self
				elseif self.kind == 2 then --Speedboost
					powerups[self.id] = nil

					player.speedboost = 0 
					player:setAnimationSpeed(0.2)
				end
			end	
		end
	elseif self.state == "used" then 
		if self.kind == 1 then --Drill
			self.y = self.y + self.yvel*dt
			self.x = self.x + self.xvel*dt

			self.yvel = self.yvel + 1000*dt
			self.xvel = self.xvel - 100*dt
			self.rotation = self.rotation + 1*dt

			if self.y > game.height+200 then 
				powerups[self.id] = nil --Destroy powerup
				world:remove(self)
			end 
		end
	end	
end

function powerup:draw()
	love.graphics.setColor(255,255,255)
	if self.kind == 1 then 
		self.animation:draw(self.sheet, self.x, self.y, self.rotation*self.direction, self.scale, self.scale)
	else
		love.graphics.draw(self.image, self.x, self.y, self.rotation*self.direction, self.scale, self.scale)
	end	
	if debug and self.state == "falling" then 
		love.graphics.setColor(0,255,0)
		local x,y,w,h = world:getRect(self)
		love.graphics.rectangle("line", x,y,w,h)
		love.graphics.setColor(255,255,255)
	end
end


function powerup:pickUp()
	self.state = "activated"
	if self.kind == 1 then -- Drill
		self.scale = 3
	elseif self.kind == 2 then -- Speedboost
		if game.sfx then 
			love.audio.play(speedboostEffect)
		end
		player.speedboost =  250
		player:setAnimationSpeed(0.08)
		self.x = 10000
	end 	
	drillPoints = {}
	player.powerup = self
	powerups[self.id] = nil
end

function powerup:decidePosition() -- The hat needs to follow the player
	-- This is quite innefecient, a better way to do it would be to just have the hat on the sprite
	-- Alternatively, making a proper "mover" object would be smarter.
	if self.kind == 1 then  
		local frame = player.animation.position
		if player.direction == 1 then  --Right 
			if frame == 1 then 
				self.x = player.x + 2*player.imageScaleX
				self.y = player.y - 4*player.imageScaleY
			elseif frame == 2 then 
				self.x = player.x + 1*player.imageScaleX
				self.y = player.y - 5*player.imageScaleY
			elseif frame == 3 then 
				self.x = player.x + 1*player.imageScaleX
				self.y = player.y - 4*player.imageScaleY
			elseif frame == 4 then 
				self.x = player.x + 2*player.imageScaleX
				self.y = player.y - 5*player.imageScaleY
			end
		elseif player.direction == 2 then -- Left
			if frame == 1 then 
				self.x = player.x + 2*player.imageScaleX
				self.y = player.y - 4*player.imageScaleY
			elseif frame == 2 then 
				self.x = player.x + 3*player.imageScaleX
				self.y = player.y - 5*player.imageScaleY
			elseif frame == 3 then 
				self.x = player.x + 3*player.imageScaleX
				self.y = player.y - 4*player.imageScaleY
			elseif frame == 4 then 
				self.x = player.x + 2*player.imageScaleX
				self.y = player.y - 5*player.imageScaleY
			end
		end
	end
end

function updatePowerups(dt)
	for i,v in pairs(powerups) do
		v:update(dt)
	end

	tryTimer = tryTimer - dt 

	if math.floor(player.score % 9) == 0 and tryTimer <= 0 and #powerups == 0 then
		tryTimer = 2
		local n = math.random(0, 2)
		if n == 1 and player.powerup.kind == "empty"then 
			if not hasSpawned then 
				powerup:new()
			--	math.randomseed(os.time()+#powerups)
				hasSpawned = true
			end
		end	 
	else 
		hasSpawned = false
	end 


end

function drawPowerups()
	for i,v in pairs(powerups) do
		v:draw()
	end
end