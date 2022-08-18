
local PLUGIN = PLUGIN
PLUGIN.name = 'SV User Interface'
PLUGIN.author = "Bilwin"
PLUGIN.description = "UI for SV"

if (CLIENT) then
    local hookRun = hook.Run
    timer.Simple(FrameTime() * bit.lshift(2, 2), function()
        local aimLength = 0.35
        local aimTime = 0
        local aimEntity
        local lastEntity
        local lastTrace = {}

        timer.Remove("ixCheckTargetEntity")
        timer.Create("ixCheckTargetEntity", 0.1, 0, function()
            local client = LocalPlayer()
            local time = SysTime()

            if (!IsValid(client)) then
                return
            end

            local character = client:GetCharacter()

            if (!character) then
                return
            end

            lastTrace.start = client:GetShootPos()
            lastTrace.endpos = lastTrace.start + client:GetAimVector(client) * 160
            lastTrace.filter = client
            lastTrace.mask = MASK_SHOT_HULL

            lastEntity = util.TraceHull(lastTrace).Entity

            if (lastEntity != aimEntity) then
                aimTime = time + aimLength
                aimEntity = lastEntity
            end

            local panel = ix.gui.entityInfo
            local bShouldShow = time >= aimTime and (!IsValid(ix.gui.menu) or ix.gui.menu.bClosing) and
                (!IsValid(ix.gui.characterMenu) or ix.gui.characterMenu.bClosing)
            local bShouldPopulate = lastEntity.OnShouldPopulateEntityInfo and lastEntity:OnShouldPopulateEntityInfo() or true

            if (bShouldShow and IsValid(lastEntity) and hookRun("ShouldPopulateEntityInfo", lastEntity) != false and
                (lastEntity.PopulateEntityInfo or bShouldPopulate)) then

                if (!IsValid(panel) or (IsValid(panel) and panel:GetEntity() != lastEntity)) then
                    if (IsValid(ix.gui.entityInfo)) then
                        ix.gui.entityInfo:Remove()
                    end

                    local infoPanel = vgui.Create"ixTooltipMinimal"
                    local entityPlayer = lastEntity:GetNetVar("player")

                    if (entityPlayer) then
                        infoPanel:SetEntity(entityPlayer)
                        infoPanel.entity = lastEntity
                    else
                        infoPanel:SetEntity(lastEntity)
                    end

                    infoPanel:SetDrawArrow(true)
                    ix.gui.entityInfo = infoPanel
                end
            elseif (IsValid(panel)) then
                panel:Remove()
            end
        end)
    end)
end

ix.util.Include("cl_skin.lua")