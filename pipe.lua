Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('assets/sprites/pipe.png')
local PIPE_SCROLL = -60

function Pipe:init()
    self.image = PIPE_IMAGE
    self.x = VIRTUAL_WIDTH
    self.y = math.random(VIRTUAL_HEIGHT/4, VIRTUAL_HEIGHT - 30) 
    -- random number upper 1/4 of screen height and ten pixels from the bottom edge of the screen
    -- remember that self.y is the upper left corner of the sprite image

    self.width = PIPE_IMAGE:getWidth()
end

function Pipe:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Pipe:update(dt)
    self.dx = PIPE_SCROLL
    self.x = self.x + self.dx * dt
end