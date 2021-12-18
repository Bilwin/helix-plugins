
--[[ Example
local dump = rnlib.dump.Register('test')
dump:RegisterStoredTable()
dump:AddValue(function(some_arg)
    print(some_arg)
    debug.Trace()
end)
dump:Execute(1, 'test')
--]]

rnlib.dump = {}
local _DUMPER = {}
_DUMPER.__index = _DUMPER

function rnlib.dump.Register()
    local _DUMP = {}
    rnlib.dump[#rnlib.dump+1] = _DUMPER
    setmetatable(_DUMPER, _DUMP)
    return _DUMPER
end

function _DUMPER:RegisterStoredTable()
    self.stored = {}
end

function _DUMPER:AddValue(value)
    self.stored[#self.stored+1] = value
    return self
end

function _DUMPER:GetValue(index)
    return self.stored[index]
end

function _DUMPER:OverrideValue(index, value)
    self.stored[index] = value
    return self
end

function _DUMPER:GetStored()
    return self.stored
end

function _DUMPER:Wipe()
    self.stored = nil
end

function _DUMPER:Execute(index, ...)
    if isfunction(self.stored[index]) then
        self.stored[index](...)
    else
        rnlib.p('%s is not a function!', self.id)
    end
end