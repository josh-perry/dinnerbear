local stateful = require("libs/stateful/stateful")

local Game = require("Game")
require("MainMenu")

function love.load()
	Game = Game:new()
	Game:gotoState("MainMenu")
	Game:initialize()
end

function love.draw()
	Game:draw()
end

function love.update(dt)
	Game:update(dt)
end

function love.keypressed(key, scancode, isRepeat)
	if key == "escape" then
		love.event.quit()
		return
	end

	Game:keypressed(key, scancode, isRepeat)
end