local damnation = {}

function damnation:start(score, x, y)
    self.selection = false
    self.selected = false
    self.fading = 0

    self.fadeTimer = 0

    self.x = x
    self.y = y

    self.screen = screen:new()
    self.score = textlabel:new("reached floor "..tostring(score)..".", 50, "center", "center")
    self.score.position = UDim2.new(0,0,0.8,0)
    self.score.size = UDim2.new(1,0,0,50)
    self.score.backgroundcolor = Color.new(0,0,0,0)

    self.title = textlabel:new("you have ceased to exist.", 50, "center", "center")
    self.title.size = UDim2.new(1,0,0,70)
    self.title.backgroundcolor = Color.new(0,0,0,0)

    self.leaveBtn = textlabel:new("quit.", 30, "center", "center")
    self.leaveBtn.position = UDim2.new(0, 10, 0.5, 0)
    self.leaveBtn.size = UDim2.new(0.5, -100, 0.3, 0)
    self.leaveBtn.anchorpoint = Vector2.new(0,0.5)
    self.leaveBtn.backgroundcolor = Color.new(0,0,0,0)
    self.leaveBtn.textcolor = Color.new(1,1,1,1)

    self.leaveBtn.mousebutton1up = function ()
        self.selected = true
    end

    self.retryBtn = textlabel:new("redeem yourself.", 30, "center", "center")
    self.retryBtn.position = UDim2.new(1,-10, 0.5, 0)
    self.retryBtn.size = UDim2.new(0.5, -100, 0.3, 0)
    self.retryBtn.anchorpoint = Vector2.new(1,0.5)
    self.retryBtn.backgroundcolor = Color.new(0,0,0,0)
    self.retryBtn.textcolor = Color.new(1,1,1,1)

    self.retryBtn.mousebutton1up = function ()
        self.selection = true
        self.selected = true
    end

    self.screen:addelements({self.score, self.title, self.retryBtn, self.leaveBtn})
end 

function damnation:update(dt)
    self.screen:update()

    self.fadeTimer = self.fadeTimer + dt

    if self.fadeTimer >= 2 then
        self.fading = math.clamp(self.fading + dt / 3, 0, 1)
    end

    self.leaveBtn.textcolor = Color.new(1,1,1,self.fading)
    self.retryBtn.textcolor = Color.new(1,1,1,self.fading)
    self.score.textcolor = Color.new(1,1,1,self.fading)
    self.title.textcolor = Color.new(1,1,1,self.fading)
end

function damnation:draw()
    love.graphics.setBackgroundColor(0.2,0,0,1)

    love.graphics.setColor(1,1,1, self.fading)

    self.screen:draw()

    love.graphics.setColor(1,1,1, 1 + -self.fading)

    love.graphics.draw(assets["img/player.png"], self.x, self.y)
end

return damnation