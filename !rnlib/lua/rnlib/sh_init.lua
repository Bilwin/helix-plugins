
local file_Find = file.Find
local string_right = string.Right

rnlib.modules = rnlib.modules || {
    'utils',
    'math',
    'network',
    'http',
    'crypto',
    'ui',
    'performance',
    'meta'
}

do
    for _, dir in ipairs(rnlib.modules) do
        for _, file in ipairs(file_Find('rnlib/'..dir..'/*.lua','LUA')) do
            rnlib.i(dir..'/'..file)
            rnlib.p('%s | Loaded \'%s\' module', dir, string_right(file, #file - 3))
        end
    end
end
