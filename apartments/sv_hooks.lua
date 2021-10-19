
local PLUGIN = PLUGIN

function PLUGIN:LoadData()
    local apart_locks = ix.data.Get('apart_locks') or {}
    if !table.IsEmpty(apart_locks) then
        for _, v in ipairs(apart_locks) do
            local door = ents.GetMapCreatedEntity(v[1])
            if (IsValid(door) and door:IsDoor()) then
                local lock = ents.Create("ix_apartlock")
                lock:SetPos(door:GetPos())
                lock:Spawn()
                lock:SetDoor(door, door:LocalToWorld(v[2]), door:LocalToWorldAngles(v[3]))
                lock:SetLocked(v[4])
                local owners = tostring(v[5])
                if owners then
                    lock:SetOwners(owners)
                end
            end
        end
    end
end

function PLUGIN:SaveData()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_apartlock")) do
		if (IsValid(v.door)) then
			data[#data + 1] = {
				v.door:MapCreationID(),
				v.door:WorldToLocal(v:GetPos()),
				v.door:WorldToLocalAngles(v:GetAngles()),
				v:GetLocked(),
                v:GetOwners()
			}
		end
	end

	ix.data.Set("apart_locks", data)
end

function PLUGIN:PlayerSpawnedSENT(client, ent)
    if ent:GetClass() == "ix_apartlock" then
        self:SaveData()
    end
end

function PLUGIN:ApartmentOwned(locker, cid)
	self:SaveData()
end

function PLUGIN:ApartmentUnowned(locker, cid)
	self:SaveData()
end

function PLUGIN:ApartmentRemoved(locker)
	self:SaveData()
end