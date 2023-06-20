Bird = Class{}

local GRAVITY = 15

function Bird:init()
    self.image = love.graphics.newImage('assets/sprites/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = (VIRTUAL_WIDTH / 2) - (self.width / 2)
    self.y = (VIRTUAL_HEIGHT / 2) - (self.height / 2)

    self.dy = 0
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt -- incrementally increases dy to fall faster over time
    -- gravity * dt evaluates to a small fractional number when fps is high

    if love.keyboard.wasPressed("space") then
        self.dy = -3 -- set velocity to be negative (it will stay negative for the next few subsequent frames) 
        -- until gravity eventually causes the velocity to be zero and then positive again
    end
    self.y = self.y + self.dy -- update position
end