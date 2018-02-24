-- Libraries
local class = require("libs/middleclass/middleclass")
local stateful = require("libs/stateful/stateful")
local cron = require("libs/cron/cron")

-- Shorthand
local lg = love.graphics

local BearSpeech = class("BearSpeech")

function BearSpeech:initialize()
	self.image = lg.newImage("graphics/bear_speech.png")

	self.position = {
		x = (lg:getWidth() / 2) - (self.image:getWidth() / 2),
		y = (lg:getHeight() / 2) - (self.image:getHeight() / 2)
	}

	self.speed = 200
end

function BearSpeech:draw()
	lg.draw(self.image, self.position.x, self.position.y)
end

function BearSpeech:update(dt)
	if love.keyboard.isDown("a") then
		self.position.x = self.position.x - (self.speed * dt)
	end

	if love.keyboard.isDown("d") then
		self.position.x = self.position.x + (self.speed * dt)
	end

	if love.keyboard.isDown("w") then
		self.position.y = self.position.y - (self.speed * dt)
	end

	if love.keyboard.isDown("s") then
		self.position.y = self.position.y + (self.speed * dt)
	end
end

return BearSpeech