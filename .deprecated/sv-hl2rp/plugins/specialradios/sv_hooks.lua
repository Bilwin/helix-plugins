
function ix.specialRadios:RegisterChannel(channelName)
    if (self[channelName]) then return end
    self[channelName] = true
end

function ix.specialRadios:RegisterFaction(faction, channels)
    if !faction then return end
    if !istable(channels) then return end
    self.factionsData[faction] = channels
end

local factionIndices = ix.faction.indices
function PLUGIN:InitFactions()
    for index, data in ipairs( factionIndices ) do
        if data.radioChannels and istable(data.radioChannels) then
            ix.specialRadios:RegisterFaction(index, data.radioChannels)
        end
    end
end

local CHAR = ix.meta.character
function CHAR:HasAccessToChannel(channelName)
    if (ix.specialRadios[channelName]) then
        if !istable(ix.specialRadios.factionsData[self:GetFaction()]) then return false end
        if table.HasValue(ix.specialRadios.factionsData[self:GetFaction()], channelName) then
            return true
        else
            return false
        end
    else
        return false, nil
    end
end

do
    ix.specialRadios:RegisterChannel("cmb")
    ix.specialRadios:RegisterChannel("ota")
end
