require "biribiri"
require "yan"

local player = require "modules.player"
local purgatory = require "modules.purgatory"

local GAME_STATE = {
    intro = 0,
    purgatory = 1,
    bliss = 2,
    sacrifice = 3,
}

local game = {
    round = 1,
    timer = 50,
    maxTime = 50,
    state = GAME_STATE.purgatory
}

function love.load()
    world = love.physics.newWorld(0, 2000, true)
    biribiri:LoadSprites("img")
    assets["img/goog.png"]:setWrap("repeat", "repeat")
    bgQuad = love.graphics.newQuad(0, 0, 200000, 200000, 100, 100)

    

    purgatoryScreen = screen:new()
    purgatoryTimer = textlabel:new("0", 30, "center", "center")
    purgatoryTimer.size = UDim2.new(1,0,0,50)

    purgatoryBreadCounter = textlabel:new("0", 20, "left", "center")
    purgatoryBreadCounter.position = UDim2.new(0,0,0,50)
    purgatoryBreadCounter.size = UDim2.new(0.2,0,0,40)


    purgatoryScreen:addelements({purgatoryTimer, purgatoryBreadCounter})

    player:Init(world)
    purgatory:start(world)
end

function love.update(dt)
    world:update(dt)
    player:Update(dt)

    -- game state handling

    if game.state == GAME_STATE.purgatory then
        game.timer = game.timer - dt

        purgatoryTimer.text = "time: "..tostring(math.round(game.timer, 0.01))
        purgatoryBreadCounter.text = "breads: "..tostring(purgatory:getRemainingBread())

        purgatory:update(dt, player)
    end
end

function love.draw()
    love.graphics.draw(assets["img/goog.png"], bgQuad, -100000 - player.camera.x / 2, -100000 - player.camera.y / 2)

    player:Draw()

    purgatory:draw(player.camera.x, player.camera.y)

    purgatoryScreen:draw()
end