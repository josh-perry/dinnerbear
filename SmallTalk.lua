-- Libraries
local class = require("libs/middleclass/middleclass")
local cron = require("libs/cron/cron")
local lume = require("libs/lume/lume")

local CheckCollision = require("CheckCollision")

-- Shorthand
local lg = love.graphics

local Game = require("Game")
local SmallTalk = Game:addState("SmallTalk")

local Talker = require("Talker")
-- local BearSpeech = require("BearSpeech")

function SmallTalk:initialize()
	self.bear = self:createBear()

	self.totalTalkers = 0
	self.talkers = {}

	self:initializeTalkerTimer()

	self.words = {}

	for s in string.gmatch(love.filesystem.read("1-1000.txt"), "[^\r\n]+") do
		table.insert(self.words, s)
	end

	self.totalTalkers = self.totalTalkers + 1
	table.insert(self.talkers, Talker:new(lume.randomchoice(self.words)))
end

function SmallTalk:initializeTalkerTimer()
	self.newTalkerTimer = cron.after(love.math.random(0.2, 2),
		function()
			self.totalTalkers = self.totalTalkers + 1
			table.insert(self.talkers, Talker:new(lume.randomchoice(self.words)))

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

	-- self.bearSpeech:draw()

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
	-- self.bearSpeech:update(dt)

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
	if self.currentTalker == nil then
		for _, talker in ipairs(self.talkers) do
			if string.sub(talker.word, 1, 1) == key then
				talker.typedCharacters = 1
				self.currentTalker = talker
			end
		end

		return
	end

	if string.sub(self.currentTalker.word, self.currentTalker.typedCharacters + 1, self.currentTalker.typedCharacters + 1) == key then
		self.currentTalker.typedCharacters = self.currentTalker.typedCharacters + 1

		if self.currentTalker.typedCharacters == string.len(self.currentTalker.word) then
			self.currentTalker.destroyed = true
			self.currentTalker = nil
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