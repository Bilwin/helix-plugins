
PLUGIN.name         = 'Nodes'
PLUGIN.description  = 'Comment areas'
PLUGIN.author       = 'Bilwin'

function PLUGIN:SetupAreaProperties()
    ix.area.AddType('comment')
    ix.area.AddProperty('comment', ix.type.string, '')
end

if (CLIENT) then
    function PLUGIN:OnAreaChanged(oldID, newID)
        if LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP then return; end
        local storedData = ix.area.stored[newID]
        for id, data in pairs( ix.area.stored ) do
            if id == newID && data.type == 'comment' then
                hook.Run('EnteredCommentArea', data)
            end
        end
    end

    function PLUGIN:EnteredCommentArea(data)
        local text = data.properties.comment
        if text and text ~= '' then
            chat.AddText(color_white, text)
        end
    end
end
