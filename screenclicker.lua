
PLUGIN.name = 'Screen clicker'
PLUGIN.author = 'Bilwin'
PLUGIN.description = 'Allows using screen clicker'

if (CLIENT) then
    local m_bScreenClickerEnabled = false
    function PLUGIN:PlayerButtonDown(me, button)
        if (button == KEY_F2) then
            if (IsFirstTimePredicted()) then
                if (m_flF2KeyCooldown or 0) < RealTime() then
                    local boolean = !m_bScreenClickerEnabled
                    gui.EnableScreenClicker(boolean)
                    m_flF2KeyCooldown = RealTime() + 0.1
                    m_bScreenClickerEnabled = boolean
                end
            end
        end
    end
end