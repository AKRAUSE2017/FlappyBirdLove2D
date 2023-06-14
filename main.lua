push = require('push')
Class = require('class')

require('bird')
require('pipe')

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage("assets/sprites/background.png")
local backgroundScroll = 0
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOPING_POINT = 413

local ground = love.graphics.newImage("assets/sprites/ground.png")
local groundScroll = 0
local GROUND_SCROLL_SPEED = 60

local bird = Bird()
local pipe = Pipe()

local gameState = 'start'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest') -- no bluriness no interpolation on pixels when scaled
    love.window.setTitle("Flappy Bird")

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {} -- using love SDK to create new key to the keyboard table
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true; -- capture whatever key has been pressed
    if key == 'escape' then
        love.event.quit()
    end
end

-- new/custom function implementation using love SDK
function love.keyboard.wasPressed(key)
    -- return value stored in our custom table for a given key
    if love.keyboard.keysPressed[key] then 
        return true -- would be true if love.keypressed triggered it
    else
        return false
    end
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()
    pipe:render()

    push:finish()
end

function love.update(dt)
    -- PARALLAX SCROLLING: illusion of movement given two frames of reference that are moving at different rates
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT -- once we hit the looping point we will reset the image back to 0
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH  -- once we hit the looping point we will reset the image back to 0

    pipe:update(dt)
    -- querying the wasPressed table to see if a new input was detected
    -- this avoids a list of querying in the key pressed event for love
    bird:update(dt)
    love.keyboard.keysPressed = {} -- flushing the table i.e. removing all the set true values
end