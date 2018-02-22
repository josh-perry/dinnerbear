-- Libraries
local class = require("libs/middleclass/middleclass")

-- Shorthand
local lg = love.graphics

local Game = require("Game")
local MainMenu = Game:addState("MainMenu")

function MainMenu:initialize()
end

function MainMenu:draw()
	lg.print("Main menu draw")
end

function MainMenu:update(dt)
end

function MainMenu:keypressed(key, scancode, isRepeat)
end

return MainMenu