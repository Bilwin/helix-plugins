
local PLUGIN = PLUGIN
local GAMEMODE = GAMEMODE or GM
local pk_pills = pk_pills or {}
PLUGIN.name = "Emote Moods"
PLUGIN.author = "DrodA (Ported from NS)"
PLUGIN.description = "With this plugin, characters can set their mood."
PLUGIN.schema = "Any"
PLUGIN.version = 1.1

do
    MOOD_NONE = 0
    MOOD_RELAXED = 1
    MOOD_FRUSTRATED = 3
    MOOD_MODEST = 4

    PLUGIN.MoodTextTable = {
        [MOOD_NONE] = "Default",
        [MOOD_RELAXED] = "Relaxed",
        [MOOD_FRUSTRATED] = "Frustrated",
		[MOOD_MODEST] = "Modest"
    }

    PLUGIN.MoodBadMovetypes = {
        [MOVETYPE_FLY] = true,
        [MOVETYPE_LADDER] = true,
        [MOVETYPE_NOCLIP] = true
    }

    PLUGIN.MoodAnimTable = {
        [MOOD_RELAXED] = {
            [0] = "LineIdle01",
            [1] = "walk_all_Moderate"
        },
        [MOOD_FRUSTRATED] = {
            [0] = "LineIdle02",
            [1] = "pace_all"
        },
		[MOOD_MODEST] = {
			[0] = "LineIdle04",
			[1] = "plaza_walk_all"
		}
    }
end

do
	local meta = FindMetaTable("Player")
	
	function meta:GetMood()
		return self:GetNetVar("mood") or MOOD_NONE
	end

	if (SERVER) then
		function meta:SetMood(int)
			int = int or 0
			self:SetNetVar("mood", int)
		end
	end
end

if (SERVER) then
	function PLUGIN:PlayerLoadedCharacter(client, character)
		client:SetMood(MOOD_NONE)
	end
end

do
	local COMMAND = {}
	COMMAND.description = "Set your own mood"
	COMMAND.arguments = {
		ix.type.number
	}

	function COMMAND:OnRun(client, mood)
		mood = math.Clamp(mood, 0, MOOD_MODEST)
		client:SetMood(mood)
	end

	ix.command.Add("Mood", COMMAND)

    local tblWorkaround = {["ix_keys"] = true, ["ix_hands"] = true}
	function PLUGIN:CalcMainActivity(client, velocity)
        local length = velocity:Length2DSqr()
        local clientInfo = client:GetTable()

		local mood = client:GetMood()
		local pkExist = pcall(pk_pills.getMappedEnt, client)
		local pkpill
		if pkExist then
			pkpill = pk_pills.getMappedEnt(client)
		end

		if (IsValid(pkpill)) then return end

		if (client and IsValid(client) and client:IsPlayer()) then
			if (!client:IsWepRaised() and !client:Crouching() and IsValid(client:GetActiveWeapon()) and tblWorkaround[client:GetActiveWeapon():GetClass()] and !client:InVehicle() and mood > 0 and !self.MoodBadMovetypes[client:GetMoveType()] and !client.m_bJumping and client:IsOnGround()) then
				if length < 0.25 then
					clientInfo.CalcSeqOverride = self.MoodAnimTable[mood][0] and client:LookupSequence(self.MoodAnimTable[mood][0]) or clientInfo.CalcSeqOverride
				elseif length > 0.25 and length < 22500 then
					clientInfo.CalcSeqOverride = self.MoodAnimTable[mood][1] and client:LookupSequence(self.MoodAnimTable[mood][1]) or clientInfo.CalcSeqOverride
				end
			end
		end
	end
end
