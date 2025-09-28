local halt = {}

function halt:init()
    self.active = false
    self.visible = false
    self.timer = 0
    self.activateTime = 12
    self.sprite = assets["img/halt.png"]

    self.x = 0
    self.y = 0
    self.mod = 0
    self.pressingTime = 0.0

    self.maxActivate = 20
    self.minActivate = 12
end

function halt:update(dt, player)
    if not self.active then return end

    self.timer = self.timer + dt
    self.mod = self.mod + dt * 10

    if self.timer >= self.activateTime then
        if not self.visible then
            assets["audio/halt.wav"]:play()
        end
        self.visible = true
        
        self.x = player.body:getX() + math.sin(self.mod) * self.pressingTime * 60
        self.y = player.body:getY() + math.cos(self.mod) * self.pressingTime * 60

        if love.keyboard.isDown("a") or love.keyboard.isDown("d") or love.keyboard.isDown("space") then
            self.pressingTime = self.pressingTime + dt
        end

        assets["audio/halt.wav"]:setVolume(self.pressingTime)

        if self.pressingTime >= 1 then
            player.health = player.health - 50
            self.timer = 10000
            assets["audio/halt.wav"]:stop()
        end

        if self.timer >= self.activateTime + 3 then
            assets["audio/halt.wav"]:stop()
            self.visible = false
            self.timer = 0
            self.activateTime = love.math.random(self.minActivate, self.maxActivate)
            self.pressingTime = 0
        end
    end
end

function halt:reset()
    self.timer = 0
    self.visible = false
    self.activateTime = self.minActivate
end

function halt:draw(cx, cy)
    if self.visible then
        love.graphics.setColor(1,1,1, math.clamp(self.pressingTime, 0, 1))
        love.graphics.draw(self.sprite, self.x - cx - 25, self.y - cy - 25, 0, 1, 1)
        love.graphics.setColor(1,1,1,1)
    end
end

return halt