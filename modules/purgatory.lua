local purgatory = {}

function purgatory:createBread(x, y)
    local bread = {}
    bread.x = x
    bread.y = y
    bread.collected = false

    return bread
end


function purgatory:createPlatform(world, x, y, w, h)
    local platform = {}
    platform.body = love.physics.newBody(world, x, y, "static")
    platform.shape = love.physics.newRectangleShape(w, h)
    platform.fixture = love.physics.newFixture(platform.body, platform.shape)
    platform.fixture:setRestitution(0)

    platform.pos = Vector2.new(x,y)
    platform.size = Vector2.new(w,h)

    return platform
end

function purgatory:start(world)
    self.platforms = {}
    self.bread = {}

    table.insert(self.platforms, self:createPlatform(world, 0, 500, 1000, 100))
    table.insert(self.platforms, self:createPlatform(world, 1000, -500, 1000, 5000))

    table.insert(self.bread, self:createBread(200, 400))
end

function purgatory:getRemainingBread()
    local remaining = 0

    for _, bread in ipairs(self.bread) do
        if not bread.collected then remaining = remaining + 1 end
    end

    return remaining
end

function purgatory:update(dt, player)
    for _, bread in ipairs(self.bread) do
        if biribiri.collision(player.body:getX() - 25, player.body:getY() - 25, 50, 50, bread.x, bread.y, 50, 50) then
            bread.collected = true
        end
    end
end

function purgatory:draw(cx, cy)
    for _, platform in ipairs(self.platforms) do
        love.graphics.rectangle("fill", 
            platform.pos.x - cx - platform.size.x / 2 + 25, 
            platform.pos.y - cy - platform.size.y / 2 + 25, 
            platform.size.x, platform.size.y
        )
    end

    for _, bread in ipairs(self.bread) do
        if not bread.collected then
            love.graphics.draw(assets["img/meowsynthcat.png"], bread.x - cx + 25, bread.y - cy + 25)
        end
    end
end

return purgatory