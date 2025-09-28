local freedom = {}

function freedom:start(score)
    self.selection = false
    self.selected = false

    self.screen = screen:new()
    self.score = textlabel:new("reached floor "..tostring(score)..".", 50, "center", "center")
    self.score.position = UDim2.new(0,0,0.8,0)
    self.score.size = UDim2.new(1,0,0,50)
    self.score.textcolor = Color.new(1,1,1,1)
    self.score.backgroundcolor = Color.new(0,0,0,0)

    self.title = textlabel:new("freed from your purgatory.", 90, "center", "center")
    self.title.size = UDim2.new(1,0,0,90)
    self.title.position = UDim2.new(0,0,0,20)
    self.title.textcolor = Color.new(1,1,1,1)
    self.title.backgroundcolor = Color.new(0,0,0,0)

    self.leaveBtn = textlabel:new("quit.", 60, "center", "center")
    self.leaveBtn.position = UDim2.new(0, 10, 0.5, 0)
    self.leaveBtn.size = UDim2.new(0.5, -100, 0.3, 0)
    self.leaveBtn.anchorpoint = Vector2.new(0,0.5)
    self.leaveBtn.backgroundcolor = Color.new(0,0,0,0)
    self.leaveBtn.textcolor = Color.new(1,1,1,1)

    self.leaveBtn.mouseenter = function ()
        self.leaveBtn.textcolor = Color.new(0.7,0.7,0.7,1)
    end

    self.leaveBtn.mouseexit = function ()
        self.leaveBtn.textcolor = Color.new(1,1,1,1)
    end

    self.leaveBtn.mousebutton1up = function ()
        self.selected = true
    end

    self.retryBtn = textlabel:new("re-enter once more.", 60, "center", "center")
    self.retryBtn.position = UDim2.new(1,-10, 0.5, 0)
    self.retryBtn.size = UDim2.new(0.5, -100, 0.3, 0)
    self.retryBtn.anchorpoint = Vector2.new(1,0.5)
    self.retryBtn.backgroundcolor = Color.new(0,0,0,0)
    self.retryBtn.textcolor = Color.new(1,1,1,1)

    self.retryBtn.mouseenter = function ()
        self.retryBtn.textcolor = Color.new(0.7,0.7,0.7,1)
    end

    self.retryBtn.mouseexit = function ()
        self.retryBtn.textcolor = Color.new(1,1,1,1)
    end

    self.retryBtn.mousebutton1up = function ()
        self.selection = true
        self.selected = true
    end

    self.spritesheet = assets["img/freedom.png"]
    assets["img/freedom.png"]:setFilter("linear", "nearest")
    self.quads = {}

    local w, h = 201, 150

    for y = 0, self.spritesheet:getHeight() - h, h do
        for x = 0, self.spritesheet:getWidth(), w do
            table.insert(self.quads, love.graphics.newQuad(x, y, w, h, self.spritesheet:getDimensions()))
        end
    end

    self.frame = 1
    self.frameTimer = 0

    self.screen:addelements({self.score, self.title, self.retryBtn, self.leaveBtn})
end 

function freedom:update(dt)
    self.frameTimer = self.frameTimer + dt
    if self.frameTimer >= 0.2 then
        self.frame = self.frame + 1
        self.frameTimer = 0
        if self.frame == 4 then
            self.frame = 1
        end
    end
    self.screen:update()
end

function freedom:draw()
    love.graphics.draw(self.spritesheet, self.quads[self.frame], 0, 0, 0, love.graphics.getWidth() / 200, love.graphics.getHeight() / 150)
    love.graphics.setBackgroundColor(0,0,0.5,1)
    self.screen:draw()
end

return freedom