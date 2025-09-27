require "biribiri"

local player = {}

function player:Init(world)
    self.body = love.physics.newBody(world, 0, 0, "dynamic")
    self.body:setLinearDamping(2)
    self.shape = love.physics.newRectangleShape(50, 50)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setRestitution(0)

    self.grounded = false
    self.flipped = false
    self.jumpPressed = false

    self.maxHealth = 100
    self.health = self.maxHealth
    
    
    self.speed = 6000
    self.jumpHeight = 3500
    self.dashSpeed = 2000

    self.c = Vector2.new(0,0)
    self.camera = Vector2.new(0, 0)
    self.camoffset = Vector2.new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

    self.dashCooldown = 0
    self.maxDashCooldown = 1

    self.sprite = assets["img/player.png"]
end

local DASH_DIRECTIONS = {
    a = {x = -1, y = 0},
    w = {x = 0, y = -1},
    d = {x = 1, y = 0},
    s = {x = 0, y = 1}
}

function player:Update(dt)
    if #self.body:getContacts() >= 1 then
        self.grounded = true
    else
        self.grounded = false
    end

    if love.keyboard.isDown("a") then
        self.body:applyLinearImpulse(-self.speed * dt, 0)
        self.flipped = false
    end

    if love.keyboard.isDown("d") then
        self.body:applyLinearImpulse(self.speed * dt, 0)
        self.flipped = true
    end

    if love.keyboard.isDown("space") and self.grounded and not self.jumpPressed then
        self.jumpPressed = true
        self.body:applyLinearImpulse(0, -self.jumpHeight)
    end

    if not love.keyboard.isDown("space") then
        self.jumpPressed = false
    end

    if love.keyboard.isDown("lshift") and self.dashCooldown <= 0 then
        local dashDir = {x = 0, y = 0}

        for key, value in pairs(DASH_DIRECTIONS) do
            if love.keyboard.isDown(key) then
                dashDir.x = value.x
                dashDir.y = value.y
            end
        end

        if dashDir.x ~= 0 or dashDir.y ~= 0 then
            self.body:applyLinearImpulse(dashDir.x * self.dashSpeed, dashDir.y * self.dashSpeed * 3)
            self.dashCooldown = self.maxDashCooldown
        end
    end

    self.dashCooldown = self.dashCooldown - dt

    self.camoffset = Vector2.new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    self.c.x = biribiri:lerp(self.c.x, self.body:getX(), 0.1)
    self.c.y = biribiri:lerp(self.c.y, self.body:getY(), 0.1)

    self.camera.x = self.c.x - self.camoffset.x
    self.camera.y = self.c.y - self.camoffset.y
end

function player:reset()
    self.body:setLinearVelocity(0,0)
    self.body:setX(0)
    self.body:setY(0)
    self.health = self.maxHealth
end

function player:Draw()
    love.graphics.draw(self.sprite, self.body:getX() + 25 - self.camera.x, self.body:getY() + 25 - self.camera.y, 0, self.flipped and -1 or 1, 1, 25, 25)
end

return player