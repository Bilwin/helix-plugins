--[[
	© 2021 PostBellum HL2 RP
	Author: TIMON_Z1535 - https://steamcommunity.com/profiles/76561198047725014

	Repository: https://github.com/TIMONz1535/map_logic_controller
	Wiki: https://github.com/TIMONz1535/map_logic_controller/wiki
--]]
-- luacheck: globals ENT IsValid isnumber isfunction isstring istable ents timer game engine hook
-- luacheck: globals MsgN CreateConVar concommand FCVAR_NONE SysTime

local META_TARGET = {}

-- Redirect the function call to internal entities.
META_TARGET.__index = function(self, key)
	if isnumber(key) then
		return
	end

	assert(#self ~= 0, ("no entities with name '%s', can't redirect method '%s'"):format(self.name, key))

	return function(_, ...)
		for _, v in ipairs(self) do
			if IsValid(v) then
				if not isfunction(v[key]) then
					local info = ("entity '%s' (%s)"):format(self.name, v:GetClass())
					error(("%s doesn't have a method '%s'"):format(info, key))
				end
				v[key](v, ...)
			end
		end
	end
end

-- Add output to internal entities that will be called on Lua-side by the controller.
META_TARGET.__newindex = function(self, output, func)
	assert(#self ~= 0, ("no entities with name '%s', can't add output '%s'"):format(self.name, output))
	assert(IsValid(self.controller), ("invalid controller, can't add output '%s' for '%s'"):format(output, self.name))

	for _, v in ipairs(self) do
		if IsValid(v) then
			v.mapLogic = v.mapLogic or {}
			local prevFunc = v.mapLogic[output]
			v.mapLogic[output] = func

			-- Don't call another AddOutput if we're just overriding a Lua function.
			if not prevFunc then
				self.controller.statsOutputs = self.controller.statsOutputs + 1

				-- To support the generated output values (like Position), leave the 'parameter' empty.
				v:Input(
					"AddOutput",
					self.controller,
					self.controller,
					("%s %s:__%s::0:-1"):format(output, self.controller:GetName(), output)
				)
			end
		end
	end
end

-- generates a unique id even if you call many times per second
local lastId = 0
local function GenerateSysId()
	lastId = math.max(lastId + 1, math.floor(SysTime()))
	return lastId
end

-- ====================================================================================================

local map_logic_override =
	CreateConVar(
	"map_logic_override",
	"",
	FCVAR_NONE,
	"Overrides map name for which the controller will initialize the logic."
)

ENT.Base = "base_point"
ENT.Type = "point"

function ENT:AcceptInput(input, activator, caller, value)
	if input:sub(1, 2) == "__" then
		local output = input:sub(3)

		-- currently there is no way to determine who is calling output
		assert(IsValid(caller), ("invalid caller for output '%s'"):format(output))
		assert(not caller:IsPlayer(), ("engine returns Player as caller for output '%s'"):format(output))

		if not istable(caller.mapLogic) then
			local info = ("entity '%s' (%s)"):format(caller:GetName(), caller:GetClass())
			error(("no mapLogic table in %s for calling the Lua-side output '%s'"):format(info, output))
		end

		local func = caller.mapLogic[output]
		if not func then
			local info = ("entity '%s' (%s)"):format(caller:GetName(), caller:GetClass())
			error(("no output function '%s' in mapLogic table of %s"):format(output, info))
		end

		func(caller, activator, value)
		return true
	end
end

function ENT:GetMetaTarget(name)
	local entities
	if isstring(name) then
		assert(self.cache, ("no cache in controller, can't get MetaTarget for '%s'"):format(name))
		entities = self.cache[name] or {}
	else
		entities = {name}
		name = name:GetName()
	end

	self.statsEntities = self.statsEntities + #entities

	entities.name = name
	entities.controller = self
	return setmetatable(entities, META_TARGET)
end

function ENT:CacheEntNames()
	local cache = {}
	for _, v in ipairs(ents.GetAll()) do
		local name = v:GetName()
		if name ~= "" then
			cache[name] = cache[name] or {}
			table.insert(cache[name], v)
		end
	end
	self.cache = cache
end

function ENT:InitializeLogic()
	self:CacheEntNames()
	self:SetName("map_logic_controller" .. GenerateSysId())

	local mapName = map_logic_override:GetString()
	if mapName == "" then
		mapName = game.GetMap()
	end

	self.statsEntities = 0
	self.statsOutputs = 0
	hook.Run("OnMapLogicInitialized", self, mapName)
	self.cache = nil

	-- Map is not configured, the controller is useless.
	if self.statsEntities == 0 and self.statsOutputs == 0 then
		MsgN("[MapLogic] No logic for '", mapName, "', controller will be removed...")
		self:Remove()
		return
	end

	MsgN(
		"[MapLogic] Initialized successfully for '",
		mapName,
		"' (affected entities: ",
		self.statsEntities,
		", added outputs: ",
		self.statsOutputs,
		")"
	)
	self.statsEntities = nil
	self.statsOutputs = nil
end

function ENT:Initialize()
	-- Wait for second frame because OnRemove is executed in next frame.
	-- Also it allows you rename map entities in InitPostEntity.
	local delay = engine.TickInterval() * 2
	self:TimerSimple(delay, self.InitializeLogic)
end

function ENT:OnRemove()
	for _, v in ipairs(ents.GetAll()) do
		if v.mapLogic then
			v.mapLogic = nil
		end
	end
end

-- helper function to avoid copy-paste
function ENT:TimerSimple(time, func)
	timer.Simple(time, function()
		if IsValid(self) then
			func(self)
		end
	end)
end

-- ====================================================================================================

hook.Add("InitPostEntity", "MapLogicSpawn", function()
	local ent = ents.Create("map_logic_controller")
	ent:Spawn()
end)

concommand.Add("map_logic_reset", function(ply)
	if IsValid(ply) and not ply:IsSuperAdmin() then
		return
	end

	for _, v in ipairs(ents.FindByClass("map_logic_controller")) do
		v:Remove()
	end

	local ent = ents.Create("map_logic_controller")
	ent:Spawn()
end, nil, "Removes the old controller and creates a new one. Forces the entire map logic to be initialized again.")