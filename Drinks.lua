-- Libraries
local class = require("libs/middleclass/middleclass")
local lume = require("libs/lume/lume")
local cron = require("libs/cron/cron")

-- Shorthand
local lg = love.graphics

local Game = require("Game")
local Drinks = Game:addState("Drinks")

function Drinks:initialize()
	love.physics.setMeter(16)

	self.physicsWorld = love.physics.newWorld(0, 9.81*16, true)

	self.waterDroplets = self:createWater(self.physicsWorld)
	self.glass = self:createGlass(self.physicsWorld)
	self.bear = self:createBear()
	self.drinkCollider = {
		x = 485,
		y = 415,
		r = 82
	}

	self.drunk = 0

	self.randomMoveTimer = cron.after(5, function()
			self:initRandomMovementTimer()
			self.allowRotation = true
		end)

	self.randomMoveDirection = nil
	self.allowRotation = false

	self.paw = lg.newImage("graphics/glass paw.png")
end

function Drinks:initRandomMovementTimer()
	self.randomMoveTimer = cron.after(math.random(0.1, 0.6),
		function()
			self.randomMoveDirection = lume.randomchoice({"up", "down", "left", "right"})

			self:initRandomMovementTimer()
		end)
end

function Drinks:draw()
	self:drawUi()

	self:drawBearMouth()
	self:drawWater()
	self:drawGlass()
	self:drawBear()
	self:drawPaw()
end

function Drinks:update(dt)
	self.physicsWorld:update(dt)
	self.randomMoveTimer:update(dt)

	if self.randomMoveDirection then
		self:moveGlassDirection(self.randomMoveDirection, dt)
	end

	local deathZone = lg:getHeight()
	for i, water in ipairs(self.waterDroplets) do
		if water.body:getY() > deathZone then
			self.suspicion = self.suspicion + 1
			table.remove(self.waterDroplets, i)
		end

		local x = water.body:getX()
		local y = water.body:getY()
		local distance = math.sqrt((x - self.drinkCollider.x) ^ 2 + (y - self.drinkCollider.y) ^ 2)

		if distance < self.drinkCollider.r then
			self.drunk = self.drunk + 1
			table.remove(self.waterDroplets, i)
		end
	end

	self:moveGlass(dt)

	if self.suspicion >= 100 then
		self:changeState("GameOver")
		return
	elseif table.getn(self.waterDroplets) <= 0 then
		-- Go to the next level
		self:changeState("Salt")
		return
	end
end

function Drinks:keypressed(key, scancode, isRepeat)
end

function Drinks:moveGlass(dt)
	if not self.allowRotation then return end

	local rotateSpeed = 1
	local shakyness = 0.3
	local left = self.glass.left
	local right = self.glass.right
	local bottom = self.glass.bottom

	if love.keyboard.isDown("q") then
		left.body:setAngle(left.body:getAngle() - (rotateSpeed * dt))
		right.body:setAngle(right.body:getAngle() - (rotateSpeed * dt))
		bottom.body:setAngle(bottom.body:getAngle() - (rotateSpeed * dt))

		shakyness = shakyness * 12
	elseif love.keyboard.isDown("e") then
		left.body:setAngle(left.body:getAngle() + (rotateSpeed * dt))
		right.body:setAngle(right.body:getAngle() + (rotateSpeed * dt))
		bottom.body:setAngle(bottom.body:getAngle() + (rotateSpeed * dt))

		shakyness = shakyness * 12
	end

	-- Random shakes
	local shake = love.math.random(-shakyness, shakyness)
	left.body:setAngle(left.body:getAngle() + shake * dt)
	right.body:setAngle(right.body:getAngle() + shake * dt)
	bottom.body:setAngle(bottom.body:getAngle() + shake * dt)
end

function Drinks:moveGlassDirection(direction, dt)
	local speed = love.math.random(30, 70)
	local left = self.glass.left
	local right = self.glass.right
	local bottom = self.glass.bottom

	if direction == "left" then
		left.body:setX(left.body:getX() - (speed * dt))
		right.body:setX(right.body:getX() - (speed * dt))
		bottom.body:setX(bottom.body:getX() - (speed * dt))
	end

	if direction == "right" then
		left.body:setX(left.body:getX() + (speed * dt))
		right.body:setX(right.body:getX() + (speed * dt))
		bottom.body:setX(bottom.body:getX() + (speed * dt))
	end

	if direction == "up" then
		left.body:setY(left.body:getY() - (speed * dt))
		right.body:setY(right.body:getY() - (speed * dt))
		bottom.body:setY(bottom.body:getY() - (speed * dt))
	end

	if direction == "down" then
		left.body:setY(left.body:getY() + (speed * dt))
		right.body:setY(right.body:getY() + (speed * dt))
		bottom.body:setY(bottom.body:getY() + (speed * dt))
	end
end

function Drinks:drawWater()
	lg.setColor(100, 255, 255)
	for _, water in ipairs(self.waterDroplets) do
		lg.circle("fill", water.body:getX(), water.body:getY(), water.shape:getRadius())
	end
end

function Drinks:drawGlass()
	love.graphics.setColor(170, 170, 210)

	lg.polygon("fill", self.glass.left.body:getWorldPoints(self.glass.left.shape:getPoints()))
	lg.polygon("fill", self.glass.right.body:getWorldPoints(self.glass.right.shape:getPoints()))
	lg.polygon("fill", self.glass.bottom.body:getWorldPoints(self.glass.bottom.shape:getPoints()))
end

function Drinks:drawPaw()
	if not self.allowRotation then return end

	local x, y = self.glass.bottom.body:getWorldPoints(self.glass.bottom.shape:getPoints())

	x = x - 150
	y = y - 100

	lg.setColor(255, 255, 255, 200)
	lg.draw(self.paw, x, y)
end

function Drinks:drawBearMouth()
	lg.draw(self.bear.image, self.bear.quads.mouth, self.bear.position.x, self.bear.position.y, self.bear.rotation, 1, 1, self.bear.face.w/2, self.bear.face.h/2)
end

function Drinks:drawBear()
	lg.draw(self.bear.image, self.bear.quads.face, self.bear.position.x, self.bear.position.y, self.bear.rotation, 1, 1, self.bear.face.w/2, self.bear.face.h/2)
end

function Drinks:createGlass(world)
	local top = 60
	local bottom = 30
	local rim = 16
	local height = 180
	local y = lg:getHeight()/2 - 150
	local x = lg:getWidth()/2 - 100

	local glass = {}

	glass.left = {}
	glass.left.body = love.physics.newBody(world, x, y)
	glass.left.shape = love.physics.newPolygonShape(-top - rim, 0, -top, 0, -bottom, height, -bottom - rim, height)
	glass.left.fixture = love.physics.newFixture(glass.left.body, glass.left.shape)

	glass.right = {}
	glass.right.body = love.physics.newBody(world, x, y)
	glass.right.shape = love.physics.newPolygonShape(top + rim, 0, top, 0, bottom, height, bottom + rim, height)
	glass.right.fixture = love.physics.newFixture(glass.right.body, glass.right.shape)

	glass.bottom = {}
	glass.bottom.body = love.physics.newBody(world, x, y)
	glass.bottom.shape = love.physics.newPolygonShape(-bottom - rim, height, -bottom - rim, height - rim, bottom+rim, height-rim, bottom+rim, height)
	glass.bottom.fixture = love.physics.newFixture(glass.bottom.body, glass.bottom.shape)

	return glass
end

function Drinks:createWater(world)
	local waterDroplets = {}
	local x = (lg:getWidth() / 2) - 100
	local y = lg:getHeight() / 2

	for i = 1, 200 do
		local water = {}
		water.body = love.physics.newBody(self.physicsWorld, x + love.math.random(-10, 10), y - (i * 12), "dynamic")
		water.shape = love.physics.newCircleShape(4)
		water.fixture = love.physics.newFixture(water.body, water.shape, 1)

		table.insert(waterDroplets, water)
	end

	return waterDroplets
end

function Drinks:createBear()
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
	bear.rotation = 1.5
	bear.position = {}

	local xOffset = 30
	local yOffset = 100
	bear.position.x = lg:getWidth() - bear.face.w / 2 + xOffset
	bear.position.y = lg:getHeight() - bear.face.h / 2 + yOffset

	return bear
end

return Drinks