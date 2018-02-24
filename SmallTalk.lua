-- Libraries
local class = require("libs/middleclass/middleclass")
local cron = require("libs/cron/cron")

local CheckCollision = require("CheckCollision")

-- Shorthand
local lg = love.graphics

local Game = require("Game")
local SmallTalk = Game:addState("SmallTalk")

local Talker = require("Talker")
local BearSpeech = require("BearSpeech")

function SmallTalk:initialize()
	self.bear = self:createBear()

	self.totalTalkers = 0
	self.talkers = {}

	self:initializeTalkerTimer()

	self.bearSpeech = BearSpeech:new()
end

function SmallTalk:initializeTalkerTimer()
	self.newTalkerTimer = cron.after(love.math.random(2, 5),
		function()
			self.totalTalkers = self.totalTalkers + 1
			table.insert(self.talkers, Talker:new())

			if self.totalTalkers < 10 then
				self:initializeTalkerTimer()
			end
		end)
end

function SmallTalk:draw()
	self:drawBear()

	for _, talker in ipairs(self.talkers) do
		talker:draw()
	end

	self.bearSpeech:draw()

	self:drawUi()
end

function SmallTalk:drawBear()
	lg.setColor(255, 255, 255, 255)
	lg.draw(self.bear.image, self.bear.quads.mouth, self.bear.position.x, self.bear.position.y, self.bear.rotation, -0.5, 0.5, self.bear.face.w/2, self.bear.face.h/2)
	lg.draw(self.bear.image, self.bear.quads.face, self.bear.position.x, self.bear.position.y, self.bear.rotation, -0.5, 0.5, self.bear.face.w/2, self.bear.face.h/2)
end

function SmallTalk:update(dt)
	if self.totalTalkers == 10 and table.getn(self.talkers) == 0 then
		print("YOU DID IT")
		self:changeState("MainMenu")
	end

	self.newTalkerTimer:update(dt)
	self.bearSpeech:update(dt)

	for i, talker in ipairs(self.talkers) do
		talker:update(dt)

		if talker.destroyed then
			if talker.suspicious then
				self.suspicion = self.suspicion + 5
			end

			table.remove(self.talkers, i)
		end
	end

	if self.suspicion >= 100 then
		self:changeState("GameOver")
		return
	end
end

function SmallTalk:keypressed(key, scancode, isRepeat)
	if key == "space" then
		local safe = false

		for _, talker in ipairs(self.talkers) do
			local x1, y1 = self.bearSpeech.position.x, self.bearSpeech.position.y
			local w1, h1 = self.bearSpeech.image:getWidth(), self.bearSpeech.image:getHeight()

			local x2, y2 = talker.position.x, talker.position.y
			local w2, h2 = talker.image:getWidth(), talker.image:getHeight()

			if CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2) then
				if talker.done then
					safe = true
					table.remove(self.talkers, _)
				end
			end
		end

		if not safe then
			self.suspicion = self.suspicion + 10
		end
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