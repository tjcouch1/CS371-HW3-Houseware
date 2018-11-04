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
	time = 1500
}
local spriteSheet--the sprite sheet for everything
local itemToGet--the sprite that shows which item to get at the start of each round

--a 3x4 grid to place items in so they won't overlap
local board = {};

function initBoard()
	local cellWidth = display.contentWidth/4;
	local cellHeight = (display.contentHeight/2)/3;

	local initX = 0;
	local initY = (display.contentHeight/2) - cellHeight;

	for i=1, 3 do
  		board[i] = {};     -- create a new row
  		initX = 0;
  		initY = initY + cellHeight;
    	for j=1, 4 do 	   -- create a new column
        	board[i][j] = {
        		x = initX + cellWidth/2;
        		y = initY + cellHeight/2;
        		isFilled = false;
        	}
        	initX = initX + cellWidth;
        	--local rect = display.newRect(board[i][j].x, board[i][j].y, 5, 5);
    	end
	end

end



-- Temporary, just for getting scene set up. Transitions to intermediate
local function e (event)
	composer.gotoScene("intermediate", transition)
	return true
end

-- Temporary. Used multiple times.
local function gotoInter ()
	timer.performWithDelay (3000, e)
end

function scene:create( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	--set background to red
	local backRect = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	backRect:setFillColor(1, 0, 0)
	sceneGroup:insert(backRect)
	
	initBoard();

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
	local sceneText = display.newText(sceneGroup, "Stage 0", display.contentCenterX, 25, native.systemFont, 30)
	
	--create item to get
	--Frames 8 through 18 are valid objects
	local rand = math.random(8, 18);
	itemToGet = display.newSprite( sceneGroup, spriteSheet, {name="default", frames = {rand}});
	itemToGet.x = topDisplay.x; itemToGet.y = topDisplay.y;
	sceneGroup:insert(spawnObject(rand, sceneGroup));
	
	--create "Find!" text
	local findText = display.newText(sceneGroup, "Find!", topDisplay.x, topDisplay.y+75, native.systemFont, 25);
	findText:setFillColor(41/255, 228/255, 242/255)
	
	--create bottom display

	
	--create progress bar
	--TODO: create progress bar
	
	gotoInter()
end

function spawnObject(objNumber, sceneGroup)

	--First spawn in the correct object
	local randRow = math.random(1,3);
	local randCol = math.random(1,4);

	local correctObj = display.newSprite(sceneGroup, spriteSheet, {name="default", frames={objNumber}});
	correctObj.x = board[randRow][randCol].x; correctObj.y = board[randRow][randCol].y;
	board[randRow][randCol].isFilled = true;

	--Next spawn in a wrong object for each other cell
	for i = 1, 3 do
		for j = 1, 4 do
			--Frames 8 through 18 are valid
			local randFrame = math.random(8,18);
			local randIsNil = math.random(0, 1);
			if(board[i][j].isFilled == false) then
				local redHerring = display.newSprite(sceneGroup, spriteSheet, {name="default",frames={randFrame}} );
				redHerring.x = board[i][j].x; redHerring.y = board[i][j].y;
			end
		end
	end

	return correctObj;

end



function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
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
