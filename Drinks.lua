-- Libraries
local class = require("libs/middleclass/middleclass")

-- Shorthand
local lg = love.graphics

local Game = require("Game")
local Drinks = Game:addState("Drinks")

function Drinks:initialize()
end

function Drinks:draw()
	lg.print("Drinking", 10, 10)
end

function Drinks:update(dt)
end

function Drinks:keypressed(key, scancode, isRepeat)
end

return Drinks