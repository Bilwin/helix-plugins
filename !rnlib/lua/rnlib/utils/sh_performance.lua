
rnlib.performance = {}
local _PERFORMANCE = {}
_PERFORMANCE.__index = _PERFORMANCE

function rnlib.performance()
    local _PERF = {}
    setmetatable(_PERFORMANCE, _PERF)
    rnlib.p 'Caution! Use rnlib.performance only for function speed analysis!'
    return _PERFORMANCE
end

function _PERFORMANCE:RegisterStoredTable()
    self.stored = {}
    return self
end

function _PERFORMANCE:AddFunction(func)
    assert(isfunction(func), 'Invalid :AddFunction argument! Argument is '..type(func))
    self.stored[#self.stored+1] = func
    return self
end

function _PERFORMANCE:Execute()
    self.results = {}

    for index, func in ipairs(self.stored) do
        self.results[index] = {}
        self.results[index].startTime = os.clock()
        func()
        self.results[index].endTime = os.clock()
    end
    
    for index, value in ipairs(self.results) do
        rnlib.p('Index: %s; Speed: %.10f', index, value.endTime - value.startTime)
    end
end
