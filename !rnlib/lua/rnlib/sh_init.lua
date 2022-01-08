
local file_Find = file.Find
local string_right = string.Right

rnlib.core = rnlib.core || {
    'utils',
    'math',
    'network',
    'http',
    'crypto',
    'ui',
    'performance'
}

function rnlib.LoadPath(tbl, formatted)
    for _, dir in ipairs(tbl) do
        local path = formatted(dir) -- may be slow
        for _, file in ipairs(file_Find(path,'LUA')) do
            rnlib.i(dir..'/'..file)
            rnlib.p('%s | Loaded \'%s\' module', dir, string_right(file, #file - 3))
        end
    end
end

rnlib.LoadPath(rnlib.core, function(dir)
    return Format('rnlib/%s/*.lua', dir)
end)
