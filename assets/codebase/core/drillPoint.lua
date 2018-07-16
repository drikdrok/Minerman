drillPoint = class("drillPoint")

drillPoints = {}

function drillPoint:initialize(x, y)

	self.x = x + 20
	self.y = y + 10
	self.text = "+"..player.powerup.streak
	self.alpha = 2.5

	self.id = #drillPoints
	table.insert(drillPoints, self)

end

function drillPoint:update(dt)
	self.y = self.y - 50*dt

	self.alpha = self.alpha - dt

	if self.alpha < 0 then
		drillPoints[self.id] = nil
	end
end

function drillPoint:draw()
	love.graphics.setFont(game.fonts["text"])
	love.graphics.setColor(1,1,1, self.alpha)
	love.graphics.print(self.text, self.x, self.y)
end

function updateDrillPoints(dt)
	for i,v in pairs(drillPoints) do
		v:update(dt)		
	end	
end

function drawDrillPoints()
	for i,v in pairs(drillPoints) do
		v:draw()
	end
end