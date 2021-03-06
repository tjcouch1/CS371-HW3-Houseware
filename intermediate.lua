-----------------------------------------------------------------------------------------
--
-- intermediate.lua - shows the player's lives and sends them to the next game
--
-- HW3-Houseware
-- Spencer Bowen, TJ Couch, Timothy Morrison, Jonah Minihan, Austin Vickers
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()

-- Keep track of lives and stage here
local lives = 4
local stage = 1
--declares titleButton for future use
local titleButton;

--declares sounds for winning and losing
local winSnd = audio.loadSound("win.wav")
local lossSnd = audio.loadSound("lose.wav")

-- Listener function for switching to game scene, happens after a couple seconds
local function switchSceneToGame( event )
	if (stage <= 10 and lives > 0) then
		composer.gotoScene("game_view", {
			effect = "slideLeft",
			time = 750,
			params = {
				stageNum = stage
			}
		})
		return true
	end
end
--listens for titlebutton upon game win or loss
local function titleButtonListener(event)
	composer.gotoScene("title", {effect = "slideRight", time = 750})
end



function scene:create( event )
	local sceneGroup = self.view
	local phase = event.phase

	--rectangle to click to go to game quickly
	local backRect = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	backRect.isHitTestable = true
	backRect:setFillColor(1, 1, 1, 0)
	sceneGroup:insert(backRect)

	--title button to continue to next stage and to send back to title after the game is over
	titleButton = widget.newButton({
		label = "Continue to Next Stage",
		onRelease = function() if stage <= 10 and lives > 0 then switchSceneToGame() else titleButtonListener() end end,
		shape = "roundedRect",
		width = display.contentWidth * 2 / 3,
		height = display.contentHeight / 10,
		x = display.contentCenterX,
		y = display.contentCenterY + 100
	})
	sceneGroup:insert(titleButton)

	-- Shows the number of lives remaining at the top of the screen
	livesDisplay = display.newText(sceneGroup, lives.." Lives Remain", display.contentCenterX, 20, native.systemFont, 24)
	-- Tried to find a nice pink color for the lives message
	livesDisplay:setFillColor(1,0.33,0.5)

	-- Shows the current stage of the player
	stageDisplay = display.newText(sceneGroup, "Stage "..stage, display.contentCenterX, display.contentCenterY, native.systemFont, 28)

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if(phase == "will") then
		-- If the previous scene was the game and the player succeeded, increase stage. Or if they failed, decrease lives.
		if event.params ~= nil then
			if event.params.success then
				--win round
			stage = stage + 1
			else
				--lose round
				lives = lives - 1
				if stage < 10 then
					stage = stage + 1
				end
			end
		end

		-- If the player still has lives, continue on to next stage. If not, game over. If stage 10 completed, show congrats/play again type deal
		if(lives > 0 and stage <= 10) then
			--continue to next round
			livesDisplay.text = lives.." Lives Remain"
			stageDisplay.text = "Stage "..stage
			titleButton:setLabel("Continue to Next Stage");
		elseif(lives <= 0) then
			--lose game
			livesDisplay.text = ""
			stageDisplay.text = "Game Over!"
			titleButton:setLabel("Return to Title Screen");
			audio.play(lossSnd)
		elseif(stage > 10) then
			--win game
			livesDisplay.text = ""
			stageDisplay.text = "You win!"
			titleButton:setLabel("Return to Title Screen");
			audio.play(winSnd)
		end
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "did" then
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	local phase = event.phase
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
