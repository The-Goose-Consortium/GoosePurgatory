local lava = {}

function lava:init()
    self.active = false
    self.dmgTick = 0
end

function lava:update(dt, player, purgatory)
    if not self.active then return end

    for _, platform in ipairs(purgatory.platforms) do
        if #platform.body:getContacts() >= 1 and platform.canLava then
            platform.lava = math.clamp(platform.lava + dt / 5, 0, 1)

            if platform.lava >= 0.7 and self.dmgTick <= 0 then
                self.dmgTick = 0.5
                player.health = player.health - 3
            end
        end
    end

    if self.dmgTick > 0 then
        self.dmgTick = self.dmgTick - dt
    end
end

function lava:reset()
    self.dmgTick = 0
end

function lava:draw()
    
end

return lava