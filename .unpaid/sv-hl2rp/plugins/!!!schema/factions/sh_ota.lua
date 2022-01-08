
FACTION.name = "OTA"
FACTION.description = "A transhuman Overwatch soldier produced by the Combine."
FACTION.color = Color(150, 50, 50, 255)
FACTION.pay = 40
FACTION.models = {"models/combine_soldier.mdl"}
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.runSounds = {[0] = "NPC_CombineS.RunFootstepLeft", [1] = "NPC_CombineS.RunFootstepRight"}
FACTION.radioChannels = {"cmb", "ota"}
FACTION.npcRelations = {
	["npc_alyx"] = D_HT,
	["npc_barney"] = D_HT,
	["npc_citizen"] = D_HT,
	["npc_dog"] = D_HT,
	["npc_magnusson"] = D_HT,
	["npc_kleiner"] = D_HT,
	["npc_mossman"] = D_HT,
	["npc_eli"] = D_HT,
	["npc_fisherman"] = D_HT,
	["npc_gman"] = D_NU,
	["Medic"] = D_HT,
	["npc_odessa"] = D_HT,
	["Rebel"] = D_HT,
	["Refugee"] = D_HT,
	["VortigauntUriah"] = D_HT,
	["npc_vortigaunt"] = D_HT,
	["VortigauntSlave"] = D_HT,

	["npc_zombie"] = D_HT,
	["npc_poisonzombie"] = D_HT,
	["npc_zombie_torso"] = D_HT,
	["npc_headcrab_black"] = D_HT,
	["npc_headcrab"] = D_HT,
	["npc_fastzombie_torso"] = D_HT,
	["npc_fastzombie"] = D_HT,
	["npc_headcrab_fast"] = D_HT,
	["npc_barnacle"] = D_HT,
	["npc_antlion_worker"] = D_HT,
	["npc_antlionguardian"] = D_HT,
	["npc_antlionguard"] = D_HT,
	["npc_antlion"] = D_HT,
	["npc_zombine"] = D_HT,
	["npc_resturret02"] = D_HT,
	["npc_resturret03"] = D_HT,
	["npc_resturret01"] = D_HT,

	["npc_breen"] = D_LI,
	["npc_stalker"] = D_LI,
	["npc_cscanner"] = D_LI,
	["npc_combine_camera"] = D_LI,
	["npc_turret_ceiling"] = D_LI,
	["npc_combinegunship"] = D_LI,
	["CombineElite"] = D_LI,
	["npc_combine_s"] = D_LI,
	["npc_hunter"] = D_LI,
	["npc_helicopter"] = D_LI,
	["npc_manhack"] = D_LI,
	["npc_metropolice"] = D_LI,
	["CombinePrison"] = D_LI,
	["PrisonShotgunner"] = D_LI,
	["npc_rollermine"] = D_LI,
	["npc_clawscanner"] = D_LI,
	["ShotgunSoldier"] = D_LI,
	["npc_strider"] = D_LI,
	["npc_turret_floor"] = D_LI,
	["npc_turret_ground"] = D_LI,
	["npc_sniper"] = D_LI
}

function FACTION:OnCharacterCreated(client, character)
end

function FACTION:GetDefaultName(client)
	return "OTA-ECHO.OWS", true
end

function FACTION:OnTransfered(client)
	local character = client:GetCharacter()

	character:SetName(self:GetDefaultName())
	character:SetModel(self.models[1])
end

function FACTION:OnNameChanged(client, oldValue, value)
	local character = client:GetCharacter()

	if (!Schema:IsCombineRank(oldValue, "OWS") and Schema:IsCombineRank(value, "OWS")) then
		character:JoinClass(CLASS_OWS)
	elseif (!Schema:IsCombineRank(oldValue, "EOW") and Schema:IsCombineRank(value, "EOW")) then
		character:JoinClass(CLASS_EOW)
	end
end

FACTION_OTA = FACTION.index
