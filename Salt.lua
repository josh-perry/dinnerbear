-- Libraries
local class = require("libs/middleclass/middleclass")
local lume = require("libs/lume/lume")
local cron = require("libs/cron/cron")

-- Shorthand
local lg = love.graphics

local Game = require("Game")
local Salt = Game:addState("Salt")

function Salt:initialize()
	self.physicsWorld = love.physics.newWorld(0, 9.81*32, true)

	self.ground = self:createGround(self.physicsWorld)
	self.saltAsker = self:createSaltAsker(self.physicsWorld)
	self.bear = self:createBear()
	self.paw = self:createPaw(self.physicsWorld)

	self.grabbed = true

	self.objects = {
		self:createObject("graphics/plate.png", lg:getWidth() / 2, lg:getHeight() - 100),
		self:createObject("graphics/chicken.png", lg:getWidth() / 2, lg:getHeight() - 200),
		self:createObject("graphics/knife.png", (lg:getWidth() / 2) + 100, lg:getHeight() - 100),
		self:createObject("graphics/fork.png", (lg:getWidth() / 2) - 100, lg:getHeight() - 100),
		self:createObject("graphics/salt.png", 100, 50, true, "salt")
	}

	self:initRandomMovementTimer()

	self.randomMoveDirection = nil

	self.saltTimer = nil
end

function Salt:initRandomMovementTimer()
	self.randomMoveTimer = cron.after(math.random(0.1, 0.3),
		function()
			self.randomMoveDirection = lume.randomchoice({"up", "down", "left", "right"})

			self:initRandomMovementTimer()
		end)
end

function Salt:draw()
	self:drawUi()

	lg.polygon("fill", self.ground.body:getWorldPoints(self.ground.shape:getPoints()))

	for _, o in ipairs(self.objects) do
		local x, y = o.body:getPosition()
		local w = o.image:getWidth()
		local h = o.image:getHeight()

		lg.draw(o.image, x, y, o.body:getAngle(), 1, 1, w / 2, h / 2)
	end

	self:drawPaw()
	self:drawSaltAsker()
	self:drawBearMouth()
	self:drawBear()
end

function Salt:update(dt)
	if self.grabbing then
		self.grabbing.joint:setTarget(self.paw.body:getPosition())
	end

	if self.saltTimer then
		self.saltTimer:update(dt)
	end

	self.randomMoveTimer:update(dt)

	if self.randomMoveDirection then
		self:movePawDirection(self.randomMoveDirection, dt)
	end

	for _, o in ipairs(self.objects) do
		local oX, oY = o.body:getPosition()

		if oY > lg:getHeight() then
			self:resetObject(o)
		end

		if o.important then
			if oY > lg:getHeight() / 2 and oX > (lg:getWidth() / 2) + 200 then
				self:resetObject(o)
			end
		end

		if not self.grabbing then
			if o.name == "salt" then
				if oY < lg:getHeight() / 2 and oX > lg:getWidth() / 2 then
					if not self.saltTimer then
						self.saltTimer = cron.after(5, function() self.win = true end)
					end
				else
					self.saltTimer = nil
				end
			end
		end
	end

	if self.win then
		self:changeState("MainMenu")
		self.win = false
		return
	end

	self.physicsWorld:update(dt)
	self:pawMovement(dt)
end

function Salt:movePawDirection(direction, dt)
	local speed = love.math.random(130, 170)

	if direction == "up" then
		self.paw.position.y = self.paw.position.y - (speed * dt)
	end

	if direction == "down" then
		self.paw.position.y = self.paw.position.y + (speed * dt)
	end

	if direction == "left" then
		self.paw.position.x = self.paw.position.x - (speed * dt)
	end

	if direction == "right" then
		self.paw.position.x = self.paw.position.x + (speed * dt)
	end
end

function Salt:keypressed(key, scancode, isRepeat)
	if key == "space" then
		if not self.grabbing then
			-- self.grabbing = self.salt
			for _, o in ipairs(self.objects) do
				local oX, oY = o.body:getPosition()

				local distance = math.sqrt((oX - self.paw.body:getX()) ^ 2 + (oY - self.paw.body:getY()) ^ 2)

				if distance < 64 then
					self.grabbing = o
					self.grabbing.joint = love.physics.newMouseJoint(self.grabbing.body, self.paw.body:getPosition())
					return
				end
			end
		else
			self.grabbing.joint:destroy()
			self.grabbing = nil
		end
	end
end

function Salt:pawMovement(dt)
	if love.keyboard.isDown("w") then
		self.paw.position.y = self.paw.position.y - (self.paw.speed * dt)
	end

	if love.keyboard.isDown("s") then
		self.paw.position.y = self.paw.position.y + (self.paw.speed * dt)
	end

	if love.keyboard.isDown("a") then
		self.paw.position.x = self.paw.position.x - (self.paw.speed * dt)
	end

	if love.keyboard.isDown("d") then
		self.paw.position.x = self.paw.position.x + (self.paw.speed * dt)

		local xLimit = (lg:getWidth() / 2) + (lg:getWidth() / 4) - self.paw.image:getWidth()
		if self.paw.position.x > xLimit  then
			self.paw.position.x = xLimit
		end
	end

	self.paw.body:setX(self.paw.position.x + 100)
	self.paw.body:setY(self.paw.position.y + 25)
end

function Salt:drawSaltAsker()
	lg.draw(self.saltAsker.image, self.saltAsker.position.x, self.saltAsker.position.y)
end

function Salt:drawPaw()
	if self.grabbed then
		lg.setColor(255, 255, 255)
	else
		lg.setColor(255, 255, 255, 200)
	end

	lg.draw(self.paw.image, self.paw.position.x, self.paw.position.y)
end

function Salt:drawBearMouth()
	lg.setColor(255, 255, 255, 100)
	lg.draw(self.bear.image, self.bear.quads.mouth, self.bear.position.x, self.bear.position.y, self.bear.rotation, -1, 1, self.bear.face.w/2, self.bear.face.h/2)
end

function Salt:drawBear()
	lg.setColor(255, 255, 255, 100)
	lg.draw(self.bear.image, self.bear.quads.face, self.bear.position.x, self.bear.position.y, self.bear.rotation, -1, 1, self.bear.face.w/2, self.bear.face.h/2)
end

function Salt:createSalt(world)
	local y = 0
	local x = 0

	local salt = {}
	salt.image = lg.newImage("graphics/salt.png")

	local w = salt.image:getWidth()
	local h = salt.image:getHeight()

	salt.body = love.physics.newBody(world, x, y, "dynamic")
	salt.body:setAngle(0)
	salt.shape = love.physics.newPolygonShape(-(w/2), -(h/2), -(w/2), h/2, w/2, h/2, w/2, -h/2)
	salt.fixture = love.physics.newFixture(salt.body, salt.shape)

	return salt
end

function Salt:createPaw(world)
	local x = 100
	local y = 100

	local paw = {}
	paw.image = lg.newImage("graphics/glass paw.png")
	paw.position = {
		x = x,
		y = y
	}
	paw.speed = 500

	paw.body = love.physics.newBody(world, x, y)
	paw.shape = love.physics.newCircleShape(0)
	paw.fixture = love.physics.newFixture(paw.body, paw.shape)

	return paw
end

function Salt:createGround(world)
	local tableHeight = 75

	local ground = {}
	ground.body = love.physics.newBody(world, lg:getWidth()/2, lg:getHeight() - tableHeight)
	ground.shape = love.physics.newRectangleShape(lg:getWidth(), tableHeight)
	ground.fixture = love.physics.newFixture(ground.body, ground.shape)

	return ground
end

function Salt:createSaltAsker(world)
	local saltAsker = {}

	local w = 210
	local h = 40

	saltAsker.image = lg.newImage("graphics/salt asker.png")
	saltAsker.position = {
		x = lg:getWidth() - saltAsker.image:getWidth() + (saltAsker.image:getWidth() / 4),
		y = lg:getHeight() - saltAsker.image:getHeight()
	}

	saltAsker.body = love.physics.newBody(world, saltAsker.position.x + 65 + (w/2), saltAsker.position.y + 140 + (h/2))
	saltAsker.shape = love.physics.newRectangleShape(w, h)
	saltAsker.fixture = love.physics.newFixture(saltAsker.body, saltAsker.shape)

	return saltAsker
end

function Salt:createBear()
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

	local xOffset = 30
	local yOffset = 100
	bear.position.x = 0
	bear.position.y = lg:getHeight() - bear.face.h / 2 + yOffset

	return bear
end

function Salt:createObject(image, x, y, important, name)
	local o = {}
	o.originalPosition = {x = x, y = y}
	o.image = lg.newImage(image)

	local w = o.image:getWidth()
	local h = o.image:getHeight()

	o.body = love.physics.newBody(self.physicsWorld, x, y, "dynamic")
	o.shape = love.physics.newRectangleShape(0, 0, w, h)
	o.fixture = love.physics.newFixture(o.body, o.shape)

	-- Should respawn?
	o.important = important or false
	o.name = name or nil

	return o
end

function Salt:resetObject(o)
	o.body:setX(o.originalPosition.x)
	o.body:setY(o.originalPosition.y)
	o.body:setLinearVelocity(0, 0)
end

return Salt