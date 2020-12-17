local plugin = PLUGIN
plugin.name = "Extended Run Animation"
plugin.author = "AshraldRails / Bilwin"
plugin.description = "..."

local IsValid = IsValid
local os = os
local util = util

local weapon_whitelist = {
    ["ix_hands"] = true,
    ["ix_keys"] = true
}

-- Only PMs
local model_whitelist = {
	"models/player/Group01/male_01.mdl",
	"models/player/Group01/male_02.mdl",
	"models/player/Group01/male_03.mdl",
	"models/player/Group01/male_04.mdl",
	"models/player/Group01/male_05.mdl",
	"models/player/Group01/male_06.mdl",
	"models/player/Group01/male_07.mdl",
	"models/player/Group01/male_08.mdl",
	"models/player/Group01/male_09.mdl",
	"models/player/Group01/male_10.mdl",
	"models/player/Group01/male_11.mdl",

	"models/player/Group03/male_01.mdl",
	"models/player/Group03/male_02.mdl",
	"models/player/Group03/male_03.mdl",
	"models/player/Group03/male_04.mdl",
	"models/player/Group03/male_05.mdl",
	"models/player/Group03/male_06.mdl",
	"models/player/Group03/male_07.mdl",
	"models/player/Group03/male_08.mdl",
	"models/player/Group03/male_09.mdl",
	"models/player/Group03/male_10.mdl",
	"models/player/Group03/male_11.mdl",

	"models/player/Group03m/male_01.mdl",
	"models/player/Group03m/male_02.mdl",
	"models/player/Group03m/male_03.mdl",
	"models/player/Group03m/male_04.mdl",
	"models/player/Group03m/male_05.mdl",
	"models/player/Group03m/male_06.mdl",
	"models/player/Group03m/male_07.mdl",
	"models/player/Group03m/male_08.mdl",
	"models/player/Group03m/male_09.mdl",
	"models/player/Group03m/male_10.mdl",
	"models/player/Group03m/male_11.mdl"
}

hook.Add( "CalcMainActivity", "BaseAnimations", function( Player, Velocity )
    if not weapon_whitelist[Player:GetActiveWeapon():GetClass()] then return end
    if not table.HasValue(model_whitelist, Player:GetModel()) then return end
    if not Player.LastOnGround and not Player:OnGround() then
        Player.LastOnGround = true
    end
    if Player:IsOnGround() and Player.LastOnGround then
        Player:AddVCDSequenceToGestureSlot( GESTURE_SLOT_FLINCH, Player:LookupSequence("jump_land"), 0, true )
        Player.LastOnGround = false
    end
    Player.m_FistAttackIndex = Player.m_FistAttackIndex or Player:GetNW2Int("$fist_attack_index")
    if Player.m_FistAttackIndex ~= Player:GetNW2Int("$fist_attack_index") then
        Player.m_FistAttackIndex = Player:GetNW2Int("$fist_attack_index")
        Player:AddVCDSequenceToGestureSlot( 5, Player:LookupSequence("zombie_attack_0" .. ( ( Player.m_FistAttackIndex )% 7 + 1 )), 0.5, true )
    end
    if Player:IsOnGround() and Velocity:Length() > Player:GetRunSpeed() - 10 then
        return ACT_HL2MP_RUN_FAST, -1
    end
end)

local function RenderHook( Object )
	if not Object:IsPlayer() then return end
	if not Object.RenderOverride then
		Object.RenderOverride = function( self )
			if hook.Call("PlayerRender", nil, self ) == nil then
				self:DrawModel()
			end
		end
	end
end

hook.Add("NetworkEntityCreated", "HookOntoPlayerRender", RenderHook)
hook.Add("NetworkEntityCreated", "HookOntoPlayerRender", OnEntityCreated)