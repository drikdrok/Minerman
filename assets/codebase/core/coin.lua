coin = class("coin")
coins = {}

local coinTimer = 0

function coin:initialize()
	self.x = math.random(10, game.width-50)
	self.y = -30

	self.scale = 4

	self.width = 8 * self.scale
	self.height = 8 * self.scale

	self.id = #coins+1

	self.speed = math.random(150, 350)*(game.height/720)

	self.type = "coin"

	world:add(self, self.x, self.y, self.width, self.height)
	table.insert(coins, self)
end

function coin:update(dt)
	if not game.stage.transitioning then 
		self.y = self.y + self.speed*dt
	end

	if self.y > 3000 then 
		coins[self.id] = nil
	end

	world:update(self, self.x, self.y)
end

function coin:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(coinImage, self.x, self.y, 0, self.scale, self.scale)

	if debug then 
		love.graphics.setColor(0.8, 0.8, 0)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
		love.graphics.setColor(1, 1, 1)
	end
end

function updateCoins(dt)
	for i,v in pairs(coins) do
		v:update(dt)
	end

	coinTimer = coinTimer + dt
	if coinTimer >= 3 then 
		coinTimer = 0 
		if math.random(0, 3) == 1 then 
			coin:new()
		end
	end

end

function drawCoins()
	for i,v in pairs(coins) do
		v:draw()
	end
end