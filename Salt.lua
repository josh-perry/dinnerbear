-- Libraries
local class = require("libs/middleclass/middleclass")

-- Shorthand
local lg = love.graphics

local Game = require("Game")
local Salt = Game:addState("Salt")

function Salt:initialize()
	self.physicsWorld = love.physics.newWorld(0, 9.81*16, true)

	self.salt = self:createSalt(self.physicsWorld)
	self.ground = self:createGround(self.physicsWorld)

	self.paw = lg.newImage("graphics/glass paw.png")
end

function Salt:draw()
	lg.polygon("fill", self.ground.body:getWorldPoints(self.ground.shape:getPoints()))

	self:drawSalt()
	self:drawPaw()
end

function Salt:update(dt)
	self.physicsWorld:update(dt)
end

function Salt:keypressed(key, scancode, isRepeat)
end

function Salt:drawSalt()
	local x, y = self.salt.body:getPosition()
	local w = self.salt.image:getWidth()
	local h = self.salt.image:getHeight()

	lg.draw(self.salt.image, x, y, self.salt.body:getAngle(), 1, 1, w / 2, h / 2)
end

function Salt:drawPaw()
	local x, y = self.salt.body:getPosition()
	local w = self.salt.image:getWidth()
	local h = self.salt.image:getHeight()

	x = x - 80
	y = y + 40

	lg.draw(self.paw, x, y, self.salt.body:getAngle(), 1, 1, w / 2, h / 2)
end

function Salt:createSalt(world)
	local y = lg:getHeight()/2
	local x = lg:getWidth()/2

	local salt = {}
	salt.image = lg.newImage("graphics/salt.png")

	local w = salt.image:getWidth()
	local h = salt.image:getHeight()

	salt.body = love.physics.newBody(self.physicsWorld, x, y, "dynamic")
	salt.body:setAngle(0)
	salt.shape = love.physics.newPolygonShape(-(w/2), -(h/2), -(w/2), h/2, w/2, h/2, w/2, -h/2)
	salt.fixture = love.physics.newFixture(salt.body, salt.shape)

	return salt
end

function Salt:createGround(world)
	local tableHeight = 75

	local ground = {}
	ground.body = love.physics.newBody(world, lg:getWidth()/2, lg:getHeight() - tableHeight)
	ground.shape = love.physics.newRectangleShape(lg:getWidth(), tableHeight)
	ground.fixture = love.physics.newFixture(ground.body, ground.shape)

	return ground
end

return Salt