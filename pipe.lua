Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('assets/sprites/pipe.png')
local PIPE_SCROLL = -60

function Pipe:init()
    self.image = PIPE_IMAGE
    self.x = VIRTUAL_WIDTH
    self.y = math.random(VIRTUAL_HEIGHT/4, VIRTUAL_HEIGHT - 10)
end

function Pipe:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Pipe:update(dt)
    self.dx = PIPE_SCROLL
    self.x = self.x + self.dx * dt
end