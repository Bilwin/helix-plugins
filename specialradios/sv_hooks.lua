
function ix.specialRadios:RegisterChannel(channelName)
    if self[channelName] then return end
    self[channelName] = true
end

function ix.specialRadios:RegisterFaction(faction, channels)
    if !faction then return end
    if !istable(channels) then return end
    self.factionsData[faction] = channels
end

function PLUGIN:InitFactions()
    for index, data in ipairs(ix.faction.indices) do
        if data.radioChannels and istable(data.radioChannels) then
            ix.specialRadios:RegisterFaction(index, data.radioChannels)
        end
    end
end

function ix.meta.character:HasAccessToChannel(channelName)
    if ix.specialRadios[channelName] then
        if !istable(ix.specialRadios.factionsData[self:GetFaction()]) then return false end
        return table.HasValue(ix.specialRadios.factionsData[self:GetFaction()], channelName)
    else
        return false, nil
    end
end
