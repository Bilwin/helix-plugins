
local PLUGIN = PLUGIN
netstream.Hook("ixCadetAccept", function(client)
    if !GetNetVar("recruitmentToggled", false) and !client:IsCombine() then return end
    local char = client:GetCharacter()
    if char then
        local stored_npcs, bStatus = ents.FindByClass("ix_cp_recruit"), false
        for i = 1, #stored_npcs do
            local npc = stored_npcs[i]
            if client:GetPos():DistToSqr(npc:GetPos()) > 500 then
                bStatus = true
                break
            end
        end
        if !bStatus then return end

        if char:GetFaction() == FACTION_CITIZEN then
            client:Freeze(true)
            client:SetAction("Берём форму Гражданской Обороны", 3, function()
                if !char:GetData("oldName") then
                    char:SetData("oldName", char:GetName())
                end

                if !char:GetData("oldModel") then
                    char:SetData("oldModel", char:GetModel())
                end

                client:Freeze(false)
                client:SetCanZoom(true)
                local model = "models/metropolice/c08.mdl"
                if client:IsFemale() then
                    model = "models/metropolice/c08_female_2.mdl"
                end
                char:SetModel(model)
                client:SetModel(model)
 
                char:InitializeCP('cdt', 'gu')
                client:EmitSound("npc/metropolice/gear"..math.random(1,6)..".wav")
            end)
        elseif char:GetFaction() == FACTION_MPF and !char:GetCPRank().IsCMB then
            client:Freeze(true)
            client:SetAction("Отдаём форму и возвращаем вещи", 3, function()
                hook.Run("PreCPDemoted", char)
                client:Freeze(false)
                char:SetFaction(FACTION_CITIZEN)

                local old_state = client:CanUseFlashlight()
                client:AllowFlashlight(true)
                client:Flashlight(false)
                client:AllowFlashlight(old_state)

                client:SetCanZoom(false)

                local weapons = ix.ranks.stored[char:GetData("cmbRank", 'rct')].weapons
                if weapons then
                    for _, weapon in ipairs(weapons) do
                        client:StripWeapon(weapon)
                    end
                end

                if char:GetData("oldName") then
                    char:SetName(char:GetData("oldName"))
                end

                if char:GetData("oldModel") then
                    char:SetModel(char:GetData("oldModel"))
                end

                char:SetData("cmbRank", nil)
                char:SetClass(CLASS_CITIZEN)
                hook.Run("OnCPDemoted", char)
                client:EmitSound("npc/metropolice/gear"..math.random(1,6)..".wav")
            end)
        end
    end
end)

util.AddNetworkString("ixCombineDisplayUpdate")
function PLUGIN:OnCPSet(character)
    local client = character:GetPlayer()
    net.Start("ixCombineDisplayUpdate")
        net.WriteBool(true)
    net.Send(client)
end

function PLUGIN:OnCPDemoted(character)
    local client = character:GetPlayer()
    net.Start("ixCombineDisplayUpdate")
        net.WriteBool(false)
    net.Send(client)
end

function PLUGIN:PreCPDemoted(character)
    if (character:GetCPRank().name == "OFC") then
        local count = 0
        for _, v in ipairs( player.GetAll() ) do
            if !v:GetCharacter() then continue end
            if !v:IsCombine() then continue end
            if (v:GetCharacter():GetCPRank().name || NULL) != "OFC" then continue end
            count = count + 1
        end

        if count <= 1 then
            SetNetVar("recruitmentToggled", true)
        end
    end
end

function PLUGIN:PlayerDisconnected(client)
    local char = client:GetCharacter()
    if char then
        local isCombine = client:IsCombine()
        if !isCombine then return end
        local storedRank = char:GetCPRank()
        if (storedRank.name == "OFC") then
            local count = 0
            for _, v in ipairs( player.GetAll() ) do
                if !v:GetCharacter() then continue end
                if !v:IsCombine() then continue end
                if v:GetCharacter():GetCPRank().name != "OFC" then continue end
                count = count + 1
            end

            if count <= 1 then
                SetNetVar("recruitmentToggled", true)
            end
        end
    end
end

function PLUGIN:PlayerLoadedCharacter(client, char, oldChar)
    if oldChar and oldChar:IsCombine() and oldChar:GetCPRank() != nil then
        if (oldChar:GetCPRank().name == "OFC") then
            local count = 0
            for _, v in ipairs( player.GetAll() ) do
                if !v:GetCharacter() then continue end
                if !v:IsCombine() then continue end
                if (v:GetCharacter():GetCPRank().name || NULL) != "OFC" then continue end
                count = count + 1
            end
    
            if count <= 1 then
                SetNetVar("recruitmentToggled", true)
            end
        end
    end
end

function PLUGIN:SaveData()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_cp_recruit")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles()}
	end

	ix.data.Set("cpRecruits", data)
end

function PLUGIN:LoadData()
	for _, v in ipairs(ix.data.Get("cpRecruits") or {}) do
		local recruiter = ents.Create("ix_cp_recruit")

		recruiter:SetPos(v[1])
		recruiter:SetAngles(v[2])
		recruiter:Spawn()
	end
end

function PLUGIN:InitPostEntity()
    timer.Simple(FrameTime() * bit.lshift(2, 2), function()
        SetNetVar("recruitmentToggled", true)
    end)
end