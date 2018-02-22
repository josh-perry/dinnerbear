-- Libraries
local class = require("libs/middleclass/middleclass")

-- Shorthand
local lg = love.graphics

local Game = require("Game")
local GameOver = Game:addState("GameOver")

function GameOver:initialize()
end

function GameOver:drawBear(x, y)
end

function GameOver:draw()
	lg.printf("game over, they know ur a bear IDIOT", 0, lg:getHeight() / 2, lg:getWidth(), "center")
end

function GameOver:update(dt)
end

function GameOver:keypressed(key, scancode, isRepeat)
	if key == "space" then
		self:changeState("MainMenu")
	end
end

return GameOver