function love.load()
playerhealth = 100
playerx = 400
playery = 300
screenwidth = love.graphics.getWidth()
screenheight = love.graphics.getHeight()

-- Load 2 animation frame
playerframes = {
	love.graphics.newImage("shade.png"),
	love.graphics.newImage("shade2.png"),
}

currentframe = 1
animationtimer = 0
framespeed = 0.2

grasstile = love.graphics.newImage("grasstl.png")
tilesize = 32
playerscale = 2

foresttile = love.graphics.newImage("foresttl.png")

playerwidth = playerframes[1]:getWidth() * playerscale
playerheight = playerframes[1]:getHeight() * playerscale

currentmap = "plain"
-- camera variable
camX = 0
camY = 0

weaponimage = love.graphics.newImage("woodsword.png")
weaponwidth = weaponimage:getWidth()
weaponheight = weaponimage:getHeight()
```

end

function love.draw()
– Draw the background
local currenttile = grasstile – default

```
if currentmap == "forest" then
	currenttile = foresttile
end

for y = 0, love.graphics.getHeight(), tilesize do
	for x = 0, love.graphics.getWidth(), tilesize do
		love.graphics.draw(currenttile, x, y)
	end
end

love.graphics.draw(playerframes[currentframe], playerx, playery, 0, 2, 2)
love.graphics.draw(weaponimage, weaponx, weapony, 0, 1.5, 1.5)
love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
```

end

function love.update(dt)
local ismoving = false

```
-- Movement
if love.keyboard.isDown("right") then
	playerx = playerx + 350 * dt
	ismoving = true
end
if love.keyboard.isDown("left") then
	playerx = playerx - 350 * dt
	ismoving = true
end
if love.keyboard.isDown("down") then
	playery = playery + 350 * dt
	ismoving = true
end
if love.keyboard.isDown("up") then
	playery = playery - 350 * dt
	ismoving = true
end

if ismoving then
	animationtimer = animationtimer + dt
	if animationtimer >= framespeed then
		animationtimer = 0
		currentframe = currentframe + 1
		-- frame
		if currentframe > #playerframes then
			currentframe = 1
		end
	end
else
	currentframe = 1
	animationtimer = 0
end

-- Weapon position (always updates)
weaponx = playerx + 28
weapony = playery + 18

-- Map-specific clamping and transitions
if currentmap == "plain" then
	-- Plain map: clamp left edge, allow right edge for transition
	if playerx < 0 then
		playerx = 0
	end
	-- Transition to forest when reaching right edge
	if playerx > screenwidth - playerwidth then
		currentmap = "forest"
		playerx = 0
	end
elseif currentmap == "forest" then
	-- Forest map: clamp right edge, allow left edge for transition
	if playerx > screenwidth - playerwidth then
		playerx = screenwidth - playerwidth
	end
	-- Transition back to plain when reaching left edge
	if playerx < 0 then
		currentmap = "plain"
		playerx = screenwidth - playerwidth - 10
	end
end

-- Clamp top and bottom for all maps
if playery < 0 then
	playery = 0
end
if playery > screenheight - playerheight then
	playery = screenheight - playerheight
end
```

end

function love.resize(w, h)
screenwidth = w
screenheight = h
end