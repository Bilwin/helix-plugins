
local Schema = Schema
function Schema:AddCombineDisplayMessage(text, color, ...)
	if (LocalPlayer():IsCombine() and IsValid(ix.gui.combine)) then
		ix.gui.combine:AddLine(text, color, nil, ...)
	end
end

netstream.Hook("CombineDisplayMessage", function(text, color, arguments)
	if (IsValid(ix.gui.combine)) then
		ix.gui.combine:AddLine(text, color, nil, unpack(arguments))
	end
end)

netstream.Hook("PlaySound", function(sound)
	surface.PlaySound(sound)
end)

netstream.Hook("HeavyPlaySound", function(ent, sounds, delay, spacing, volume, pitch)
	ix.util.EmitQueuedSounds(ent, sounds, delay, spacing, volume, pitch)
end)

netstream.Hook("ChatNotify", function(text, color, icon)
	if !color then color = color_white end
	if !icon then
		chat.AddText(color, text)
	else
		local icon = ix.util.GetMaterial(icon)
		chat.AddText(icon, color, text)
	end
end)

netstream.Hook("HeavyChatNotify", function(data, color, icon)
	if !color then color = color_white end
	if !icon then
		for _, message in ipairs(data) do
			chat.AddText(color, message)
		end
	else
		local icon = ix.util.GetMaterial(icon)
		for _, message in ipairs(data) do
			chat.AddText(icon, color, message)
		end
	end
end)

netstream.Hook("Frequency", function(oldFrequency)
	Derma_StringRequest("Частота", "Какую частоту вы хотите установить?", oldFrequency, function(text)
		ix.command.Send("SetFreq", text)
	end)
end)
