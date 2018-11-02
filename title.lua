
local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	-- Title and names
	local title = display.newText(sceneGroup, "Houseware", display.contentCenterX, display.contentCenterY/2, native.systemFont, 36)
	local names = display.newText(sceneGroup, "Spencer Bowen\nTJ Couch\nTimothy Morrison\nJonah Minihan\nAustin Vickers", display.contentCenterX, display.contentCenterY, native.systemFont, 12)
	
	-- Listener for when "Start" button is released. Moves to intermediate scene.
	local function release ( event )
		composer.gotoScene("intermediate")
		return true
	end
	
	-- "Start" button
	local start = widget.newButton({
		x = display.contentCenterX, 
		y = display.contentCenterY*3/2, 
		onRelease = release
	})
	start:setLabel("Start")
	sceneGroup:insert(start)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
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