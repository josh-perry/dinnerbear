-- Libraries
local class = require("libs/middleclass/middleclass")
local stateful = require("libs/stateful/stateful")
local cron = require("libs/cron/cron")

-- Shorthand
local lg = love.graphics

local Talker = class("Talker")

function Talker:initialize()
	self.image = lg.newImage("graphics/speech.png")
	self.subImage = lg.newImage("graphics/heart.png")
	self.doneImage = lg.newImage("graphics/done.png")
	self.suspiciousImage = lg.newImage("graphics/suspicious.png")

	if love.math.random(0, 1) == 1 then
		-- Left side
		self.position = {x = 0, y = love.math.random(0, lg:getHeight() - self.image:getHeight())}
	else
		-- Right side
		self.position = {x = lg:getWidth() - self.image:getWidth(), y = love.math.random(0, lg:getHeight() - self.image:getHeight())}
	end

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
end

function Talker:draw()
	lg.draw(self.image, self.position.x, self.position.y)

	if self.suspicious then
		lg.draw(self.suspiciousImage, self.position.x, self.position.y)
	elseif not self.done then
		lg.draw(self.subImage, self.position.x, self.position.y)
	else
		lg.draw(self.doneImage, self.position.x, self.position.y)
	end
end

function Talker:update(dt)
	self.doneTimer:update(dt)

	if self.suspiciousTimer then self.suspiciousTimer:update(dt) end
end

return Talker