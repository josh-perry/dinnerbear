local stateful = require("libs/stateful/stateful")

local Game = require("Game")
require("MainMenu")
require("Drinks")

local function initDebug()
	-- ST3 output
	io.stdout:setvbuf("no")

	-- ZeroBrane debugging
	if arg[#arg] == "-debug" then
		require("mobdebug").start()
	end
end

function love.load()
	initDebug()

	Game = Game:new()
	Game:changeState("MainMenu")
end

function love.draw()
	love.graphics.setColor(255, 255, 255)
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