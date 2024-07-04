trail = class("trail")

function trail:initialize()
	self.positions = {}
	self.timer = 0

	self.width = 15
	self.height = 6
end

function trail:update(dt)
	if avatarPicker.highlightedAvatar.position == 16 then
		self.timer = self.timer + dt
		if self.timer > 1/200 then 
			table.insert(self.positions, {x = player.x + 13, y = player.y + 16, age = 0, id = #self.positions+1})
		end 

		for i,v in pairs(self.positions) do
			v.age = v.age + dt

			if v.age >= 0.2 then 
				self.positions[v.id] = nil
			end
		end
	end
end


function trail:draw()
	for i, v in pairs(self.positions) do
		love.graphics.setColor(1, 0, 0) -- Rainbow trail
		love.graphics.rectangle("fill", v.x, v.y, self.width, self.height)
		love.graphics.setColor(1, 160/255, 14/255)
		love.graphics.rectangle("fill", v.x, v.y+self.height, self.width, self.height)
		love.graphics.setColor(0.96, 1, 6/255)
		love.graphics.rectangle("fill", v.x, v.y+self.height*2, self.width, self.height)
		love.graphics.setColor(52/255, 1, 0)
		love.graphics.rectangle("fill", v.x, v.y+self.height*3, self.width, self.height)
		love.graphics.setColor(18/255, 170/255, 253/255)
		love.graphics.rectangle("fill", v.x, v.y+self.height*4, self.width, self.height)
		love.graphics.setColor(110/255, 72/255, 253/255)
		love.graphics.rectangle("fill", v.x, v.y+self.height*5, self.width, self.height)
		love.graphics.setColor(1,1,1)
	end
end

function trail:reset()
	self.positions = {}
end