-----------------------------------------------------------------------------------------
--
-- main.lua - allows the player to play the game
--
-- HW3-Houseware
-- Spencer Bowen, TJ Couch, Timothy Morrison, Jonah Minihan, Austin Vickers
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()

local sceneGroup--the scene view to add displayObjects to
local spriteSheet--the sprite sheet for everything
local itemToGet--the sprite that shows which item to get at the start of each round
local stageText--the text at the top that shows which stage you're on
local stage--which stage we're on
local win = false--whether the player won
local roundTimer--timer to count down to the expire time for round
local roundLength = 8--round time in seconds
local roundTimeText--text that shows time left in round in seconds
local topDisplay;
local bottomDisplay;
local objGroup;
local goose;
local screenOpen;
local clickable;
local isPaused;
local winMusic = audio.loadStream( "win.wav" );
local loseMusic = audio.loadStream( "lose.wav" );
local objFrameTable = {--table of frames to use for each object index 1-21
	8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,--11 normal objects
	8,    10, 11, 12, 13, 14, 15, 16, 17, 18--10 flipped objects
}
local progressBar;--the progressView widget
--local stageDecoy = 1

-- gotoInter returns to the intermediate screen
local function gotoInter ()
	if roundTimer ~= nil then
		timer.cancel(roundTimer)
	end
	timer.performWithDelay(1000, function()--timer.resume(timerRef); 
		composer.gotoScene("intermediate", {
			effect = "slideRight",
			time = 750,
			params = {
				success = win
			}
		})
	end)
--	composer.gotoScene("intermediate", {
--		effect = "slideRight",
--		time = 750,
--		params = {
--			success = win
--		}
--	})
end

--a 3x4 grid to place items in so they won't overlap
local board = {};

function initBoard()
	local cellWidth = display.contentWidth/5;
	local cellHeight = (display.contentHeight/2)/3;

	local initX = 0;
	local initY = (display.contentHeight/2) - cellHeight;

	board = {};

	for i=1, 3 do
  		board[i] = {};     -- create a new row
  		initX = 0;
  		initY = initY + cellHeight;
    	for j=1, 5 do 	   -- create a new column
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

--correctObjectTapped(event) Win round!
function correctObjectTapped(event)
	if(clickable == 1)then 
	print("Correct object tapped!")
	win = true;
	local winChannel = audio.play( winMusic )
	correctCircle = display.newSprite( sceneGroup, spriteSheet, {name="default", frames = {6}});
	correctCircle:scale(1.25, 1.25)
	correctCircle.x = event.target.x;
	correctCircle.y = event.target.y;
	objGroup:insert(correctCircle);
	screenOpen = 0;
	clickable = 0;
	gotoInter();
	end
end

--wrongObjectTapped(event) Lose round :(
function wrongObjectTapped(event)
	if(clickable == 1)then
	print("Wrong Object Tapped!")
	local loseChannel = audio.play( loseMusic )
	incorrectCross = display.newSprite( sceneGroup, spriteSheet, {name="default", frames = {7}});
	incorrectCross:scale(1.25, 1.25)
	incorrectCross.x = event.target.x;
	incorrectCross.y = event.target.y;
	objGroup:insert(incorrectCross);
	screenOpen = 0;
	clickable = 0;
	gotoInter()
	end 
end

--roundTimerCountDown(event) counts seconds down for the round time and ends the game at round length
--this is necessary to update the progress bar and time display
local function roundTimerCountDown(event)
	roundTimeText.text = roundLength - event.count
	progressBar:setProgress(((roundLength-event.count) / roundLength))
	if event.count >= roundLength then
		--end round on a loss
		gotoInter()
	end
end

function scene:create( event )
	sceneGroup = self.view
	local phase = event.phase
	
	stage = event.params.stageNum

	--set default fill color to black
	display.setDefault("fillColor", 0, 0, 0)

	--set background to red
	local backRect = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	backRect:setFillColor(1, 0, 0)
	sceneGroup:insert(backRect)

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
	topDisplay = display.newSprite(sceneGroup, spriteSheet, {name = "default", frames = {1}})
	topDisplay.x = display.contentWidth / 2
	topDisplay.y = display.contentHeight / 4
	topDisplay:scale(1.25, 1.25)

	-- top text displaying stage
	stageText = display.newText(sceneGroup, "Stage "..stage, display.contentCenterX, 25, native.systemFont, 30)

	--create "Find!" text
	display.newText(sceneGroup, "Find!", display.contentCenterX, display.contentHeight * 1 / 3, native.systemFont, 24)

	--create bottom display of the room
	bottomDisplay = display.newSprite(sceneGroup, spriteSheet, {name = "default", frames = {2}})
	bottomDisplay.x = display.contentWidth / 2
	bottomDisplay.y = display.contentHeight * 3 / 4
	bottomDisplay:scale(1.25, 1.25)

	--text for round time
	roundTimeText = display.newText(sceneGroup, roundLength, 0, display.contentHeight, native.systemFont, 16)
	roundTimeText.anchorX = 0
	roundTimeText.anchorY = 1

	--create progress bar
	progressBar = widget.newProgressView(
		{
			x = display.contentCenterX,
			y = display.contentHeight - 10,
			width = 300,
			isAnimated = true
		}
	)
	progressBar:setProgress(1)
	sceneGroup:insert(progressBar)

	--set default fill color back to white
	display.setDefault("fillColor", 1, 1, 1)
end

local function stopGooseHandler(event)
	if(isPaused == 0)then 
		isPaused = 1;
	timer.pause(timerRef)
	goose:pause()
	if(screenOpen == 1) then
		timer.performWithDelay(3000, function()timer.resume(timerRef); 
			if(screenOpen == 1)then 
				goose:play(); 
				isPaused = 0;
			end
		end)
	end
	end
	return true;
end
--spawn the goose
function spawnGoose()
	isPaused = 0;
	screenOpen = 1;
	local opt =
	{
		frames = {
			{ x = 147, y = 19, width = 41, height = 41}, --frame 1
			{ x = 191, y = 19, width = 41, height = 41}, --frame 2
		}
	}
	local sheet = graphics.newImageSheet( "marioware.png", opt);
	
	
	
	local seqData = {
		{name = "normal", start=0 ,count = 1, frames={1,2}, time=800},
		{name = "faster", start=0, count=1, frames={1,2}, time = 800},
	}
	goose = display.newSprite (sheet, seqData);
	objGroup:insert(goose)
	goose:setSequence("normal");
	goose:play();
	goose.x = display.contentWidth / 2
	--goose.x = 0
	goose.y = display.contentHeight * 3 / 4
	--goose.y = display.contentHeight / 4
	goose:scale(2.5,2.5)
	deltaX = 1
	goose.dx = 1
	goose.dy = 1
	--[[]
	timerRef= timer.performWithDelay( 10, function() 
		if(goose.x ~= nil) then
		goose.x= goose.x+goose.dx; 
		goose.y= goose.y+goose.dy; 
	if((goose.x + deltaX) > (display.contentWidth) or (goose.x + goose.dx) < 0) then
		goose.dx = -goose.dx
		goose:scale(-1,1)
	end
	

	if((goose.y + goose.dy) > (display.contentHeight)  or (goose.y + goose.dy) < display.contentHeight / 2) then
		goose.dy = -goose.dy
	end
	end
		end,
			
			
			
			0 )
	
	goose:addEventListener("tap", stopGooseHandler)
	--]]
end


function moveGoose(goose) --move the goose around the box
	if(goose ~= nil) then
	timerRef= timer.performWithDelay( 10, function() 
		if(goose.x ~= nil) then
		goose.x= goose.x+goose.dx; 
		goose.y= goose.y+goose.dy; 
	if((goose.x + deltaX) > (display.contentWidth) or (goose.x + goose.dx) < 0) then
		goose.dx = -goose.dx
		goose:scale(-1,1)
	end
	

	if((goose.y + goose.dy) > (display.contentHeight)  or (goose.y + goose.dy) < display.contentHeight / 2) then
		goose.dy = -goose.dy
	end
	end
		end,
			
			
			
			0 )
	goose:addEventListener("tap", stopGooseHandler)
	end




end

--moveGoose(goose)

--function spawnObject(objNumber, sceneGroup, maxObjects)
--spawnObjects(objNumber, sceneGroup, maxObjects) create maxObjects number of items with index objNumber in the sceneGroup
function spawnObjects(sceneGroup, maxObjects)
	clickable = 1;
	--create item to get
	--1 to 21 are valid objects
	local objectIndex = math.random(1, 21);
	print(objFrameTable[objectIndex])
	itemToGet = display.newSprite( sceneGroup, spriteSheet, {name="default", frames = {objFrameTable[objectIndex]}});
	itemToGet:scale(1.25, 1.25)
	--flip sprite for mirrored objects
	if objectIndex > 11 then
		itemToGet:scale(-1, 1)
	end
	itemToGet.x = topDisplay.x; itemToGet.y = topDisplay.y;

	--First spawn in the correct object
	local randRow = math.random(1,3);
	local randCol = math.random(1,5);

	local correctObj = display.newSprite(sceneGroup, spriteSheet, {name="default", frames={objFrameTable[objectIndex]}});
	correctObj:scale(1.25, 1.25)
	--flip sprite for mirrored objects
	if objectIndex > 11 then
		correctObj:scale(-1, 1)
	end
	correctObj.x = board[randRow][randCol].x; correctObj.y = board[randRow][randCol].y;
	board[randRow][randCol].isFilled = true;

	correctObj:addEventListener( "tap", correctObjectTapped )

	local objCount = 1;

	--The following algorithm employs busy waiting for whenever i and j are a location that is already filled,
	--making this less efficient. However, for a max of 12 elements this doesn't pose a serious issue. Additionally,
	--this alg. ensures there will always be exactly maxObjects spawned. 	--AV

	--Next spawn in a wrong object for each other cell
	while objCount < maxObjects do
		local i = math.random(1,3);	--random row
		local j = math.random(1,5);	--random column
		--1 to 21 are valid objects

		local randFrame = math.random(1, 21);

		if (stage > 6) then--Extra difficulty --Tim

			if (math.random (1,100) < 21) then--20% chance to spawn a nearby one

				if (objectIndex < 21) then
					if (math.random(1,100) < 51) then
						randFrame = objectIndex - 1;
					else
						randFrame = objectIndex + 1;
					end
				else

					randFrame = math.random(1,21);
				end
				--print("Neighbor Spawned!")
			elseif (math.random (1,100) < 31) then--If that fails, a 30% chance to spawn a mirrored one
				if (objectIndex > 11) then
					randFrame = objectIndex - 11;
				else
					randFrame = objectIndex + 11;
				end
				--print("Mirror Spawned!")
			end
		else
			--local randFrame = math.random(1, 21);
		end


		if(board[i][j].isFilled == false) then
			if(randFrame ~= objectIndex) then
				local redHerring = display.newSprite(sceneGroup, spriteSheet, {name="default",frames={objFrameTable[randFrame]}} );
				redHerring:scale(1.25, 1.25)
				--flip sprite for mirrored objects
				if randFrame > 11 then
					redHerring:scale(-1, 1)
				end
				redHerring.x = board[i][j].x; redHerring.y = board[i][j].y;
				redHerring:addEventListener("tap", wrongObjectTapped );
				board[i][j].isFilled = true;
				objCount = objCount + 1;
			end
		end
	end

	return correctObj;

end

--[[]
	This algorithm is problematic because it only ensures that NO MORE than max objects are spawned.
	Any amount less than than is left up to the random randIsNil value. However, this solution employs
	no busy waiting, and is more efficient. But, given the constraints of the project, the above alg
	provides more control and less randomness, and so this one is deprecated

	--AV

	for i = 1, 3 do
		for j = 1, 4 do

			if(objCount >= maxObjects) then
				break;
			end

			--Frames 8 through 18 are valid
			local randFrame = math.random(8,18);
			local randIsNil = math.random(0, 1);
			if(board[i][j].isFilled == false and randIsNil ~= 1) then
				if(randFrame ~= objNumber) then
					local redHerring = display.newSprite(sceneGroup, spriteSheet, {name="default",frames={randFrame}} );
					redHerring.x = board[i][j].x; redHerring.y = board[i][j].y;
					redHerring:addEventListener("tap", wrongObjectTapped );
					objCount = objCount + 1;
				end
			end
		end
	end
--]]


function scene:show( event )
	local phase = event.phase

	if phase == "will" then
		--initializations
		initBoard();
		objGroup = display.newGroup();
		sceneGroup:insert(objGroup)

		--update to the right stage
		stage = event.params.stageNum

		--stageDecoy = stage

		stageText.text = "Stage "..stage
		win = false--reset the win state
		roundTimeText.text = roundLength--reset the timer display
		roundTimer = timer.performWithDelay(1000, roundTimerCountDown, roundLength)--start game timer to loss
		--create objects
		if (stage < 4) then
			spawnObjects(objGroup, math.random (3,5));
		elseif (stage < 7) then
			spawnObjects(objGroup, math.random (6,8));
		else
			spawnObjects(objGroup, math.random (9,15));
		end
		progressBar:setProgress(1)
		--Spawn and move goose
		spawnGoose();
		moveGoose(goose);
	end
	if(phase == "did") then
	end

end

function scene:hide( event )
	local phase = event.phase
	if phase == "will" then
		screenOpen = 0;
		objGroup:removeSelf( );
	end
end

function scene:destroy( event )
	local phase = event.phase
	if spriteSheet ~= nil then
		spriteSheet = nil
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
