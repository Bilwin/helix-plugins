
local Schema = Schema
function Schema:CanPlayerUseBusiness(client, uniqueID)
	return false
end

-- called when the client wants to edit the combine data for the given target
function Schema:CanPlayerEditData(client, target)
	return client:IsCombine() and (!target:IsCombine() and target:Team() != FACTION_ADMIN)
end

function Schema:CanPlayerViewObjectives(client)
	return client:IsCombine()
end

function Schema:CanPlayerEditObjectives(client)
	if (!client:IsCombine() or !client:GetCharacter()) then
		return false
	end

	local bCanEdit = false
	local name = client:GetCharacter():GetName():lower()

	for _, v in ipairs({"ofc", "dvl", "sec"}) do
		if self:IsCombineRank(name, v) then
			bCanEdit = true
			break
		end
	end

	return bCanEdit
end

function Schema:CanDrive()
	return false
end

function Schema:EntityEmitSound(soundData)
    if (CLIENT) then
        if ix.option.Get("thirdpersonEnabled") then
            if !soundData.Entity:IsPlayer() then
                return
            end

            local soundName = soundData.OriginalSoundName
            local blockedSuffixes = { ".stepleft", ".stepright" }

            for i = 1, #blockedSuffixes do
                local v = blockedSuffixes[i]

                if (soundName:sub(-#v) == v) then
                    return false
                end
            end
        end
    end

    if (soundData.Entity and IsValid(soundData.Entity)) then
        if (soundData.Entity:GetClass() == "npc_combine_camera") then
            local soundName = soundData.SoundName
            if soundName == 'npc/turret_floor/ping.wav' then
                return false
            end
        end
    end
end

function Schema:InitializedPlugins()
    local stored = weapons.GetStored("ix_hands")
    if stored then
        stored.Instructions = [[
ЛКМ: Ударить/Кинуть
ПКМ: Стучаться/Поднять
ПКМ + Мышь: Поворачивать объект
R: Положить]]
        stored.PrintName = "Руки"
    end

    stored = weapons.GetStored("ix_keys")
    if stored then
        stored.Instructions = [[
ЛКМ: Запереть
ПКМ: Разблокировать]]
        stored.PrintName = "Ключи"
    end

    stored = weapons.GetStored("ix_stunstick")
    if stored then
        stored.Instructions = [[
ЛКМ: Бить/Парализовать
ALT + ЛКМ: Переключить парализатор
ПКМ: Толкать/Стучать]]
        stored.PrintName = "Парализатор"
    end
end