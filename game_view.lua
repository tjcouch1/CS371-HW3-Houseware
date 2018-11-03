-----------------------------------------------------------------------------------------
--
-- main.lua - allows the player to play the game
--
-- HW3-Houseware
-- Spencer Bowen, TJ Couch, Timothy Morrison, Jonah Minihan, Austin Vickers
--
-----------------------------------------------------------------------------------------

local composer = require("composer")

local scene = composer.newScene()

-- Transition back to intermediate view
local transition = {
	effect = "slideRight",
	time = 750
}
local spriteSheet--the sprite sheet for everything
local itemToGet--the sprite that shows which item to get at the start of each round
local stageText--the text at the top that shows which stage you're on
local stage

-- gotoInter returns to theintermediate screen
local function gotoInter ()
	composer.gotoScene("intermediate", transition)
end

function scene:create( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	stage = event.params.stageNum
	
	--set default fill color to black
	display.setDefault("fillColor", 0, 0, 0)
	
	--set background to red
	local backRect = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	backRect:setFillColor(1, 0, 0)
	sceneGroup:insert(backRect)
	backRect:addEventListener("tap", gotoInter)
	
	--set up sprites
	spriteSheet = graphics.newImageSheet("marioware.png", {
		frames = {
			{--frame 1 top display
				x = 1070,
				y = 4,
				width = 256,
				height = 192
			},
			{--frame 2 bottom display light
				x = 552,
				y = 6,
				width = 256,
				height = 192
			},
			{--frame 3 bottom display dark
				x = 881,
				y = 5,
				width = 256,
				height = 192
			},
			{--frame 4 bird up
				x = 148,
				y = 22,
				width = 40,
				height = 37
			},
			{--frame 5 bird down
				x = 191,
				y = 23,
				width = 40,
				height = 34
			},
			{--frame 6 correct circle
				x = 369,
				y = 8,
				width = 40,
				height = 40
			},
			{--frame 7 incorrect x
				x = 414,
				y = 11,
				width = 34,
				height = 34
			},
			{--frame 8 bottle right
				x = 379,
				y = 123,
				width = 16,
				height = 40
			},
			{--frame 9 bottle mid
				x = 403,
				y = 123,
				width = 16,
				height = 40
			},
			{--frame 10 white hat
				x = 430,
				y = 116,
				width = 31,
				height = 19
			},
			{--frame 11 blue hat
				x = 430,
				y = 138,
				width = 31,
				height = 19
			},
			{--frame 12 yellow hat
				x = 430,
				y = 160,
				width = 31,
				height = 19
			},
			{--frame 13 cup v
				x = 474,
				y = 111,
				width = 22,
				height = 24
			},
			{--frame 14 cup dots
				x = 474,
				y = 136,
				width = 21,
				height = 23
			},
			{--frame 15 cup line
				x = 474,
				y = 160,
				width = 21,
				height = 23
			},
			{--frame 16 flowers \\\
				x = 512,
				y = 94,
				width = 21,
				height = 30
			},
			{--frame 17 flowers wavy
				x = 513,
				y = 125,
				width = 21,
				height = 32
			},
			{--frame 18 flowers dots
				x = 511,
				y = 158,
				width = 21,
				height = 32
			}
		}
	})
	
	--create top display
	local topDisplay = display.newSprite(sceneGroup, spriteSheet, {name = "default", frames = {1}})
	topDisplay.x = display.contentWidth / 2
	topDisplay.y = display.contentHeight / 4
	topDisplay:scale(1.25, 1.25)
	
	-- top text displaying stage
	stageText = display.newText(sceneGroup, "Stage "..stage, display.contentCenterX, 25, native.systemFont, 30)
	
	--create item to get display
	
	--create "Find!" text
	display.newText(sceneGroup, "Find!", display.contentCenterX, display.contentHeight * 9 / 30, native.systemFont, 30)
	
	--create bottom display of the room
	local bottomDisplay = display.newSprite(sceneGroup, spriteSheet, {name = "default", frames = {2}})
	bottomDisplay.x = display.contentWidth / 2
	bottomDisplay.y = display.contentHeight * 3 / 4
	bottomDisplay:scale(1.25, 1.25)
	
	--create progress bar
	--TODO: create progress bar
	
	
	--set default fill color back to white
	display.setDefault("fillColor", 1, 1, 1)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then
		--update to the right stage
		stageText.text = "Stage "..stage
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
