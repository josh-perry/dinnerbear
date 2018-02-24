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

	self.uiFont = love.graphics.newFont("fonts/Architex.ttf", 36)
	self.bigUiFont = love.graphics.newFont("fonts/Architex.ttf", 72)

	self.suspicionText = love.graphics.newText(self.uiFont, "Suspicion ")

	self.music = love.audio.newSource("music/Hall of the Mountain King.mp3")
	self.music:setLooping(true)
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
	lg.setFont(self.uiFont)
	lg.draw(self.suspicionText, 10, 10)

	lg.setFont(self.bigUiFont)
	lg.print(self.suspicion.."%", 20 + self.suspicionText:getWidth(), 0)
end

return Game