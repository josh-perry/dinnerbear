-- Libraries
local class = require("libs/middleclass/middleclass")
local stateful = require("libs/stateful/stateful")

-- Shorthand
local lg = love.graphics

local Game = class("Game")
Game:include(stateful)

function Game:initialize()
	self.suspicion = 0

	lg.setBackgroundColor(80, 110, 200)
end

function Game:draw()
	lg.print("Default Game.draw")
end

function Game:update(dt)
end

function Game:keypressed(key, scancode, isRepeat)
end

function Game:changeState(state)
	print("Changing to state: "..state)
	self:gotoState(state)
	self:initialize()
end

function Game:drawUi()
	lg.print("Suspicion: "..self.suspicion.."%", 10, 10)
end

return Game