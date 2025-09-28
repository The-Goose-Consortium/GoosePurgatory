local greygoose = {}

function greygoose:init()
    print("reset")
    self.active = false
    self.sprite = assets["img/enemy.png"]
    self.recordedPositions = {}
    self.time = 0
    self.delay = 2

    self.modX = 0
    self.modY = 0
    self.modR = 0

    self.x = 0
    self.y = 0
    self.flipped = false

    self.stunTime = self.delay
end

function greygoose:update(dt, player)
    if not self.active then return end

    self.modX = self.modX + dt * 50
    self.modY = self.modY + dt * 50
    self.modR = self.modR + dt * 20

    if self.stunTime > 0 then
        self.stunTime = self.stunTime - dt
    end

    self.time = self.time + dt

    table.insert(self.recordedPositions, {
        x = player.body:getX(),
        y = player.body:getY(),
        flipped = player.flipped,
        time = self.time
    })

    for i, v in ipairs(self.recordedPositions) do
        if v.time <= self.time - self.delay then
            self.x = v.x
            self.y = v.y
            self.flipped = v.flipped

            table.remove(self.recordedPositions, i)
        end
    end

    if self.stunTime <= 0 and biribiri.collision(player.body:getX(), player.body:getY(), 50, 50, self.x, self.y, 50, 50) then
        player.health = player.health - 10
        player.body:setLinearVelocity(0,0)

        self.stunTime = self.delay

        table.clear(self.recordedPositions)
    end
end

function greygoose:reset()
    self.x = 0
    self.y = 0
    self.flipped = false
    self.stunTime = self.delay
    table.clear(self.recordedPositions)
    self.recordedPositions = {}
end

function greygoose:draw(cx, cy)
    if self.active == false then return end

    if self.stunTime > 0 then
        love.graphics.setColor(0.5, 0.5, 0.5, 0.9)
    else
        love.graphics.setColor(1,1,1,1)
    end

    love.graphics.draw(self.sprite, 
        self.x - cx + 25 + math.sin(math.cos(self.modX)) * (2 + self.stunTime * 4), 
        self.y - cy + 25 + math.cos(math.sin(self.modY)) * (4 + self.stunTime * 4), 
        (love.math.random() - 0.5) / (5 - self.stunTime), 
    self.flipped and -1 or 1, 1, 25, 25)

    love.graphics.setColor(1,1,1,1)
end

return greygoose