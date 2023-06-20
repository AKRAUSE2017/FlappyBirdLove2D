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
local pipes = {}

local spawnTimer = 0

local gameState = 'start'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest') -- no bluriness no interpolation on pixels when scaled
    love.window.setTitle("Flappy Bird")
    smallFont = love.graphics.newFont('assets/font.ttf', 10)

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

    bird:render()

    for key, pipe in pairs(pipes) do -- iterate through each pipe in the pipes table
        pipe:render() -- update the position
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    displayFPS()
    push:finish()
end

function love.update(dt)
    -- PARALLAX SCROLLING: illusion of movement given two frames of reference that are moving at different rates
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT -- once we hit the looping point we will reset the image back to 0
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH  -- once we hit the looping point we will reset the image back to 0

    spawnTimer = spawnTimer + dt
    if spawnTimer > 2 then
        table.insert(pipes, Pipe()) -- each index will be a new pipe object
        spawnTimer = 0
    end

    for key, pipe in pairs(pipes) do -- iterate through each pipe in the pipes table
        pipe:update(dt) -- update the position

        if pipe.x < 0 - pipe.width then -- if the pipe is past the left edge of the screen
            table.remove(pipes, key) -- remove the pipe from the table
        end
    end
    
    -- querying the wasPressed table to see if a new input was detected
    -- this avoids a list of querying in the key pressed event for love
    bird:update(dt)
    love.keyboard.keysPressed = {} -- flushing the table i.e. removing all the set true values
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10) -- concat in lua is '..'
end