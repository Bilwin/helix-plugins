PLUGIN.name         = 'Auto Walk'
PLUGIN.author       = 'NightAngel (Ported from Flux)'
PLUGIN.description  = 'Allows users to press a button to automatically walk forward.'
PLUGIN.button       = KEY_N

if SERVER then
    PLUGIN.check = {
        [IN_FORWARD]    = true,
        [IN_BACK]       = true,
        [IN_MOVELEFT]   = true,
        [IN_MOVERIGHT]  = true,
        [IN_JUMP]       = true
    }

    function PLUGIN:SetupMove(client, move_data, cmd_data)
        if not client:GetNetVar('auto_walk', false) then return end
        move_data:SetForwardSpeed(move_data:GetMaxSpeed())

        for k in pairs(self.check) do
            if cmd_data:KeyDown(k) then
                client:SetNetVar('auto_walk', false)
                break
            end
        end
    end

    concommand.Add('ix_toggleautowalk', function(client)
        if hook.Run('CanPlayerAutoWalk', client) ~= false then
            client:SetNetVar('auto_walk', not client:GetNetVar('auto_walk', false))
        end
    end)

    function PLUGIN:CanPlayerAutoWalk(client)
        return true
    end
else
    function PLUGIN:SetupMove(client, move_data, cmd_data)
        if not client:GetNetVar('auto_walk', false) then return end
        move_data:SetForwardSpeed(move_data:GetMaxSpeed())
    end

    function PLUGIN:PlayerButtonDown(client, button)
        if button == self.button then
            if (client.ixNextAWToggle || 0) > CurTime() then return end
            RunConsoleCommand('ix_toggleautowalk')
            client.ixNextAWToggle = CurTime() + 1
        end
    end
end