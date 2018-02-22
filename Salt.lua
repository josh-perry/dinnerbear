-- Libraries
local class = require("libs/middleclass/middleclass")

-- Shorthand
local lg = love.graphics

local Game = require("Game")
local Salt = Game:addState("Salt")

function Salt:initialize()
end

function Salt:draw()
	lg.printf("salty boi", 0, lg:getHeight() / 2, lg:getWidth(), "center")
end

function Salt:update(dt)
end

function Salt:keypressed(key, scancode, isRepeat)
end

return Salt