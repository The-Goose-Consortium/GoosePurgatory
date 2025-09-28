local freedom = {}

function freedom:start(score)
    self.selection = false
    self.selected = false

    self.screen = screen:new()
    self.score = textlabel:new("reached floor "..tostring(score)..".", 50, "center", "center")
    self.score.position = UDim2.new(0,0,0.8,0)
    self.score.size = UDim2.new(1,0,0,50)

    self.title = textlabel:new("freed from your purgatory.", 50, "center", "center")
    self.title.size = UDim2.new(1,0,0,70)

    self.leaveBtn = textlabel:new("quit.", 30, "center", "center")
    self.leaveBtn.position = UDim2.new(0, 10, 0.5, 0)
    self.leaveBtn.size = UDim2.new(0.5, -100, 0.3, 0)
    self.leaveBtn.anchorpoint = Vector2.new(0,0.5)
    self.leaveBtn.backgroundcolor = Color.new(0,0,0,0)
    self.leaveBtn.textcolor = Color.new(1,1,1,1)

    self.leaveBtn.mousebutton1up = function ()
        self.selected = true
    end

    self.retryBtn = textlabel:new("re-enter once more.", 30, "center", "center")
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

function freedom:update()
    self.screen:update()
end

function freedom:draw()
    love.graphics.setBackgroundColor(0,0,0.5,1)
    self.screen:draw()
end

return freedom