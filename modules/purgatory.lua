local purgatory = {}

local MAX_X = 1500
local MAX_Y = 700

function purgatory:createBread(x, y)
    local bread = {}
    bread.x = x
    bread.y = y
    bread.collected = false

    return bread
end

function purgatory:createPlatform(world, x, y, w, h)
    local platform = {}
    platform.body = love.physics.newBody(world, x + w/2, y + h/2, "static")
    platform.shape = love.physics.newRectangleShape(w, h)
    platform.fixture = love.physics.newFixture(platform.body, platform.shape)
    platform.fixture:setRestitution(0)

    platform.pos = Vector2.new(x, y)
    platform.size = Vector2.new(w, h)

    platform.canLava = true
    platform.lava = 0

    return platform
end

function purgatory:generate(world, root)
    local xdir = love.math.random(1,2)
    if xdir == 2 then xdir = -1 end

    local ydir = love.math.random(1,2)
    if ydir == 2 then ydir = -1 end

    local platform = self:createPlatform(world, 
        root.pos.x + root.size.x * xdir + love.math.random(50, 100) * xdir, 
        root.pos.y + root.size.y * ydir + love.math.random(50, 100) * ydir, 
        root.size.x, root.size.y
    )
    return platform
end

function purgatory:start(world)
    if self.platforms ~= nil then
        for _, platform in ipairs(self.platforms) do
            platform.fixture:destroy()
        end
    end
    

    self.platforms = {}
    self.bread = {}

    local rootPlatform = self:createPlatform(world, -200, 200, 400, 150)

    table.insert(self.platforms, self:createPlatform(world, -MAX_X - 10000, -MAX_Y - 1000, MAX_X * 5 + 20000, 1000)) -- roof
    table.insert(self.platforms, self:createPlatform(world, -MAX_X - 10000, MAX_Y, MAX_X * 5 + 20000, 1000)) -- floor
    table.insert(self.platforms, self:createPlatform(world, -MAX_X - 10000, -MAX_Y, 10000, 10000)) -- left wall
    table.insert(self.platforms, self:createPlatform(world, MAX_X, -MAX_Y, 10000, 10000)) -- right wall

    for _, v in ipairs(self.platforms) do
        v.canLava = false
    end

    table.insert(self.platforms, rootPlatform)

    self.screen = screen:new()
    self.timer = textlabel:new("0", 30, "center", "center")
    self.timer.size = UDim2.new(1,0,0,50)

    self.breadCounter = textlabel:new("0", 20, "left", "center")
    self.breadCounter.position = UDim2.new(0,0,0,50)
    self.breadCounter.size = UDim2.new(0.2,0,0,40)

    self.health = textlabel:new("0", 30, "left", "bottom")
    self.health.anchorpoint = Vector2.new(0,1)
    self.health.position = UDim2.new(0,0,1,0)
    self.health.size = UDim2.new(0.4,0,0,40)

    self.floor = textlabel:new("0", 15, "left", "center")
    self.floor.position = UDim2.new(0,0,0,90)
    self.floor.size = UDim2.new(0.1,0,0,40)


    self.screen:addelements({self.timer, self.breadCounter, self.health, self.floor})
    
    for i = 1, 30 do
        local x, y, w, h
        local isValid = false

        repeat 
            isValid = true
            x = love.math.random(-MAX_X, MAX_X)
            y = love.math.random(-MAX_Y, MAX_Y)
            w = love.math.random(100, 400)
            h = love.math.random(50, 100)

            if love.math.random(1,3) == 1 then
                local oldW = w
                local oldH = h

                w = oldH
                h = oldW
            end

            for _, platform in ipairs(self.platforms) do
                if biribiri.collision(x, y, w, h, platform.pos.x - 25, platform.pos.y - 25, platform.size.x + 50, platform.size.y + 50) then
                    isValid = false
                    break
                end
            end
        until isValid
        
        table.insert(self.platforms, self:createPlatform(world, x, y, w, h))
    end

    for i = 1, 20 do
        local x, y
        local isValid = false

        repeat 
            isValid = true
            x = love.math.random(-MAX_X, MAX_X)
            y = love.math.random(-MAX_Y, MAX_Y)

            for _, platform in ipairs(self.platforms) do
                if biribiri.collision(x, y, 50, 50, platform.pos.x - 25, platform.pos.y - 25, platform.size.x + 50, platform.size.y + 50) then
                    isValid = false
                    break
                end
            end
        until isValid

        table.insert(self.bread, self:createBread(x, y))
    end
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
        if biribiri.collision(player.body:getX() - 35, player.body:getY() - 35, 70, 70, bread.x, bread.y, 50, 50) then
            bread.collected = true
        end
    end
end

function purgatory:draw(cx, cy)
    love.graphics.setBackgroundColor(0,0,0,1)

    for _, platform in ipairs(self.platforms) do
        love.graphics.setColor(1, 1 + -platform.lava, 1 + -platform.lava, 1)
        

        love.graphics.draw(assets["img/platform.png"], platform.pos.x - cx + 25, 
            platform.pos.y - cy + 25, 0,
            platform.size.x / 100, platform.size.y / 100)

        love.graphics.rectangle("line", 
            platform.pos.x - cx + 25, 
            platform.pos.y - cy + 25, 
            platform.size.x, platform.size.y
        )

        love.graphics.setColor(1,1,1,1)
    end

    for _, bread in ipairs(self.bread) do
        if not bread.collected then
            love.graphics.draw(assets["img/meowsynthcat.png"], bread.x - cx + 25, bread.y - cy + 25)
        end
    end
end

return purgatory