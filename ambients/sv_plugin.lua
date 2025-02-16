util.AddNetworkString('ixEnableAmbients')

function PLUGIN:PlayerLoadedCharacter(client, _, _)
    net.Start('ixEnableAmbients', true)
        net.WriteBool( ix.config.Get('enableAmbients', false) )
    net.Send(client)
end