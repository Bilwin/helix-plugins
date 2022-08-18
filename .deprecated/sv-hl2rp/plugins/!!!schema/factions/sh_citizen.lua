
FACTION.name = "Гражданин"
FACTION.description = "A regular human citizen enslaved by the Universal Union."
FACTION.color = Color(150, 125, 100, 255)
FACTION.isDefault = true
FACTION.npcRelations = {
	["npc_alyx"] = D_NU,
	["npc_barney"] = D_NU,
	["npc_citizen"] = D_NU,
	["npc_dog"] = D_NU,
	["npc_magnusson"] = D_NU,
	["npc_kleiner"] = D_NU,
	["npc_mossman"] = D_NU,
	["npc_eli"] = D_NU,
	["npc_fisherman"] = D_NU,
	["npc_gman"] = D_NU,
	["Medic"] = D_NU,
	["npc_odessa"] = D_NU,
	["Rebel"] = D_NU,
	["Refugee"] = D_NU,
	["VortigauntUriah"] = D_NU,
	["npc_vortigaunt"] = D_NU,
	["VortigauntSlave"] = D_NU,

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

	["npc_resturret02"] = D_FR,
	["npc_resturret03"] = D_FR,
	["npc_resturret01"] = D_FR,

	["npc_breen"] = D_NU,
	["npc_cscanner"] = D_FR,
	["npc_combine_camera"] = D_FR,
	["npc_turret_ceiling"] = D_HT,
	["npc_combinegunship"] = D_FR,
	["CombineElite"] = D_HT,
	["npc_combine_s"] = D_HT,
	["npc_hunter"] = D_FR,
	["npc_helicopter"] = D_FR,
	["npc_manhack"] = D_FR,
	["npc_metropolice"] = D_NU,
	["CombinePrison"] = D_HT,
	["PrisonShotgunner"] = D_HT,
	["npc_rollermine"] = D_HT,
	["npc_clawscanner"] = D_HT,
	["ShotgunSoldier"] = D_HT,
	["npc_strider"] = D_HT,
	["npc_turret_floor"] = D_HT,
	["npc_turret_ground"] = D_HT,
	["npc_sniper"] = D_HT
}

function FACTION:OnCharacterCreated(client, character)
	local id = Schema:ZeroNumber(math.random(1, 99999), 5)
	local inventory = character:GetInventory()

	character:SetCID(id)
	inventory:Add("suitcase", 1)
	inventory:Add("cid", 1, {
		name = character:GetName(),
		id = id
	})
end

FACTION_CITIZEN = FACTION.index
