PLUGIN.name 		= 'Third-person blocker'
PLUGIN.description 	= 'Block a third-person view when taking damage'
PLUGIN.author 		= 'Bilwin'

if CLIENT then
    gameevent.Listen('player_hurt')
    hook.Add('player_hurt', PLUGIN.name, function(data)
        if data.userid == LocalPlayer():UserID() then
            LocalPlayer().m_bThirdPersonBlocked = true
            if timer.Exists('tpBlocker') then timer.Remove('tpBlocker') end
            timer.Create('tpBlocker', 30, 1, function()
                LocalPlayer().m_bThirdPersonBlocked = false
            end)
        end
    end)

	local function isAllowed()
		return ix.config.Get('thirdperson')
	end

    function PLAYER:CanOverrideView()
		local entity = Entity(self:GetLocalVar('ragdoll', 0))

		if IsValid(ix.gui.characterMenu) && !ix.gui.characterMenu:IsClosing() && ix.gui.characterMenu:IsVisible() then
			return false
		end

		if IsValid(ix.gui.menu) && ix.gui.menu:GetCharacterOverview() then
			return false
		end

		if (ix.option.Get('thirdpersonEnabled', false) &&
			!IsValid(self:GetVehicle()) &&
			isAllowed() &&
			IsValid(self) &&
			self:GetCharacter() &&
			!self:GetNetVar 'actEnterAngle' &&
			!IsValid(entity) &&
			LocalPlayer():Alive() &&
            !LocalPlayer().m_bThirdPersonBlocked
			) then
			return true
		end
	end
end