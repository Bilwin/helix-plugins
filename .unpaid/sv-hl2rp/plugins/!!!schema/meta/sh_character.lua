
local CHAR = ix.meta.character

function CHAR:IsCombine()
	local faction = self:GetFaction()
	return faction == FACTION_MPF or faction == FACTION_OTA
end

function CHAR:GetCID()
	self:GetData("cid")
end

if (SERVER) then
	function CHAR:SetCID(value)
		self:SetData("cid", value)
	end
end