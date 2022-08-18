
function PLAYER:IsCombine()
	local faction = self:Team()
	return faction == FACTION_MPF or faction == FACTION_OTA
end

function PLAYER:IsDispatch()
	local name = self:Name()
	local faction = self:Team()
	local bStatus = faction == FACTION_OTA

	if (!bStatus) then
		for k, v in ipairs({ "SCN", "DvL", "SeC" }) do
			if (Schema:IsCombineRank(name, v)) then
				bStatus = true

				break
			end
		end
	end

	return bStatus
end

function PLAYER:CalculateTrace(size)
	local data = {}
		data.start = self:GetShootPos()
		data.endpos = data.start + self:GetAimVector() * size
		data.filter = self
	return util.TraceLine(data)
end
