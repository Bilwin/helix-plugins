
function ix.specialRadios:RegisterChannel(channelName)
    if self[channelName] then return end
    self[channelName] = true
end

function ix.specialRadios:RegisterFaction(faction, channels)
    if !faction then return end
    if !istable(channels) then return end
    self.factionsData[faction] = channels
end

function ix.meta.character:HasAccessToChannel(channelName)
    if ix.specialRadios[channelName] then
        if !istable(ix.specialRadios.factionsData[self:GetFaction()]) then return false end
        return table.HasValue(ix.specialRadios.factionsData[self:GetFaction()], channelName)
    else
        return false, nil
    end
end
