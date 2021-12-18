
local util_PrecacheModel, util_PrecacheSound = util.PrecacheModel, util.PrecacheSound
rnlib.caching = rnlib.caching || {}
rnlib.caching.models = rnlib.caching.models || {}
rnlib.caching.sounds = rnlib.caching.sounds || {}
rnlib.caching.materials = rnlib.caching.materials || {}

function rnlib.caching.AddModel(modelName)
    if #rnlib.caching.models >= 4096 then error'max caching models! ~4096' return end
    rnlib.caching.models[#rnlib.caching.models + 1] = modelName
end

function rnlib.caching.AddSound(soundName)
    if #rnlib.caching.models >= 16384 && SERVER then error'max caching sounds! ~16384' return end
    rnlib.caching.sounds[#rnlib.caching.sounds + 1] = soundName
end

function rnlib.caching.AddMaterial(materialName)
    rnlib.caching.materials[#rnlib.caching.materials + 1] = materialName
end

function rnlib.caching.Execute()
    rnlib.p 'Caching...'

    for _, v in ipairs(rnlib.caching.models) do
        util_PrecacheModel(v)
        rnlib.p('Cached \'%s\' model', v)
    end

    for _, v in ipairs(rnlib.caching.sounds) do
        util_PrecacheSound(v)
        rnlib.p('Cached \'%s\' sound', v)
    end

    for _, v in ipairs(rnlib.caching.materials) do
        PrecacheMaterial(v)
        rnlib.p('Cached \'%s\' material', v)
    end

    rnlib.p 'Successfully cached models and sounds!'
    rnlib.p 'If you have issues like broken models, run `r_flushlod` command to checksum it again.'
end

rnlib.caching.materials = rnlib.caching.materials || {}
local oldMaterial = oldMaterial || Material
function Material(materialName, pngParams)
    if !rnlib.caching.materials[materialName] then
        pngParams = pngParams || 'nil'
        rnlib.caching.materials[materialName] = oldMaterial(materialName, pngParams)
    end
    return rnlib.caching.materials[materialName]
end

function PrecacheMaterial(materialName, pngParams)
    pngParams = pngParams || 'nil'
    rnlib.caching.materials[materialName] = oldMaterial(materialName, pngParams)
end

hook.Add('InitPostEntity', 'rnlib.Precaching', function()
    rnlib.caching.Execute()
end)