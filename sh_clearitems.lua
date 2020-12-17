PLUGIN.name = "Clear Items"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Clean your map from garbage"
PLUGIN.schema = "Any"

if (SERVER) then
    local ix = ix or {}
    ix.ClearItems = ix.ClearItems or {
        ["ix_item"] = true,
        ["ix_money"] = true,
        ["ix_shipment"] = true
    }

    local function clear()
        timer.Create("ixCleanMap", 60 * 10, 0, function()
            for _, v in pairs( ents.FindByClass("ix_*") ) do
                if ix.ClearItems[ v:GetClass() ] then
                    v:Remove()
                end
            end
        end)
    end

    function PLUGIN:InitPostEntity()
        clear()
    end
end