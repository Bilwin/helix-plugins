PLUGIN.name     = 'Third-person double step fix'
PLUGIN.author   = 'Bilwin'

if CLIENT then
    local steps = {'.stepleft', '.stepright'}
    function PLUGIN:EntityEmitSound(data)
        if not ix.option.Get('thirdpersonEnabled', false) then return end
        if not IsValid(data.Entity) && not data.Entity:IsPlayer() then return end

        local sName = data.OriginalSoundName
        if sName:find(steps[1]) || sName:find(steps[2]) then
            return false
        end
    end
end
