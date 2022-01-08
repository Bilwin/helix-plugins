
local PLUGIN = PLUGIN
local _tonumber = tonumber
local meta = ix.meta.character

function meta:BeCP(rank, squad)
    if !rank then return end
    if !ix.ranks.stored[rank] then error("unspecified rank in meta:BeCP: " .. rank) return end

    -- Name generator
    local name = 'C'..ix.config.Get("cpCityNumber", 17)
    local prime = self:GetData("cmbPrimeID", Schema:ZeroNumber(math.random(1, 99999), 5))
    if squad then
        name = name..'.MPF.'..squad..'.'..rank..' #'..prime
    else
        name = name..'.MPF.GU.'..rank..' #'..prime
    end
    self:SetName(name:upper())

    -- Rank generator
    self:SetData("cmbRank", rank)
    local callback = ix.ranks.stored[rank].callback
    if callback then
        callback(self)
    end

    -- Sterilization Points
    local bExist = self:GetData("cmbSP", false)
    if isbool(bExist) and !bExist then
        self:SetData("cmbSP", 0)
    end

    -- Faction set
    self:SetFaction(FACTION_MPF)
    self:SetClass(CLASS_MPU)
    if squad then
        self:SetData("cmbSquad", squad)
    else
        self:SetData("cmbSquad", 'gu')
    end

    hook.Run("OnCPSet", self, rank, squad)
end

function meta:InitializeCP(rank, squad)
    self:BeCP(rank or 'rct', squad or 'gu')

    -- additional callbacks after init
    local callback = ix.ranks.stored[rank].callback
    if callback then callback(self) end

    -- weapons
    for _, data in ipairs(ix.ranks.stored) do
        if data.weapons then
            for _, weapon in ipairs(data.weapons) do
                self:GetPlayer():StripWeapon(weapon)
            end
        end
    end

    self:GetPlayer():SetSimpleTimer(1, function()
        local weapons = ix.ranks.stored[rank].weapons
        if weapons then 
            for _, weapon in ipairs(weapons) do
                self:GetPlayer():Give(weapon)
            end
        end
    end)

    -- armband setup
    local armband_code = ix.ranks.stored[rank].armband_code
    cpoutfit.SetCPArmband(self:GetPlayer(), armband_code)

    -- bodygroups setup
    local bodygroups = ix.ranks.stored[rank].bodygroups
    if bodygroups then
        for i = 1, 10 do
            local number = string.sub(bodygroups, i, i)
            if number and number != "" then
                self:GetPlayer():SetBodygroup( 1 + i, _tonumber(number) )
            end
        end
    end
end

function meta:SetCPPoint(amount)
    if !isnumber(amount) then return end
    self:SetData("cmbSP", amount)
    hook.Run("OnSPChanged", self, self:GetData("cmbSP", 0), 'set', amount)
end

function meta:AddCPPoint(amount)
    if !isnumber(amount) then return end
    self:SetData("cmbSP", self:GetData("cmbSP", 0) + amount)
    hook.Run("OnSPChanged", self, self:GetData("cmbSP", 0), 'add', amount)
end

function meta:TakeCPPoint(amount)
    if !isnumber(amount) then return end
    amount = math.abs(amount)
    local calculated = self:GetData("cmbSP", 0) - amount
    if calculated < 0 then calculated = 0 end
    self:SetData("cmbSP", calculated)
    hook.Run("OnSPChanged", self, self:GetData("cmbSP", 0), 'take', calculated)
end
