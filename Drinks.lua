-- Libraries
local class = require("libs/middleclass/middleclass")

-- Shorthand
local lg = love.graphics

local Game = require("Game")
local Drinks = Game:addState("Drinks")

function Drinks:initialize()
	love.physics.setMeter(16)

	self.physicsWorld = love.physics.newWorld(0, 9.81*16, true)

	self.waterDroplets = {}

	self.glass = {}

	local top = 60
	local bottom = 30
	local rim = 10
	local height = 180

	self.glass.left = {}
	self.glass.left.body = love.physics.newBody(self.physicsWorld, lg:getWidth()/2, lg:getHeight()/2)
	self.glass.left.shape = love.physics.newPolygonShape(-top - rim, 0, -top, 0, -bottom, height, -bottom - rim, height)
	self.glass.left.fixture = love.physics.newFixture(self.glass.left.body, self.glass.left.shape)

	self.glass.right = {}
	self.glass.right.body = love.physics.newBody(self.physicsWorld, lg:getWidth()/2, lg:getHeight()/2)
	self.glass.right.shape = love.physics.newPolygonShape(top + rim, 0, top, 0, bottom, height, bottom + rim, height)
	self.glass.right.fixture = love.physics.newFixture(self.glass.right.body, self.glass.right.shape)

	self.glass.bottom = {}
	self.glass.bottom.body = love.physics.newBody(self.physicsWorld, lg:getWidth()/2, lg:getHeight()/2)
	self.glass.bottom.shape = love.physics.newPolygonShape(-bottom - rim, height, -bottom - rim, height - rim, bottom+rim, height-rim, bottom+rim, height)
	self.glass.bottom.fixture = love.physics.newFixture(self.glass.bottom.body, self.glass.bottom.shape)

	for i = 1, 200 do
		local water = {}
		water.body = love.physics.newBody(self.physicsWorld, (lg:getWidth() / 2) + love.math.random(-10, 10), lg:getHeight() / 2 - (i * 12), "dynamic")
		water.shape = love.physics.newCircleShape(4)
		water.fixture = love.physics.newFixture(water.body, water.shape, 1)

		table.insert(self.waterDroplets, water)
	end
end

function Drinks:draw()
	lg.print("Drinking", 10, 10)

	lg.setColor(100, 255, 255)
	for _, water in ipairs(self.waterDroplets) do
		lg.circle("fill", water.body:getX(), water.body:getY(), water.shape:getRadius())
	end

	self:drawGlass()
end

function Drinks:update(dt)
	self.physicsWorld:update(dt)
end

function Drinks:keypressed(key, scancode, isRepeat)
end

function Drinks:drawGlass()
	love.graphics.setColor(170, 170, 210)

	lg.polygon("fill", self.glass.left.body:getWorldPoints(self.glass.left.shape:getPoints()))
	lg.polygon("fill", self.glass.right.body:getWorldPoints(self.glass.right.shape:getPoints()))
	lg.polygon("fill", self.glass.bottom.body:getWorldPoints(self.glass.bottom.shape:getPoints()))
end


return Drinks