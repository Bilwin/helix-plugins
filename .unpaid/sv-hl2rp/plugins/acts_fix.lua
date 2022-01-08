
PLUGIN.name = 'Acts Rework'
PLUGIN.author = 'Bilwin'

local function FacingWall(client)
	local data = {}
	data.start = client:EyePos()
	data.endpos = data.start + client:GetForward() * 20
	data.filter = client

	if !util.TraceLine(data).Hit then
		return '@faceWall'
	end
end

local function FacingWallBack(client)
	local data = {}
	data.start = client:LocalToWorld(client:OBBCenter())
	data.endpos = data.start - client:GetForward() * 20
	data.filter = client

	if !util.TraceLine(data).Hit then
		return '@faceWallBack'
	end
end

local blacklist_ents = {
	['func_door'] = true,
	['func_door_rotating'] = true,
	['prop_door_rotating'] = true,
	['func_movelinear'] = true
}

local function IsBugging(client)
	local nearEnts = ents.FindInSphere(client:GetPos(), 70)
	local bStatus = true

	for _, ent in ipairs(nearEnts) do	-- ipairs: num
		if blacklist_ents[ent:GetClass()] then
			bStatus = false
			break
		end
	end

 	if !bStatus then
		return "@notNow"
	end
end

function PLUGIN:SetupActs()
	ix.act.Remove("Arrest")
	ix.act.Register("Arrest", "citizen_male", {
		sequence = {
			{"arrestidle", check = IsBugging}
		},
		untimed = true
	})

	ix.act.Register("Kneel", "citizen_male", {
		start = {"d1_town05_daniels_kneel_entry"},
		sequence = {"d1_town05_daniels_kneel_idle"},
		untimed = true,
		idle = true
	})

	ix.act.Register("Chair", {"citizen_male", "citizen_female"}, {
		sequence = {"sitchair1"},
		untimed = true
	})

	ix.act.Register("Stand", "player", {
		sequence = {
			{"lineidle01", check = IsBugging},
			{"lineidle02", check = IsBugging},
			{"lineidle03", check = IsBugging}
		},
		untimed = true,
		idle = true
	})

	ix.act.Register("Injured", "player", {
		sequence = {
			{"d1_town05_wounded_idle_1", check = IsBugging},
			{"d1_town05_wounded_idle_2", check = IsBugging},
			{"d1_town05_winston_down", check = IsBugging}
		},
		untimed = true,
		idle = true
	})

	ix.act.Register("ArrestWall", "player", {
		sequence = {
			{"apcarrestidle",
			check = FacingWall, IsBugging,
			offset = function(client)
				return -client:GetForward() * 23
			end},
			"spreadwallidle"
		},
		untimed = true
	})

	ix.act.Register("Arrest", "player", {
		sequence = {
			{"arrestidle", check = IsBugging}
		},
		untimed = true
	})

	ix.act.Register("Sit", "player", {
		start = {"idle_to_sit_ground", "idle_to_sit_chair"},
		sequence = {
			{"sit_ground", check = IsBugging},
			{"sit_chair", check = IsBugging}
		},
		finish = {
			{"sit_ground_to_idle", duration = 2.1},
			""
		},
		untimed = true,
		idle = true
	})
end