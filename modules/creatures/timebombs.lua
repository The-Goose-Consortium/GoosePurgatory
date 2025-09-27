local timebombs = {}

function timebombs:init()
    self.active = false
    self.bombs = {}
    self.timer = 0
    self.activateTime = 3
    self.bombsCreated = false
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
        for _, bomb in ipairs(self.bombs) do
            if biribiri.distance(bomb.x, bomb.y, player.body:getX(), player.body:getY()) < 150 then
                player.health = player.health - 50
            end
        end

        table.clear(self.bombs)
        self.bombs = {}
        self.timer = 0
        self.activateTime = love.math.random(8, 14)
        self.bombsCreated = false
    end
end

function timebombs:reset()
    table.clear(self.bombs)
    self.timer = 0
    self.activateTime = 10
end

function timebombs:draw(cx, cy)
    for _, bomb in ipairs(self.bombs) do
        love.graphics.draw(assets["img/timebomb_icon.png"], bomb.x - cx - 5, bomb.y - cy - 5, 0, 1, 1, 10, 10)
        love.graphics.circle("line", bomb.x - cx, bomb.y - cy, 150)
    end
end

return timebombs