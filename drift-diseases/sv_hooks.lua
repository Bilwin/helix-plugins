
local PLUGIN = PLUGIN

ix.Diseases.Registered = ix.Diseases.Registered or {
    ["cough"] = true,
    ["blindness"] = true
}
ix.Diseases.Loaded = ix.Diseases.Loaded or {}
ix.Diseases.RandomGetDiseases = {}

for k, _ in pairs(ix.Diseases.Registered) do
    ix.Diseases.Loaded[k] = ix.util.Include( "diseases/" .. k .. ".lua", "server" )
end

for k, v in pairs(ix.Diseases.Loaded) do
    if (v.canGetRandomly or false) then
        table.insert(ix.Diseases.RandomGetDiseases, k)
    end
end

local function IsEmptyTable(t)
	return next( t ) == nil or true
end

function PLUGIN:PostPlayerLoadout(pl)
    if IsValid(pl) then
        local char = pl:GetCharacter()

        if char then
            if char:GetDisease() == "" then
                ix.Diseases:RemoveAllDiseases(pl)
                return
            end

            local _diseases = string.Split(char:GetDisease(), ";")

            if _diseases then
                for _, id in pairs(_diseases) do
                    ix.Diseases:InfectPlayer(pl, id, false)
                end
            end

            if IsEmptyTable(ix.Diseases.RandomGetDiseases) then return end

            if pl:_TimerExists( "bDiseaseRandom::" .. pl:SteamID64() ) then
                pl:_RemoveTimer( "bDiseaseRandom::" .. pl:SteamID64() )
            end

            pl:_SetTimer( "bDiseaseRandom::" .. pl:SteamID64(), 60 * 10, 0, function()
                if math.random(100) > 90 then
                    ix.Diseases:SetRandomDisease(pl)
                end
            end)
        end
    end
end

--[[
    ix.Diseases base
    Don't edit it if you don't know what you are doing.
--]]

function ix.Diseases:SetRandomDisease(pl)
    if IsValid(pl) and pl:IsPlayer() then
        local char = pl:GetCharacter() or false

        if char then
            local _randomkey = string.match( table.Random(ix.Diseases.RandomGetDiseases), "^.*$" )

            ix.Diseases:InfectPlayer(pl, _randomkey, true)
        end
    end
end

function ix.Diseases:InfectPlayer(pl, disease, bCheck)
    if !ix.Diseases.Registered[disease] then return end
    if IsValid(pl) then
        local char = pl:GetCharacter() or false
        if char then
            for k, v in SortedPairs(ix.Diseases.Loaded) do
                if disease == k then
                    if table.HasValue( v.immuneFactions, pl:Team() ) then return end
                    if (hook.Run( "CanPlayerGetDisease", pl, disease ) or false) then return end

                    if bCheck then
                        if char:GetDisease() ~= "" then
                            if char:GetDisease():find(k) then return end
                            char:SetData( "diseaseInfo", char:GetDisease() .. ";" .. k )
                        else
                            char:SetData( "diseaseInfo", k )
                        end
                    end
                    
                    if (v.functionsIsClientside or false) then
                        pl:SendLua(v.OnCall)
                    else
                        v.OnCall(pl)
                    end

                    hook.Run( "PlayerInfected", pl, disease )
                end
            end
        end
    end
end

function ix.Diseases:DisinfectPlayer(pl, disease)
    if !ix.Diseases.Registered[disease] and isstring(disease) then return end
    if IsValid(pl) then
        local char = pl:GetCharacter() or false
        if char then
            if (hook.Run( "CanPlayerDisinfect", pl, disease ) or false) then return end
            if istable(disease) then
                for _, k in pairs(disease) do
                    for id, v in SortedPairs(ix.Diseases.Loaded) do
                        local diseases = string.Split(char:GetDisease(), ";")

                        if istable(diseases) then
                            table.RemoveByValue(diseases, k)
                            diseases = table.concat(diseases, ";")
                        end

                        char:SetData( "diseaseInfo", tostring(diseases) )

                        if id == k then
                            if (v.functionsIsClientside or false) then
                                pl:SendLua(v.OnEnd)
                            else
                                v.OnEnd(pl)
                            end
                        end

                        hook.Run( "PlayerDisinfected", pl, disease )
                    end
                end

                return
            end

            for id, v in SortedPairs(ix.Diseases.Loaded) do
                if id == disease then
                    if (v.functionsIsClientside or false) then
                        pl:SendLua(v.OnEnd)
                    else
                        v.OnEnd(pl)
                    end
                end
            end

            local diseases = string.Split(char:GetDisease(), ";")

            if istable(diseases) then
                table.RemoveByValue(diseases, disease)
                diseases = table.concat(diseases, ";")
            end

            char:SetData( "diseaseInfo", tostring(diseases) )

            hook.Run( "PlayerDisinfected", pl, disease )
        end
    end
end

function ix.Diseases:RemoveAllDiseases(pl)
    if IsValid(pl) then
        for k, _ in SortedPairs(ix.Diseases.Registered) do
            ix.Diseases:DisinfectPlayer(pl, k)
        end
    end
end

--[[
    Chat Commands
--]]

ix.command.Add("InfectPlayer", {
    description = "Set Disease for player",
    adminOnly = true,
    arguments = {ix.type.player, ix.type.string},
    argumentNames = {"Target (Player)(SteamID or Name)", "Disease"},
    OnRun = function(self, pl, target, disease)
        if !target or !disease then return end
        if ( hook.Run( "CanPlayerGetDisease", target, disease ) or false ) then return end

        ix.Diseases:InfectPlayer(target, disease, true)
        ix.util.NotifyLocalized( "diseasesInfected", pl, target:Name(), disease )
    end
})

ix.command.Add("DisinfectPlayer", {
    description = "Remove Disease for player",
    adminOnly = true,
    arguments = {ix.type.player, ix.type.string},
    argumentNames = {"Target (Player)(SteamID or Name)", "Disease"},
    OnRun = function(self, pl, target, disease)
        if !target or !disease then return end
        if ( hook.Run( "CanPlayerDisinfect", target, disease ) or false ) then return end

        ix.Diseases:DisinfectPlayer(target, disease)
        ix.util.NotifyLocalized( "diseasesDisinfected", pl, target:Name(), disease )
    end
})

ix.command.Add("RemoveAllDiseases", {
    description = "Remove all diseases for player",
    adminOnly = true,
    arguments = {ix.type.player},
    argumentNames = {"Target (Player)(SteamID or Name)"},
    OnRun = function(self, pl, target)
        if !target then return end

        ix.Diseases:RemoveAllDiseases(target)
        ix.util.NotifyLocalized( "diseasesFullyDisinfected", pl, target:Name() )
    end
})
