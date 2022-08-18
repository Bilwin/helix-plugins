PLUGIN.name         = 'Screen clicker'
PLUGIN.author       = 'Bilwin'
PLUGIN.description  = 'Allows using screen clicker'
PLUGIN.button       = KEY_F2

if CLIENT then
    local Enabled = false
    local Cooldown
    function PLUGIN:PlayerButtonDown(_, button)
        if button == self.button && (Cooldown || 0) < CurTime() then
            gui.EnableScreenClicker(not Enabled)
            Cooldown = CurTime() + 0.1
            Enabled = not Enabled
        end
    end
end