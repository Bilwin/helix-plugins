PLUGIN.name = "Clear Items"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Clean your map from garbage"
PLUGIN.schema = "Any"

if ( SERVER ) then
    util.AddNetworkString("ixClearItems::Notify")

    local ix = ix or {}
    ix.ClearItems = ix.ClearItems or {
        [ "ix_item" ]       = true,
        [ "ix_money" ]      = true,
        [ "ix_shipment" ]   = true
    }

    local function IsEmptyTable( t )
        return next( t ) == nil or false
    end

    local function clear()
        timer.Create("ixCleanMap", 60 * 10, 0, function()
            for _, v in pairs( ents.FindByClass( "*" ) ) do
                if ix.ClearItems[ v:GetClass() ] then
                    v:Remove()
                end
            end

            if !IsEmptyTable(ix.ClearItems) then
                net.Start("ixClearItems::Notify")
                net.Broadcast()
            end
        end)
    end

    function PLUGIN:InitPostEntity()
        clear()
    end
elseif (CLIENT) then
    net.Receive("ixClearItems::Notify", function()
        if ( LocalPlayer() ) then
            notification.AddLegacy("Map trash has been cleared")
        end
    end)
end
