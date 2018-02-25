-- Libraries
local class = require("libs/middleclass/middleclass")

-- Shorthand
local lg = love.graphics

local Game = require("Game")
local Win = Game:addState("Win")

function Win:initialize()
	self.music:stop()
end

function Win:draw()
	lg.printf("congratuations: you got through dinner and no-one knows you're actually a bear", 0, lg:getHeight() / 2, lg:getWidth(), "center")
end

function Win:update(dt)
end

function Win:keypressed(key, scancode, isRepeat)
	if key == "space" then
		self:changeState("MainMenu")
	end
end

return Win