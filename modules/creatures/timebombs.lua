local timebombs = {}

function timebombs:init()
    self.active = false
    self.bombs = {}
    self.timer = 0
    self.activateTime = 3
    self.bombsCreated = false
    self.radius = 150

    self.spritesheet = assets["img/explosion.png"]
    self.quads = {}

    local w, h = 65, 64

    for y = 0, self.spritesheet:getHeight() - h, h do
        for x = 0, self.spritesheet:getWidth(), w do
            table.insert(self.quads, love.graphics.newQuad(x, y, w, h, self.spritesheet:getDimensions()))
        end
    end

    self.frame = 1
    self.frameTimer = 0
    self.exploding = false
end

function timebombs:update(dt, player, purgatory)
    if not self.active then return end

    self.timer = self.timer + dt

    if self.timer >= self.activateTime and not self.bombsCreated then
        self.bombsCreated = true

        for i = 1, 15 do
            local platform = purgatory.platforms[i]

            local bomb = {
                x = platform.pos.x + platform.size.x / 2,
                y = platform.pos.y - 30
            }

            table.insert(self.bombs, bomb)
        end
    end

    if self.timer >= self.activateTime + 3 then
        self.exploding = true
        for _, bomb in ipairs(self.bombs) do
            if biribiri.distance(bomb.x, bomb.y, player.body:getX(), player.body:getY()) < self.radius then
                player.health = player.health - 50
            end
        end

        
        self.timer = 0
        self.activateTime = love.math.random(8, 14)
        self.bombsCreated = false
    end

    if self.exploding then
        self.frameTimer = self.frameTimer + dt

        if self.frameTimer >= 0.04 then
            self.frame = self.frame + 1
            self.frameTimer = 0

            if self.frame == 17 then
                self.exploding = false
                self.frame = 1
                
                table.clear(self.bombs)
                self.bombs = {}
            end
        end
    end
end

function timebombs:reset()
    table.clear(self.bombs)
    self.timer = 0
    self.activateTime = 10
end

function timebombs:draw(cx, cy)
    for _, bomb in ipairs(self.bombs) do
        if self.exploding then
            love.graphics.draw(self.spritesheet, self.quads[self.frame], 
            bomb.x - cx - (32 * self.radius / 30), 
            bomb.y - cy - (32 * self.radius / 30), 
            0,
            self.radius / 30, self.radius / 30)
        else
            love.graphics.draw(assets["img/timebomb_icon.png"], bomb.x - cx - 25, bomb.y - cy - 25, 0, 1, 1)
            love.graphics.circle("line", bomb.x - cx, bomb.y - cy, self.radius)
        end 
    end
end

return timebombs