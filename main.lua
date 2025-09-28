require "biribiri"
require "yan"

local player = require "modules.player"
local purgatory = require "modules.purgatory"
local bliss = require "modules.bliss"
local sacrifice = require "modules.sacrifice"
local freedom = require "modules.freedom"
local damnation = require "modules.damnation"

local GAME_STATE = {
    intro = 0,
    purgatory = 1,
    bliss = 2,
    sacrifice = 3,
    transition = 4,
    freedom = 5,
    damnation = 6
}

local game = {
    floor = 0,
    timer = 1,
    maxTime = 50,
    state = GAME_STATE.transition,
    transitionTarget = GAME_STATE.purgatory,
    creatures = {
        halt = require("modules.creatures.halt"),
        greygoose = require("modules.creatures.greygoose"),
        lava = require("modules.creatures.lava"),
        timebombs = require("modules.creatures.timebombs")
    }
}

function love.load()
    love.window.setMode(800, 600, {resizable = true})
    biribiri:LoadSprites("img")
    for _, creature in pairs(game.creatures) do
        creature:init()
    end

    world = love.physics.newWorld(0, 2000, true)

    player:Init(world)
end

function reset()
    game.floor = 0
    game.timer = 3
    game.maxTime = 50

    for name, creature in pairs(game.creatures) do
        creature:init()
        print(name, table.tostring(creature))
    end

    for _, sacrifice in ipairs(sacrifice.sacrifices) do
        sacrifice.activated = false
        print(table.tostring(sacrifice))
    end

    player.maxHealth = 100
    player.health = player.maxHealth
    player.speed = 6000
    player.jumpHeight = 3500
    player.dashSpeed = 2000
    player.maxDashCooldown = 1
    player.dashCooldown = 0

    print("are we doing anything at all???")

    game.state = GAME_STATE.transition
    game.transitionTarget = GAME_STATE.purgatory
end

function love.update(dt)
    -- game state handling

    if game.state == GAME_STATE.transition then
        game.timer = game.timer - dt

        if game.timer <= 0 then
            game.state = game.transitionTarget
            if game.state == GAME_STATE.purgatory then
                game.floor = game.floor + 1
                game.timer = game.maxTime
                player:reset()
                purgatory:start(world)

                for _, creature in ipairs(game.creatures) do
                    creature:reset()
                end
            end

            if game.state == GAME_STATE.bliss then
                bliss:start()
            end

            if game.state == GAME_STATE.sacrifice then
                sacrifice:start()
            end

            if game.state == GAME_STATE.freedom then freedom:start(game.floor) end
            if game.state == GAME_STATE.damnation then damnation:start(game.floor) end
        end
    end

    if game.state == GAME_STATE.purgatory then
        world:update(dt)
        player:Update(dt)

        game.timer = game.timer - dt

        local seconds = math.floor(game.timer)
        local msnum = math.round(game.timer, 0.1) - seconds
        ms = string.sub(msnum, 3,3)
        if ms == "" then ms = "0" end
        purgatory.timer.text = tostring(seconds).."."..ms
        purgatory.breadCounter.text = tostring(purgatory:getRemainingBread()).." remaining"
        purgatory.health.text = tostring(player.health).."/"..tostring(player.maxHealth).."HP"
        purgatory.floor.text = "FLOOR_"..tostring(game.floor)
        purgatory:update(dt, player)

        for _, creature in pairs(game.creatures) do
            creature:update(dt, player, purgatory)
        end

        if purgatory:getRemainingBread() <= 0 then
            game.state = GAME_STATE.transition
            game.timer = 1
            game.transitionTarget = GAME_STATE.bliss
        end

        if player.health <= 0 then
            damnation:start(game.floor, player.body:getX() - player.camera.x, player.body:getY() - player.camera.y)
            game.state = GAME_STATE.damnation
        end
    end

    if game.state == GAME_STATE.bliss then
        bliss:update(dt)
        game.timer = game.timer - dt
        if bliss.selected then
            if bliss.selection then
                game.state = GAME_STATE.transition
                game.timer = 0.1
                game.transitionTarget = GAME_STATE.sacrifice
            else
                game.state = GAME_STATE.transition
                game.timer = 0.1
                game.transitionTarget = GAME_STATE.freedom
            end
        end
    end

    if game.state == GAME_STATE.sacrifice then
        sacrifice:update(dt)
        game.timer = game.timer - dt
        if sacrifice.selected then
            local selectedSacrifice = sacrifice.sacrifices[sacrifice.selection]
            
            selectedSacrifice.run(player, game)
            if selectedSacrifice.reactivatable == false then
                selectedSacrifice.activated = true
            end

            game.state = GAME_STATE.transition
            game.timer = 3
            game.transitionTarget = GAME_STATE.purgatory
        end
    end

    if game.state == GAME_STATE.freedom then
        freedom:update()

        if freedom.selected then
            if freedom.selection then
                reset()
            else
                love.event.quit()
            end
        end
    end

    if game.state == GAME_STATE.damnation then
        damnation:update(dt)

        if damnation.selected then
            if damnation.selection then
                reset()
            else
                love.event.quit()
            end
        end
    end
end

function love.draw()
    if game.state == GAME_STATE.transition then
        love.graphics.setBackgroundColor(0,0,0,1)
    elseif game.state == GAME_STATE.purgatory then
        local redness = math.clamp(game.floor, 0, 9) * 0.1 + 0.1

        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(assets["img/background.png"], -1500 - player.camera.x / 2, -1500 - player.camera.y / 2)
        love.graphics.setColor(redness,0.2,0.2,0.5)
        love.graphics.draw(assets["img/background3.png"], -1500 - player.camera.x / 4 + purgatory.bgOffset, -1500 - player.camera.y / 4 + purgatory.bgOffset)
        love.graphics.setColor(redness,0.2,0.2,0.5)
        love.graphics.draw(assets["img/background3.png"], -1488 - player.camera.x / 4 - purgatory.bgOffset, -1488 - player.camera.y / 4 - purgatory.bgOffset)
        love.graphics.setColor(1,1,1,1)

        love.graphics.draw(assets["img/fence.png"], -900 - player.camera.x / 3, 700 - player.camera.y + 25)
        love.graphics.draw(assets["img/fence.png"], -900 - player.camera.x / 3, -700 - player.camera.y - 75)

        love.graphics.draw(assets["img/fence.png"], -1500 - player.camera.x + 25, -1400 - player.camera.y / 3 + 25, math.rad(90))
        love.graphics.draw(assets["img/fence.png"], 1500 - player.camera.x + 125, -1400 - player.camera.y / 3 + 25, math.rad(90))
        player:Draw()
        
        purgatory:draw(player.camera.x, player.camera.y)

        for _, creature in pairs(game.creatures) do
            creature:draw(player.camera.x, player.camera.y)
        end

        purgatory.screen:draw()

        love.graphics.setColor(1,1,1,player.dmgOverlay)
        love.graphics.draw(assets["img/damage_overlay.png"], 0, 0, 0, love.graphics.getWidth() / 800, love.graphics.getHeight() / 600)
        love.graphics.setColor(1,1,1,1)
    elseif game.state == GAME_STATE.bliss then
        love.graphics.setColor(0.2,0.2,0.2,0.5)
        love.graphics.draw(assets["img/background3.png"], -1500 - player.camera.x / 4 + bliss.bgOffset, -1500 - player.camera.y / 4 + bliss.bgOffset)
        love.graphics.draw(assets["img/background3.png"], -1488 - player.camera.x / 4 - bliss.bgOffset, -1488 - player.camera.y / 4 - bliss.bgOffset)
        love.graphics.setColor(1,1,1,1)
        bliss:draw()
    elseif game.state == GAME_STATE.sacrifice then
        love.graphics.setColor(0.7,0.2,0.2,0.3)
        love.graphics.draw(assets["img/background3.png"], -1500 - player.camera.x / 4 + sacrifice.bgOffset, -1500 - player.camera.y / 4 + sacrifice.bgOffset)
        love.graphics.draw(assets["img/background3.png"], -1488 - player.camera.x / 4 - sacrifice.bgOffset, -1488 - player.camera.y / 4 - sacrifice.bgOffset)
        love.graphics.setColor(1,1,1,1)
        sacrifice:draw()
    elseif game.state == GAME_STATE.freedom then
        freedom:draw()
    elseif game.state == GAME_STATE.damnation then
        damnation:draw()
    end
end