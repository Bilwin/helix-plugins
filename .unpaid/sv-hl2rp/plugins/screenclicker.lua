
PLUGIN.name = 'Screen clicker'
PLUGIN.author = 'Bilwin'
PLUGIN.description = 'Allows using screen clicker'
PLUGIN.bind = KEY_F2

if CLIENT then
    local Enabled = false
    local Cooldown
    function PLUGIN:PlayerButtonDown(me, button)
        if button == self.bind then
            if IsFirstTimePredicted() then
                if (Cooldown || 0) < CurTime() then
                    gui.EnableScreenClicker(!Enabled)
                    Cooldown = CurTime() + 0.1
                    Enabled = !Enabled
                end
            end
        end
    end
end