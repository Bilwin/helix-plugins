
local Schema = Schema
local PLUGIN = PLUGIN
PLUGIN.name = 'Basic Schema Things'
PLUGIN.author = 'SV HL2 RP'

ix.util.Include 'sh_configs.lua'
ix.util.Include 'sh_commands.lua'
ix.util.Include 'sh_chatclasses.lua'

ix.util.Include 'cl_schema.lua'
ix.util.Include 'cl_hooks.lua'
ix.util.Include 'sh_hooks.lua'
ix.util.Include 'sh_voices.lua'
ix.util.Include 'sv_schema.lua'
ix.util.Include 'sv_hooks.lua'

ix.util.Include 'meta/sh_player.lua'
ix.util.Include 'meta/sv_player.lua'
ix.util.Include 'meta/sh_character.lua'

function Schema:ZeroNumber(number, length)
	local amount = math.max(0, length - string.len(number))
	return string.rep('0', amount)..tostring(number)
end

function Schema:IsCombineRank(text, rank)
	return string.find(text, '[%D+]'..rank..'[%D+]')
end

function Schema:ShuffleString(str)
	local letters = {}
	for letter in str:gmatch'.[\128-\191]*' do
	   table.insert(letters, {letter = letter, rnd = math.random()})
	end
	table.sort(letters, function(a, b) return a.rnd < b.rnd end)
	for i, v in ipairs(letters) do letters[i] = v.letter end
	return table.concat(letters)
end
