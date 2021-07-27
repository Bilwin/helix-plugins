
local PLUGIN = PLUGIN

function PLUGIN:PlayerTraceAttack(client, dmgInfo, dir, trace)
    local character = client:GetCharacter()
    if (character) then
        local hitgroup = trace.HitGroup
        if (self.LimbWounds[hitgroup]) then
            for index, value in ipairs(self.LimbWounds[hitgroup]) do
                local woundID = value.uniqueID
                local woundChance = value.chance or 100
                local woundFilter = value.filter
                local woundOnInstanced = value.onInstanced

                if (woundChance) then
                    local chanceCalculation = (math.min(woundChance, 100) >= math.random(100))
                    if (!chanceCalculation) then return end
                end

                if isfunction(woundFilter) then
                    local status = woundFilter(client, character, dmgInfo, dir, trace)
                    if (status) then
                        if character:AddWound(woundID) then
                            if isfunction(woundOnInstanced) then
                                woundOnInstanced(client, character, dmgInfo, dir, trace)
                            end
                        end
                    end
                else
                    if character:AddWound(woundID) then
                        if isfunction(woundOnInstanced) then
                            woundOnInstanced(client, character, dmgInfo, dir, trace)
                        end
                    end
                end

                local woundAddicts = value.addicts
                if istable(woundAddicts) then
                    for addictKey, addictValue in ipairs(woundAddicts) do
                        local addictWoundID = addictValue.uniqueID
                        local addictWoundChance = addictValue.chance
                        local addictWoundFilter = addictValue.filter
                        local addictWoundOnInstanced = addictValue.onInstanced

                        if (addictWoundChance) then
                            local addictChanceCalculation = (math.min(addictWoundChance, 100) >= math.random(100))
                            if (!addictChanceCalculation) then return end
                        end

                        if isfunction(addictWoundFilter) then
                            local addictStatus = addictWoundFilter(client, character, dmgInfo, dir, trace)
                            if (addictStatus) then
                                if character:AddWound(addictWoundID) then
                                    if isfunction(addictWoundOnInstanced) then
                                        addictWoundOnInstanced(client, character, dmgInfo, dir, trace)
                                    end
                                end
                            end
                        else
                            if character:AddWound(addictWoundID) then
                                if isfunction(addictWoundOnInstanced) then
                                    addictWoundOnInstanced(client, character, dmgInfo, dir, trace)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
