---@diagnostic disable: undefined-field
local sacrifice = {}

sacrifice.sacrifices = {
    {
        id = "time",
        text = "lower your time by 20%.",
        run = function (player, game)
            game.maxTime = game.maxTime * 0.8
        end
    },
    {
        id = "speed",
        text = "lower your speed by 10%.",
        run = function (player, game)
            player.speed = player.speed * 0.9
        end
    },
    {
        id = "dash",
        text = "increase your dash cooldown by 20%.",
        run = function (player, game)
            player.maxDashCooldown = player.maxDashCooldown * 1.2
        end
    },
    {
        id = "jumpheight",
        text = "lower your jump height by 10%.",
        run = function (player, game)
            player.jumpHeight = player.jumpHeight * 0.9
        end
    },
    {
        id = "dashspeed",
        text = "lower your dash speed by 10%.",
        run = function (player, game)
            player.dashSpeed = player.dashSpeed * 0.9
        end
    },
    {
        id = "health",
        text = "lower your health by 10%.",
        run = function (player, game)
            player.maxHealth = player.maxHealth * 0.9
        end
    },
    {
        id = "halt",
        text = "summon HALT.",
        run = function (player, game)
            game.creatures.halt.active = true
        end,
        reactivatable = false,
        activated = false
    },
    {
        id = "oftenhalt",
        text = "make HALT appear 10% more often.",
        run = function (player, game)
            game.creatures.halt.minActivate = game.creatures.halt.minActivate * 0.9
            game.creatures.halt.maxActivate = game.creatures.halt.maxActivate * 0.9
        end,
        requires = "halt"
    },
    {
        id = "greygoose",
        text = "summon GREY_GOOSE.",
        run = function (player, game)
            game.creatures.greygoose.active = true
        end,
        reactivatable = false,
        activated = false
    },
    {
        id = "fastergreygoose",
        text = "make GREY_GOOSE 20% faster.",
        run = function (player, game)
            game.creatures.greygoose.delay = game.creatures.greygoose.delay * 0.8
        end,
        requires = "greygoose"
    },

    {
        id = "lava",
        text = "enable LAVA_PLATFORMS.",
        run = function (player, game)
            game.creatures.lava.active = true
        end,
        reactivatable = false,
        activated = false
    },
    {
        id = "fasterlava",
        text = "make LAVA_PLATFORMS scorch 20% faster.",
        run = function (player, game)
            game.creatures.lava.speed = game.creatures.lava.speed * 0.8
        end,
        requires = "lava"
    },
    {
        id = "timebombs",
        text = "enable TIMEBOMBS.",
        run = function (player, game)
            game.creatures.timebombs.active = true
        end,
        reactivatable = false,
        activated = false
    },
    {
        id = "biggertimebombs",
        text = "make TIMEBOMBS explode 20% larger.",
        run = function (player, game)
            game.creatures.timebombs.radius = game.creatures.timebombs.radius * 1.2
        end,
        requires = "timebombs"
    }
}

function sacrifice:start()
    self.screen = screen:new()

    self.modX = 0
    self.modY = 0
    self.modR = 0

    self.selection = -1
    self.selected = false

    local option1
    local option2
    
    local function checkEnabled(id)
        for _, v in ipairs(self.sacrifices) do
            if v.id == id and v.activated == true then
                return true
            end
        end
        return false
    end
    
    local valid1 = false
    local valid2 = false

    repeat
        option1 = love.math.random(1, #self.sacrifices)
        if self.sacrifices[option1].requires == nil then
            valid1 = true
        else
            valid1 = checkEnabled(self.sacrifices[option1].requires)
        end

        print(self.sacrifices[option1].requires)
        print(valid1)
    until self.sacrifices[option1].activated ~= true and valid1
    repeat
        option2 = love.math.random(1, #self.sacrifices)
        if self.sacrifices[option2].requires == nil then
            valid2 = true
        else
            valid2 = checkEnabled(self.sacrifices[option2].requires)
        end

        print(self.sacrifices[option2].requires)
        print(valid2)
    until option2 ~= option1 and self.sacrifices[option2].activated ~= true and valid2

    self.option1Btn = textlabel:new(self.sacrifices[option1].text, 30, "center", "center")
    self.option1Btn.position = UDim2.new(0, 10, 0.5, 0)
    self.option1Btn.size = UDim2.new(0.5, -100, 0.3, 0)
    self.option1Btn.anchorpoint = Vector2.new(0,0.5)
    self.option1Btn.backgroundcolor = Color.new(0,0,0,0)
    self.option1Btn.textcolor = Color.new(1,0,0,1)

    self.option1Btn.mousebutton1up = function ()
        self.selection = option1
        self.selected = true 
    end

    self.option2Btn = textlabel:new(self.sacrifices[option2].text, 30, "center", "center")
    self.option2Btn.position = UDim2.new(1, -10, 0.5, 0)
    self.option2Btn.size = UDim2.new(0.5, -100, 0.3, 0)
    self.option2Btn.anchorpoint = Vector2.new(1,0.5)
    self.option2Btn.backgroundcolor = Color.new(0,0,0,0)
    self.option2Btn.textcolor = Color.new(1,0,0,1)

    self.option2Btn.mousebutton1up = function ()
        self.selection = option2
        self.selected = true
    end

    self.screen:addelements({self.option1Btn, self.option2Btn})
end

function sacrifice:update(dt)
    self.modX = self.modX + dt * 50
    self.modY = self.modY + dt * 50
    self.modR = self.modR + dt * 20

    self.screen:update()
end

function sacrifice:draw()
    love.graphics.setBackgroundColor(0,0,0,1)
    love.graphics.draw(assets["img/player.png"], 
        love.graphics.getWidth() / 2 + math.sin(math.cos(self.modX)) * 5, 
        love.graphics.getHeight() / 2 + math.cos(math.sin(self.modY)) * 10, 
        (love.math.random() - 0.5) / 5,
    2, 2, 25, 25)

    self.screen:draw()
end

return sacrifice