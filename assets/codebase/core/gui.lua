function createGUI() -- All gooi buttons go here

	imageButtonStyle = {
        font = game:fontSize(17),
        radius = 5,
        innerRadius = 3,
        showBorder = true,
        bgColor = {255,255,255,0}
    }

    textButtonStyle = {
        font = game:fontSize(17),
        radius = 5,
        innerRadius = 3,
        showBorder = true,
        bgColor = {42, 96, 183,255}
    }
    gooi.setStyle(imageButtonStyle)
    gooi.desktopMode()

    --gooi.mode3d()
    --gooi.glass()
    
    gooi.shadow()


	pauseButton = gooi.newButton({text = "", x = 3, y = 3 + game.notchOffset, icon = "assets/gfx/icons/pausebutton.png", w = 49, h = 49, visible = false} -- Pause button
		):onRelease(function()
            game.state = "paused"

            if game.sfx then 
                love.audio.play(buttonEffect)
            end
        end):setGroup("playing") 


		local x = avatarPicker.width - 35
		local y = avatarPicker.height 
    avatarPickerRight = gooi.newButton({text = "", x = x, y = y, icon = "assets/gfx/icons/arrowRight.png", w = 22*3, h = 18*3, visible = false} -- Pause button
		):onRelease(function()
			if avatarPicker.highlightedAvatar.position < #avatarPicker.avatars then 
				avatarPicker.highlightedAvatar = avatarPicker.avatars[avatarPicker.highlightedAvatar.position+1] -- Highlight the avatar after the current one
			else
                avatarPicker.highlightedAvatar = avatarPicker.avatars[1]
            end

            if game.sfx then 
                love.audio.play(buttonEffect)
            end
        end):setGroup("avatarPicker") 


		local x = avatarPicker.x + 5
     avatarPickerLeft = gooi.newButton({text = "", x = x, y = y, icon = "assets/gfx/icons/arrowLeft.png", w = 22*3, h = 18*3, visible = false} -- Pause button
		):onRelease(function()
			if avatarPicker.highlightedAvatar.position > 1 then 
				avatarPicker.highlightedAvatar = avatarPicker.avatars[avatarPicker.highlightedAvatar.position-1] -- Highlight the avatar before the current one
            else
                avatarPicker.highlightedAvatar = avatarPicker.avatars[#avatarPicker.avatars]
			end

            if game.sfx then 
                love.audio.play(buttonEffect)
            end
        end):setGroup("avatarPicker") 



        local x = avatarPicker.x + avatarPicker.width / 2 - (128*1.4 / 2) + 1
    avatarSelect = gooi.newButton({text = "", x = x, y = y, icon = "assets/gfx/icons/selectButton.png", w = 128*1.4, h = 32*1.5, visible = false} -- select button
        ):onRelease(function()
            avatarPicker:select()

        if game.sfx then 
            love.audio.play(buttonEffect)
        end
        end):setGroup("avatarPicker") 

	
    avatarButton = gooi.newButton({text = "", x = game.width - 64 - 4, y = 4 + game.notchOffset, icon = "assets/gfx/icons/avatarButton.png", w = 64, h = 64, visible = true} -- Avatar button
		):onRelease(function()
            avatarPicker.visible = true
            avatarPickerLeft:setVisible(true)
            avatarPickerRight:setVisible(true)
            exitAvatarButton:setVisible(true)

            avatarPicker:checkHighscore()

            game.state = "avatarPicker"

            if game.sfx then 
                love.audio.play(buttonEffect)
            end
        end):setGroup("menu")

    exitAvatarButton = gooi.newButton({text = "", x = avatarPicker.width +avatarPicker.x - 40 - 4, y = avatarPicker.y + 4, icon = "assets/gfx/icons/exitButton.png", w = 40, h = 40, visible = false} -- Avatar button
        ):onRelease(function()
            avatarPicker.visible = false
            avatarPickerLeft:setVisible(false)
            avatarPickerRight:setVisible(false)
            exitAvatarButton:setVisible(false)

            game.state = "menu"
            if game.sfx then 
                love.audio.play(buttonEffect)
            end
        end):setGroup("avatarPicker")




    --Settings

     settingsButton = gooi.newButton({text = "", x = game.width - 128 - 8, y = 4 + game.notchOffset, icon = "assets/gfx/icons/settingsButton.png", w = 64, h = 64, visible = true} -- Avatar button
        ):onRelease(function()
            game.state = "settingsPanel"

            if game.sfx then 
                love.audio.play(buttonEffect)
            end
        end):setGroup("menu")

    exitSettingsPanel = gooi.newButton({text = "", x = settingsPanel.width +settingsPanel.x - 46, y = settingsPanel.y + 5, icon = "assets/gfx/icons/exitButton.png", w = 40, h = 40, visible = false} -- Avatar button
        ):onRelease(function()

            game:writeSave()      
            game.state = "menu"

            if game.sfx then 
                love.audio.play(buttonEffect)
            end
        end):setGroup("settingsPanel")

    resetScoreButton = gooi.newButton({text = "", x = settingsPanel.x + settingsPanel.width / 2 - 248/2, y = settingsPanel.y + 60, icon = "assets/gfx/icons/resetHighscore.png", w = 248, h = 32, visible = false} -- Avatar button
        ):onRelease(function()
            player.highscore = 0
            player:setAvatar(avatarPicker.avatars[1].sheet)
            game:writeSave(0)

            if game.sfx then 
                love.audio.play(buttonEffect)
            end

        end):setGroup("settingsPanel")

    sfxButton = gooi.newButton({text = "",x = settingsPanel.x + settingsPanel.width - 76 - 25, y = settingsPanel.y + settingsPanel.height - 76*2 - 85, icon = "assets/gfx/icons/sfxButton.png", w = 76, h = 76, visible = false} -- Avatar button
        ):onRelease(function()
            game.sfx = not game.sfx

        if game.sfx then
            love.audio.play(buttonEffect)
        end
    end):setGroup("settingsPanel")

    arrowButton = gooi.newButton({text = "", x = settingsPanel.x + 25, y = settingsPanel.y + settingsPanel.height - 76*2 - 85, icon = "assets/gfx/icons/arrowButton.png", w = 76, h = 76, visible = false} -- Avatar button
        ):onRelease(function()
            game.arrowHelp = not game.arrowHelp

        if game.sfx then
            love.audio.play(buttonEffect)
        end
    end):setGroup("settingsPanel")

    --Stretch button is just disabled now
    --[[
    if os ~= "iOS" then -- Strech option is disabled on iOS
        stretchButton = gooi.newButton({text = "", x = settingsPanel.x + settingsPanel.width - 76 - 25, y = settingsPanel.y + settingsPanel.height - 76*2 - 85, icon = "assets/gfx/icons/stretchButton.png", w = 76, h = 76, visible = false} -- Stretch button
            ):onRelease(function()
                game.stretch = not game.stretch


                if game.stretch then 
                    gameCanvas = love.graphics.newCanvas(405, 720)
                    gooi.setCanvas(gameCanvas)

                    game.actualHeight = game.height
                else
                    if math.floor(love.graphics.getHeight() / 720) >= 1 then 
                        gameCanvas = love.graphics.newCanvas()
                        gooi.setCanvas(gameCanvas)

                        game.actualHeight = love.graphics.getHeight()
                    end
                end

            if game.sfx then
                love.audio.play(buttonEffect)
            end
        end):setGroup("settingsPanel")
    end
    ]]

    
    notchButton = gooi.newButton({text = "", x = settingsPanel.x + settingsPanel.width / 2 - 76/2, y = settingsPanel.y + settingsPanel.height - 76*2 - 85, icon = "assets/gfx/icons/notchButton.png", w = 76, h = 76, visible = false} -- Stretch button
            ):onRelease(function()

        game.notch = not game.notch


        if game.notch then 
            game.notchOffset = 25
        else
            game.notchOffset = 0
        end 

        avatarButton.y = 4 + game.notchOffset
        settingsButton.y = 4 + game.notchOffset
        pauseButton.y = 3 + game.notchOffset




        if game.sfx then
            love.audio.play(buttonEffect)
        end
    end):setGroup("settingsPanel")



    musicButton = gooi.newButton({text = "", x = settingsPanel.x + 25, y = settingsPanel.y + settingsPanel.height - 76 - 55, icon = "assets/gfx/icons/musicButton.png", w = 76, h = 76, visible = false} -- Avatar button
        ):onRelease(function()

        if game.music then 
            game.music = false
            soundtrack:seek(0)
            soundtrack:pause()
        else
            game.music = true
            soundtrack:play()
        end 

        if game.sfx then
            love.audio.play(buttonEffect)
        end
    end):setGroup("settingsPanel")

    vibrationButton = gooi.newButton({text = "", x = settingsPanel.x + settingsPanel.width / 2 - 76/2, y = settingsPanel.y + settingsPanel.height - 76*2 - 85, icon = "assets/gfx/icons/vibrationButton.png", w = 77, h = 77, visible = false} -- Avatar button
        ):onRelease(function()
            game.vibration = not game.vibration

            if game.sfx then
                love.audio.play(buttonEffect)
            end
        end):setGroup("settingsPanel")


    --Shop
    shopButton = gooi.newButton({text = "", x = game.width - 128 - 8, y = 4 + game.notchOffset, icon = "assets/gfx/icons/bookButton.png", w = 64, h = 64, visible = false} -- Avatar button
        ):onRelease(function()
            game.state = "shopPanel"

            if game.sfx then 
                love.audio.play(buttonEffect)
            end
    end):setGroup("menu")

    exitShopPanel = gooi.newButton({text = "", x = shopPanel.width + shopPanel.x - 40 - 4, y = shopPanel.y + 4, icon = "assets/gfx/icons/exitButton.png", w = 40, h = 40, visible = false} -- Avatar button
        ):onRelease(function()

            game:writeSave()      
            game.state = "menu"

            if game.sfx then 
                love.audio.play(buttonEffect)
            end
        end):setGroup("shopPanel")

     upgradeDrillButton = gooi.newButton({text = "", x = shopPanel.x + 190, y = shopPanel.y + 100, icon = "assets/gfx/icons/upgradeButton.png", w = 24, h = 32, visible = false} -- Avatar button
        ):onRelease(function()

            if player.coins >= 2^(player.drillBuff+2) and player.drillBuff < 5 then 
                player.coins = player.coins - 2^(player.drillBuff+2)
                player.drillBuff = player.drillBuff + 1 
            end

            game:writeSave() 

            if game.sfx then 
                love.audio.play(buttonEffect)
            end
        end):setGroup("shopPanel")

    upgradeSpeedButton = gooi.newButton({text = "", x = shopPanel.x + 190, y = shopPanel.y + 150, icon = "assets/gfx/icons/upgradeButton.png", w = 24, h = 32, visible = false} -- Avatar button
        ):onRelease(function()

            if player.coins >= 2^(player.speedBuff+2) and player.speedBuff < 5 then 
                player.coins = player.coins - 2^(player.speedBuff+2)
                player.speedBuff = player.speedBuff + 1 
            end

            game:writeSave() 

            if game.sfx then 
                love.audio.play(buttonEffect)
            end
        end):setGroup("shopPanel")

end

function updateGUI()
    --I really don't like the way of doing this. Can't quickly think of a better way though

    if game.state == "playing" then 
        pauseButton:setVisible(true)
    else
        pauseButton:setVisible(false)
    end

    if game.state == "avatarPicker" then 
        avatarPickerLeft:setVisible(true)
        avatarPickerRight:setVisible(true)
        avatarSelect:setVisible(true)
    else
        avatarPickerLeft:setVisible(false)
        avatarPickerRight:setVisible(false)
        avatarSelect:setVisible(false)
    end

    if game.state == "menu" then 
        avatarButton:setVisible(true)
        settingsButton:setVisible(true)
        --shopButton:setVisible(true)
    else
        avatarButton:setVisible(false)
        settingsButton:setVisible(false)
        --shopButton:setVisible(false)
    end

    if game.state == "dead" then 
        deathscreen:setVisible(true)
    else
        deathscreen:setVisible(false)
    end

    if game.state == "settingsPanel" then 
        exitSettingsPanel:setVisible(true)
        resetScoreButton:setVisible(true)
        sfxButton:setVisible(true)
        musicButton:setVisible(true)
        vibrationButton:setVisible(true)
        arrowButton:setVisible(true)
        
        
        --[[
        if os ~= "iOS" then 
            stretchButton:setVisible(true)
        end
        ]]
        
        
        notchButton:setVisible(true)
    else
        exitSettingsPanel:setVisible(false)
        resetScoreButton:setVisible(false)
        sfxButton:setVisible(false)
        musicButton:setVisible(false)
        vibrationButton:setVisible(false)
        arrowButton:setVisible(false)

        --[[
        if os ~= "iOS" then 
            stretchButton:setVisible(false)
        end
        ]]

        notchButton:setVisible(false)
    end 

    if game.state == "shopPanel" then 
        exitShopPanel:setVisible(true)
        upgradeDrillButton:setVisible(true)
    else
        exitShopPanel:setVisible(false)
        upgradeDrillButton:setVisible(false)
    end 



   --Easier to just disable the buttons than completely remove them
   shopButton:setVisible(false)
   notchButton:setVisible(false)

end 