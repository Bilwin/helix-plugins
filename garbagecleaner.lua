
local PLUGIN = PLUGIN
PLUGIN.name = "Garbage Cleaner"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Just garbage (ix_item) cleaner"
PLUGIN.schema = "Any"
PLUGIN.garbage = {'ix_item'}

if !ix.stdlib then return end

do
    ix.config.Add("garbageCleanerEnabled", true, "Enable garbage (ix_item) cleaner?", function(_, newValue)
        if (SERVER) then
            if (timer.exists('GarbageCleaner')) then
                if (newValue) then
                    timer.start('GarbageCleaner')
                else
                    timer.stop('GarbageCleaner')
                end
            end
        end
    end, {
        category = PLUGIN.name
    })

    ix.config.Add("garbageCleanerDelay", 300, "How many seconds does a timer tick?", function(_, newValue)
        if (SERVER) then
            if (timer.exists('GarbageCleaner')) then
                timer.adjust('GarbageCleaner', newValue)
            end
        end
    end, {
        data = {min = 1, max = 1200},
        category = PLUGIN.name
    })
end

if (SERVER) then
    function PLUGIN:CreateGarbageCleaner(delay)
        if (timer.exists('GarbageCleaner')) then timer.remove('GarbageCleaner') end

        local delay = ix.config.Get('garbageCleanerDelay', 300)
        timer.create('GarbageCleaner', delay, 0, function()
            for _, ent in ipairs( ents.GetAll() ) do
                if !table.has_value(self.garbage, ent:GetClass()) then continue end
                SafeRemoveEntity(ent)
            end
        end)
    end

    function PLUGIN:InitPostEntity()
        self:CreateGarbageCleaner()
    end
end