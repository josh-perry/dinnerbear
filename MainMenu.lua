-- Libraries
local class = require("libs/middleclass/middleclass")

-- Shorthand
local lg = love.graphics

local Game = require("Game")
local MainMenu = Game:addState("MainMenu")

function MainMenu:initialize()
	local image = lg.newImage("graphics/menu_bear.png")
	local w, h = image:getWidth(), image:getHeight()

	self.suspicion = 0

	self.bear = {}
	self.bear.image = image
	self.bear.quads = {
		body = lg.newQuad(0, 0, 350, 480, w, h),
		rightArm = lg.newQuad(400, 60, 135, 205, w, h),
		leftArm = lg.newQuad(391, 348, 150, 125, w, h)
	}
end

function MainMenu:drawBear(x, y)
	local r = self.armRotation

	lg.draw(self.bear.image, self.bear.quads.leftArm, x + 10, y + 90)
	lg.draw(self.bear.image, self.bear.quads.body, x, y)
	lg.draw(self.bear.image, self.bear.quads.rightArm, x + 135, y + 100)
end

function MainMenu:draw()
	self:drawBear(lg:getWidth() - 300, lg:getHeight() - 480 - 50)
	lg.printf("DINNERBEAR", 0, lg:getHeight() / 2, lg:getWidth(), "center")
end

function MainMenu:update(dt)
end

function MainMenu:keypressed(key, scancode, isRepeat)
	if key == "space" then
		self.music:play()
		self:changeState("SmallTalk")
	end
end

return MainMenu