
PLUGIN.name = "Combine PDA"
PLUGIN.author = "Bilwin"
PLUGIN.description = "PDA for combine factions"
PLUGIN.version = "1.0"

ix.util.Include("sv_plugin.lua")

function PLUGIN:InitializedChatClasses()
    ix.command.Add("PDA", {
        description = "Включить отображение КПК.",
        OnCheckAccess = function(self, client)
            return client:IsCombine()
        end,
        OnRun = function(self, client)
            netstream.Start(client, "ixOpenPDA")
        end
    })

    ix.command.Add("ViewObjectives", {
        description = '',
        OnCheckAccess = function(self, client)
            return false
        end,
        OnRun = function(self, client)
        end
    })
end

if CLIENT then
    netstream.Hook("ixOpenPDA", function(objectives)
        PDAObjectives = objectives
        if IsValid(ix.gui.pdamainmenu) then
            ix.gui.pdamainmenu:Remove()
        else
            local frame = vgui.Create('PDAMainMenu')
            frame:SetPos(-ScrW(), ScrH() / 2 - frame:GetTall() / 2)
            frame:MoveTo(5, (ScrH()*.5) - frame:GetTall()/2, 0.5, 0, -1)
        end
    end)
end

if SERVER then
    function PLUGIN:ShowHelp(client)
        if client:IsCombine() then
            netstream.Start(client, "ixOpenPDA", Schema.CombineObjectives)
        end
    end
end