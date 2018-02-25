-- Libraries
local class = require("libs/middleclass/middleclass")
local stateful = require("libs/stateful/stateful")
local cron = require("libs/cron/cron")

-- Shorthand
local lg = love.graphics

local Talker = class("Talker")

function Talker:initialize(word)
	self.image = lg.newImage("graphics/speech.png")
	self.subImage = lg.newImage("graphics/heart.png")
	self.doneImage = lg.newImage("graphics/done.png")
	self.suspiciousImage = lg.newImage("graphics/suspicious.png")

	self.position = {x = love.math.random(0, lg:getWidth() - self.image:getHeight()), y = love.math.random(0, lg:getHeight() - self.image:getHeight())}

	self.done = false
	self.doneTimer = cron.after(love.math.random(2, 8),
		function()
			self.done = true
			self.suspiciousTimer = cron.after(3,
				function()
					self.suspicious = true

					self.suspiciousTimer = cron.after(1,
						function()
							self.destroyed = true 
						end)
				end)
		end)

	self.suspicious = false
	self.suspiciousTimer = nil
	self.destroyed = false

	self.word = word
end

function Talker:draw()
	lg.setColor(255, 255, 255)
	lg.draw(self.image, self.position.x, self.position.y)

	if self.suspicious then
		lg.draw(self.suspiciousImage, self.position.x, self.position.y)
	elseif not self.done then
		lg.draw(self.subImage, self.position.x, self.position.y)
	else
		lg.draw(self.doneImage, self.position.x, self.position.y)
	end

	local wordX, wordY = self.position.x, self.position.y + self.image:getHeight() / 2

	lg.setColor(255, 255, 255)
	lg.setFont(self.typingFont)
	lg.print(self.word, wordX, wordY)

	if self.typedCharacters then
		local typedWord = string.sub(self.word, 1, self.typedCharacters)
		lg.setColor(100, 100, 0)
		lg.print(typedWord, wordX, wordY)
		lg.setColor(255, 255, 255)
	end
end

function Talker:update(dt)
	self.doneTimer:update(dt)

	if self.suspiciousTimer then self.suspiciousTimer:update(dt) end
end

return Talker