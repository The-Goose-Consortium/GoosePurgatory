local bliss = {}

function bliss:start()
    self.gooseSin = 0
    self.bgOffset = 0
    self.screen = screen:new()
    self.selection = false
    self.selected = false

    self.escapeBtn = textlabel:new("escape the purgatory.", 50, "center", "center")
    self.escapeBtn.position = UDim2.new(0, 10, 0.5, 0)
    self.escapeBtn.size = UDim2.new(0.5, -100, 0.3, 0)
    self.escapeBtn.anchorpoint = Vector2.new(0,0.5)
    self.escapeBtn.backgroundcolor = Color.new(0,0,0,0)
    self.escapeBtn.textcolor = Color.new(1,1,1,1)

    self.escapeBtn.mouseenter = function ()
        self.escapeBtn.textcolor = Color.new(0.6,0.6,1,1)
    end

    self.escapeBtn.mouseexit = function ()
        self.escapeBtn.textcolor = Color.new(1,1,1,1)
    end

    self.escapeBtn.mousebutton1up = function ()
        self.selected = true
    end

    self.continueBtn = textlabel:new("continue your suffering.", 50, "center", "center")
    self.continueBtn.position = UDim2.new(1,-10, 0.5, 0)
    self.continueBtn.size = UDim2.new(0.5, -100, 0.3, 0)
    self.continueBtn.anchorpoint = Vector2.new(1,0.5)
    self.continueBtn.backgroundcolor = Color.new(0,0,0,0)
    self.continueBtn.textcolor = Color.new(1,1,1,1)

    self.continueBtn.mousebutton1up = function ()
        self.selection = true
        self.selected = true
    end


    self.continueBtn.mouseenter = function ()
        self.continueBtn.textcolor = Color.new(1,0.4,0.4,1)
    end

    self.continueBtn.mouseexit = function ()
        self.continueBtn.textcolor = Color.new(1,1,1,1)
    end

    self.screen:addelements({self.escapeBtn, self.continueBtn})
end

function bliss:update(dt)
    self.bgOffset = self.bgOffset + dt * 60
    if self.bgOffset >= 400 then
        self.bgOffset = 0
    end

    self.gooseSin = self.gooseSin + dt * 3

    self.screen:update()
end

function bliss:draw()
    love.graphics.setBackgroundColor(0,0,0,1)
    love.graphics.draw(assets["img/player.png"], love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 + math.sin(self.gooseSin) * 50, math.sin(self.gooseSin / 2) / 10, 2, 2, 25, 25)

    self.screen:draw()
end

return bliss