-- Libraries
local class = require("libs/middleclass/middleclass")

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
		x = 600,
		y = 500,
		r = 82
	}

	self.drunk = 0
end

function Drinks:draw()
	lg.print("Suspicion: "..self.suspicion.."%", 10, 10)
	lg.print("Drunk water: "..self.drunk, 10, 20)

	-- lg.setColor(255, 255, 100)
	-- lg.circle("fill", self.drinkCollider.x, self.drinkCollider.y, self.drinkCollider.r)

	self:drawBearMouth()
	self:drawWater()
	self:drawGlass()
	self:drawBear()
end

function Drinks:update(dt)
	self.physicsWorld:update(dt)

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

	if self.suspicion >= 100 then
		self:changeState("GameOver")
	end
end

function Drinks:keypressed(key, scancode, isRepeat)
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

function Drinks:drawBearMouth()
	lg.draw(self.bear.image, self.bear.quads.mouth, self.bear.position.x, self.bear.position.y, self.bear.rotation, 1, 1, self.bear.face.w/2, self.bear.face.h/2)

end

function Drinks:drawBear()
	lg.draw(self.bear.image, self.bear.quads.face, self.bear.position.x, self.bear.position.y, self.bear.rotation, 1, 1, self.bear.face.w/2, self.bear.face.h/2)
end

function Drinks:createGlass(world)
	local top = 60
	local bottom = 30
	local rim = 10
	local height = 180
	local y = lg:getHeight()/2 - 150
	local x = lg:getWidth()/2

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

	for i = 1, 2000 do
		local water = {}
		water.body = love.physics.newBody(self.physicsWorld, (lg:getWidth() / 2) + love.math.random(-10, 10), lg:getHeight() / 2 - (i * 12), "dynamic")
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