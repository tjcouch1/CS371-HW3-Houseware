
local composer = require("composer")

local scene = composer.newScene()

-- Transition back to intermediate view
local transition = {
	effect = "slideRight",
	time = 1500
}

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
	
	-- Temporary, just need to see indication of scene
	local sceneText = display.newText(sceneGroup, "Game View", display.contentCenterX, display.contentCenterY, native.systemFont, 24)
	
	gotoInter()
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