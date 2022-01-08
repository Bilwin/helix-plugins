
local PLUGIN = PLUGIN
local CHAR = ix.meta.character
local prime_visors = "0_0_0"
function CHAR:CalculateUniformSkin(bCheckOutfit)
    local squad = self:GetSquad()
    local client = self:GetPlayer()
    local uniform = ix.squads.stored[squad].uniform
    local visors = ix.squads.stored[squad].visor

    if uniform then
        if bCheckOutfit then
            if !cpoutfit.IsSupported(client:GetModel()) then return false end
        end

        cpoutfit.SetCPOutfit(client, uniform)
    end

    if visors then
        if bCheckOutfit then
            if !cpoutfit.IsSupported(client:GetModel()) then return false end
        end

        cpoutfit.SetCPVisors(client, visors['p'], visors['s'])
    else
        cpoutfit.SetCPVisors(client, prime_visors, prime_visors)
    end
end

function CHAR:SetSquad(newSquad)
    local squad_data = ix.squads.stored[newSquad]
    if !squad_data then return false end
    local oldSquad = self:GetSquad()
    local oldSquad_data = ix.squads.stored[oldSquad]
    local oldCallback = oldSquad_data.onDemoted
    if oldCallback then
        oldCallback(self, newSquad)
    end
    hook.Run("OnCPSquadDemoted", self, oldSquad, newSquad)

    self:SetData("cmbSquad", newSquad)
    local callback = squad_data.onInstanced
    if callback then
        callback(self, oldSquad)
    end
    local uniform = squad_data.uniform
    if uniform then
        self:CalculateUniformSkin(true)
    end
    hook.Run("OnCPSquadInstanced", self, oldSquad, newSquad)
end