PLUGIN.name         = 'Third-person view bind'
PLUGIN.description  = 'Allows you toggle third-person view using bind'
PLUGIN.author       = 'Bilwin'
PLUGIN.button       = KEY_P

if CLIENT then
    local Cooldown
    function PLUGIN:PlayerButtonDown(_, button)
        if button == self.button && (Cooldown || 0) < CurTime() then
            RunConsoleCommand('ix_togglethirdperson')
            Cooldown = CurTime() + 0.1
        end
    end
end