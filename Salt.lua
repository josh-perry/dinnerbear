-- Libraries
local class = require("libs/middleclass/middleclass")

-- Shorthand
local lg = love.graphics

local Game = require("Game")
local Salt = Game:addState("Salt")

function Salt:initialize()
	self.physicsWorld = love.physics.newWorld(0, 9.81*32, true)

	self.salt = self:createSalt(self.physicsWorld)
	self.ground = self:createGround(self.physicsWorld)
	self.saltAsker = self:createSaltAsker(self.physicsWorld)

	self.paw = self:createPaw(self.physicsWorld)
	self.grabbed = false

	self.hoveringObject = false
end

function Salt:draw()
	lg.polygon("fill", self.ground.body:getWorldPoints(self.ground.shape:getPoints()))

	self:drawSaltAsker()
	self:drawSalt()
	self:drawPaw()
end

function Salt:update(dt)
	self.physicsWorld:update(dt)
	self:pawMovement(dt)
end

function Salt:keypressed(key, scancode, isRepeat)
	if key == "space" then
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
	end

	self.paw.body:setX(self.paw.position.x + 100)
	self.paw.body:setY(self.paw.position.y + 25)
end

function Salt:drawSalt()
	local x, y = self.salt.body:getPosition()
	local w = self.salt.image:getWidth()
	local h = self.salt.image:getHeight()

	lg.draw(self.salt.image, x, y, self.salt.body:getAngle(), 1, 1, w / 2, h / 2)
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

function Salt:createSalt(world)
	local y = lg:getHeight()/2
	local x = lg:getWidth()/2

	local salt = {}
	salt.image = lg.newImage("graphics/salt.png")

	local w = salt.image:getWidth()
	local h = salt.image:getHeight()

	salt.body = love.physics.newBody(world, x, y, "dynamic")
	salt.body:setAngle(0.4)
	salt.shape = love.physics.newPolygonShape(-(w/2), -(h/2), -(w/2), h/2, w/2, h/2, w/2, -h/2)
	salt.fixture = love.physics.newFixture(salt.body, salt.shape)

	return salt
end

function Salt:createPaw(world)
	local x = lg:getWidth() / 2
	local y = lg:getHeight() / 2

	local paw = {}
	paw.image = lg.newImage("graphics/glass paw.png")
	paw.position = {
		x = x,
		y = y
	}
	paw.speed = 250

	paw.body = love.physics.newBody(world, x, y)
	paw.shape = love.physics.newCircleShape(16)
	paw.fixture = love.physics.newFixture(paw.body, paw.shape)
	paw.joint = nil

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

	saltAsker.body = love.physics.newBody(world, saltAsker.position.x + 65 + (w/2), saltAsker.position.y + 126 + (h/2))
	saltAsker.shape = love.physics.newRectangleShape(w, h)
	saltAsker.fixture = love.physics.newFixture(saltAsker.body, saltAsker.shape)

	return saltAsker
end

return Salt