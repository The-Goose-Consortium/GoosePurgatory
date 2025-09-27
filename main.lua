require "biribiri"
require "yan"

local player = require "modules.player"
local purgatory = require "modules.purgatory"
local bliss = require "modules.bliss"
local sacrifice = require "modules.sacrifice"

local GAME_STATE = {
    intro = 0,
    purgatory = 1,
    bliss = 2,
    sacrifice = 3,
    transition = 4
}

local game = {
    round = 1,
    timer = 3,
    maxTime = 50,
    state = GAME_STATE.transition,
    transitionTarget = GAME_STATE.purgatory
}

function love.load()
    love.window.setMode(800, 600, {resizable = true})

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
    
end

function love.update(dt)

    -- game state handling

    if game.state == GAME_STATE.transition then
        game.timer = game.timer - dt

        if game.timer <= 0 then
            game.state = game.transitionTarget
            if game.state == GAME_STATE.purgatory then
                game.timer = game.maxTime
                purgatory:start(world)
            end

            if game.state == GAME_STATE.bliss then
                bliss:start()
            end

            if game.state == GAME_STATE.sacrifice then
                sacrifice:start()
            end
        end
    end

    if game.state == GAME_STATE.purgatory then
        world:update(dt)
        player:Update(dt)

        game.timer = game.timer - dt

        purgatoryTimer.text = "time: "..tostring(math.round(game.timer, 0.01))
        purgatoryBreadCounter.text = "breads: "..tostring(purgatory:getRemainingBread())

        purgatory:update(dt, player)

        if purgatory:getRemainingBread() <= 0 then
            game.state = GAME_STATE.transition
            game.timer = 3
            game.transitionTarget = GAME_STATE.bliss
        end
    end

    if game.state == GAME_STATE.bliss then
        bliss:update(dt)

        if bliss.selected then
            if bliss.selection then
                game.state = GAME_STATE.transition
                game.timer = 0.1
                game.transitionTarget = GAME_STATE.sacrifice
            end
        end
    end

    if game.state == GAME_STATE.sacrifice then
        sacrifice:update(dt)

        if sacrifice.selected then
            local selectedSacrifice = sacrifice.sacrifices[sacrifice.selection]
            
            selectedSacrifice.run(player, game)

            game.state = GAME_STATE.transition
            game.timer = 3
            game.transitionTarget = GAME_STATE.purgatory
        end
    end
end

function love.draw()
    if game.state == GAME_STATE.transition then
        -- Nothing.
    elseif game.state == GAME_STATE.purgatory then
        love.graphics.draw(assets["img/goog.png"], bgQuad, -100000 - player.camera.x / 2, -100000 - player.camera.y / 2)

        player:Draw()

        purgatory:draw(player.camera.x, player.camera.y)

        purgatoryScreen:draw()
    elseif game.state == GAME_STATE.bliss then
        bliss:draw()
    elseif game.state == GAME_STATE.sacrifice then
        sacrifice:draw()
    end
end