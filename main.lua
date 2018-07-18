-- NOTE:
-- I never intended for this game to be released, neither be put on github,
-- So a lot of the code isn't very optimized or elegant

require("assets/codebase/core/require")


version = "v 1.1.0"

 function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	math.randomseed(os.time())

	gameCanvasScaleX = love.graphics.getWidth() / 405
	gameCanvasScaleY = love.graphics.getHeight() / 720


	loadImages()
	loadSounds()
	game = game:new()
	player = player:new()	
	avatarPicker = avatarPicker:new()
	settingsPanel = settingsPanel:new()
	createGUI() -- Gooi  
	powerup:new()
	game.stage = stage:new() -- We need the game to be initialized before the stage is
	cloud = cloud:new()
	deathscreen = deathscreen:new()


	gameCanvas = love.graphics.newCanvas(405, 720)
    gooi.setCanvas(gameCanvas)

    game.actualHeight = game.height

    if not game.stretch then 
        if math.floor(love.graphics.getHeight() / 720) >= 1 then 
            gameCanvas = love.graphics.newCanvas()
            gooi.setCanvas(gameCanvas)

            game.actualHeight = love.graphics.getHeight()
        end
    end


	if game.music then 
		soundtrack:play()
	end
end

function love.update(dt) 
	game:update(dt)
end

function love.draw()
	love.graphics.setCanvas{gameCanvas, stencil=true}
		love.graphics.clear()
		game:draw()	
	love.graphics.setCanvas()

	if game.stretch then 
		love.graphics.draw(gameCanvas, 0, 0, 0, gameCanvasScaleX, gameCanvasScaleY) -- Scale Everything
	else
		if math.floor(love.graphics.getHeight() / 720) >= 1 then 
			love.graphics.draw(gameCanvas, 0, 0, 0, gameCanvasScaleX, math.floor(love.graphics.getHeight() / 720)) -- Scale in 9:16
		else
			love.graphics.draw(gameCanvas, 0, 0, 0, gameCanvasScaleX, gameCanvasScaleY)
		end
	end

	if debug then 
		love.graphics.print(love.timer.getFPS())
	end


	--error(love.filesystem.getSaveDirectory())
end

function love.keypressed(key)
	game:keypressed(key)
	if key == "p" then 
		debug = not debug
	elseif key == "f1" then 
		debug = not debug
	end
end

function love.touchpressed()    
	gooi.pressed()
	game:touchpressed()
end

function love.touchreleased()
	gooi.released()
end

function love.mousepressed(x, y, button) 
	gooi.pressed() 
end 

function love.mousereleased(x, y, button) 
	gooi.released() 
end

function love.focus(f) 
	if not f then 
		if game.state == "playing" then 
			game.state = "paused"
		end
	end
end

function love.resize(w, h)
	gameCanvasScaleX = w / 405
	gameCanvasScaleY = h / 720

	gooi.setCanvas(gameCanvas)
end

function love.exit()
	game:writeSave()
end
-- Misc functions

function loadImages()
	--Load most images that will be used in the futre.
	--Not very efficent, but frankly I have no reason to care.

	titleImage = love.graphics.newImage("assets/gfx/icons/title.png")

	boulderImage = love.graphics.newImage("assets/gfx/images/boulder.png")
	boulderParticleImage = love.graphics.newImage("assets/gfx/particles/boulderParticle.png")

	hellboulderImage = love.graphics.newImage("assets/gfx/images/hellboulder.png")
	hellSkullImage = love.graphics.newImage("assets/gfx/images/hellSkull.png")
	skullParticleImage = love.graphics.newImage("assets/gfx/particles/skullParticle.png")

	drillingHatImage = love.graphics.newImage("assets/gfx/images/drill.png")
	speedboostImage = love.graphics.newImage("assets/gfx/images/speedboost.png")

	arrowLeftImage = love.graphics.newImage("assets/gfx/icons/arrowLeft2.png")
	arrowRightImage = love.graphics.newImage("assets/gfx/icons/arrowRight2.png")

	crossImage = love.graphics.newImage("assets/gfx/icons/cross.png")

	local w, h = love.graphics.getWidth(), love.graphics.getHeight() -- Dark overlay
	darkOverlay = love.graphics.newCanvas(w, h)
	love.graphics.setCanvas(darkOverlay)
		love.graphics.setColor(81/255, 87/255, 96/255, 150/255)
		love.graphics.rectangle("fill", 0, 0, w, h)
	love.graphics.setCanvas()

	redOverlay = love.graphics.newCanvas(w, h)
	love.graphics.setCanvas(redOverlay)
		love.graphics.setColor(200/255,10/255,20/255, 150/255)
		love.graphics.rectangle("fill", 0, 0, w, h)
	love.graphics.setCanvas()
end

function loadSounds()
	groundShatterEffect = love.audio.newSource("assets/sfx/effects/groundShatter.wav", "static")
	speedboostEffect = love.audio.newSource("assets/sfx/effects/speedboost.wav", "static")
	hitEffect = love.audio.newSource("assets/sfx/effects/hit.wav", "static")
	drillEffect = love.audio.newSource("assets/sfx/effects/drill.wav", "static")
	buttonEffect = love.audio.newSource("assets/sfx/effects/button.wav", "static")

	soundtrack = love.audio.newSource("assets/sfx/soundtrack/main.wav", "static")
	soundtrack:setLooping(true)
end 

function verticalGradient(width, height, ...)
	local canvas = love.graphics.newCanvas(width, height)
	local vertices = {}
	for i,v in ipairs({...}) do
		local y = (height  / (#{...} - 1)) * (i - 1)
		vertices[#vertices + 1] = {
			0, y,
			0, 0,
			v[1], v[2], v[3]
			}
		vertices[#vertices + 1] = {
			width, y,
			0, 0,
			v[1], v[2], v[3]
			}
	end
	local mesh = love.graphics.newMesh(vertices, "strip", "dynamic")
	love.graphics.setCanvas(canvas)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(mesh, 0, 0)
	love.graphics.setCanvas()
	return canvas
end