
function PLAYER:AddCombineDisplayMessage(text, color, ...)
	if (self:IsCombine()) then
		netstream.Start(self, "CombineDisplayMessage", text, color or false, {...})
	end
end

function PLAYER:PlaySound(sound)
	netstream.Start(self, "PlaySound", sound)
end