
local PLUGIN = PLUGIN
PLUGIN.name = 'Apartments'
PLUGIN.description = 'Adds apartments lockers and features'
PLUGIN.author = 'Bilwin'
PLUGIN.schema = 'HL2 RP'

local PL = FindMetaTable("Player")
function PL:CalculateTrace(size)
	local data = {}
		data.start = self:GetShootPos()
		data.endpos = data.start + self:GetAimVector() * size
		data.filter = self
	return util.TraceLine(data)
end

ix.util.Include('sv_hooks.lua')