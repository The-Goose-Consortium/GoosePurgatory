local halt = {}

function halt:init()
    self.active = false
    self.visible = false
    self.timer = 0
    self.activateTime = 5
    self.sprite = assets["img/halt.png"]

    self.x = 0
    self.y = 0
    self.pressingTime = 0.0
end

function halt:update(dt, player)
    if not self.active then return end

    self.timer = self.timer + dt

    if self.timer >= self.activateTime then
        if not self.visible then
            self.x = love.math.random(10, love.graphics.getWidth() - love.graphics.getWidth() / 700 - 10)
            self.y = love.math.random(10, love.graphics.getHeight() - love.graphics.getWidth() / 700 - 10)
        end

        self.visible = true
        
        if love.keyboard.isDown("a") or love.keyboard.isDown("d") or love.keyboard.isDown("space") then
            self.pressingTime = self.pressingTime + dt
        end

        if self.pressingTime >= 0.5 then
            player.health = player.health - 50
            self.timer = 10000
        end

        if self.timer >= self.activateTime + 2 then
            self.visible = false
            self.timer = 0
            self.activateTime = love.math.random(12,20)
        end
    end
end

function halt:reset()
    self.timer = 0
    self.visible = false
    self.activateTime = 15
end

function halt:draw()
    if self.visible then
        love.graphics.draw(self.sprite, self.x, self.y, 0, love.graphics.getWidth() / 700, love.graphics.getWidth() / 700)
    end
end

return halt