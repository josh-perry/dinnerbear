-- Libraries
local class = require("libs/middleclass/middleclass")

-- Shorthand
local lg = love.graphics

local Game = require("Game")
local SmallTalk = Game:addState("SmallTalk")

function SmallTalk:initialize()
	self.bear = self:createBear()
end

function SmallTalk:draw()
	self:drawBear()
end

function SmallTalk:drawBear()
	lg.setColor(255, 255, 255, 255)
	lg.draw(self.bear.image, self.bear.quads.mouth, self.bear.position.x, self.bear.position.y, self.bear.rotation, -0.5, 0.5, self.bear.face.w/2, self.bear.face.h/2)
	lg.draw(self.bear.image, self.bear.quads.face, self.bear.position.x, self.bear.position.y, self.bear.rotation, -0.5, 0.5, self.bear.face.w/2, self.bear.face.h/2)
end

function SmallTalk:update(dt)
end

function SmallTalk:keypressed(key, scancode, isRepeat)
	if key == "space" then
	end
end

function SmallTalk:createBear()
	local bearImage = lg.newImage("graphics/drinking_bear.png")
	local bearW = bearImage:getWidth()
	local bearH = bearImage:getHeight()

	local bear = {}
	bear.image = bearImage
	bear.face = {
		x = 480,
		y = 0,
		w = 480,
		h = 480
	}
	bear.mouth = {
		x = 0,
		y = 0,
		w = 480,
		h = 480
	}
	bear.quads = {
		face = lg.newQuad(bear.face.x, bear.face.y, bear.face.w, bear.face.h, bearW, bearH),
		mouth = lg.newQuad(bear.mouth.x, bear.mouth.y, bear.mouth.w, bear.mouth.h, bearW, bearH)
	}
	bear.rotation = -0.8
	bear.position = {}

	bear.position.x = (lg:getWidth() / 2)
	bear.position.y = (lg:getHeight() / 2)

	return bear
end

return SmallTalk