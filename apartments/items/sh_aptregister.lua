
ITEM.name = "Registration of an apartment device"
ITEM.model = Model("models/props_lab/reciever01d.mdl")
ITEM.description = "A hand-held device for Civil Protection used to assign and revoke housing. It seems somewhat technologically underwhelming though does require an authorized bio-signal to use."
ITEM.category = 'Miscellaneous'

ITEM.functions.AddOwner = {
	name = "Assign Tenant",
	tip = "useTip",
	icon = "icon16/arrow_right.png",
	OnRun = function(item)
        local client = item.player

        if IsValid(client) and client:IsCombine() then
            client:RequestString("Register", "Please enter the ID of the new tenant", function(text)
                local target = client:CalculateTrace(96).Entity

                if IsValid(target) and target:GetClass() == "ix_apartlock" then
                    if string.len(text) > 1 and string.len(text) < 7 then
                        if isnumber(tonumber(text)) then
                            target:AddOwner(text)
                            client:Notify("Assigned #" .. text)
                            client:EmitSound("buttons/button18.wav")
                        end
                    end
                end
            end, "00000")
        end

		return false
	end,
	OnCanRun = function(item)
		return item.player:IsCombine() and (IsValid(item.player:CalculateTrace(96).Entity) and item.player:CalculateTrace(96).Entity:GetClass() == "ix_apartlock")
	end
}

ITEM.functions.RemoveOwner = {
	name = "Revoke Tenant",
	tip = "useTip",
	icon = "icon16/arrow_right.png",
	OnRun = function(item)
        local client = item.player

        if IsValid(client) and client:IsCombine() then
            client:RequestString("Revoke", "Please enter the ID of the tenant", function(text)
                local target = client:CalculateTrace(96).Entity

                if IsValid(target) and target:GetClass() == "ix_apartlock" then
                    if string.len(text) > 1 and string.len(text) < 7 then
                        if isnumber(tonumber(text)) then
                            target:RemoveOwner(text)
                            client:Notify("Revoked #" .. text)
                            client:EmitSound("buttons/button24.wav")
                        end
                    end
                end
            end, "00000")
        end

		return false
	end,
	OnCanRun = function(item)
		return item.player:IsCombine() and (IsValid(item.player:CalculateTrace(96).Entity) and item.player:CalculateTrace(96).Entity:GetClass() == "ix_apartlock")
	end
}


ITEM.functions.GetOwners = {
	name = "Get Tenants",
	tip = "useTip",
	icon = "icon16/arrow_right.png",
	OnRun = function(item)
        local client = item.player

        if IsValid(client) and client:IsCombine() then
            local target = client:CalculateTrace(96).Entity

            if IsValid(target) and target:GetClass() == "ix_apartlock" then
                local splitted = string.Split(target:GetOwners(), ';')
                if table.IsEmpty(splitted) then client:EmitSound("buttons/button16.wav") pl:Notify("Nobody owns this lock") end

                for _, owner in ipairs( splitted ) do
                    if tostring(owner) == "" then continue end
                    client:Notify("CID: #"..owner)
                end
            end
        end

		return false
	end,
	OnCanRun = function(item)
		return item.player:IsCombine() and (IsValid(item.player:CalculateTrace(96).Entity) and item.player:CalculateTrace(96).Entity:GetClass() == "ix_apartlock")
	end
}