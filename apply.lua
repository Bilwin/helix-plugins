PLUGIN.name 	= 'Adds /Apply command'
PLUGIN.author 	= 'Bilwin'

ix.command.Add('Apply', {
    description = 'Introduce yourself',
    OnRun = function(_, client)
        if not client:GetCharacter() then return end
        local cid = client:GetCharacter():GetInventory():HasItem('cid')

        if cid then
            ix.chat.Send(client, 'ic', cid:GetData('name', 'N/A') .. ', #' .. cid:GetData('id', 'N/A'))
        else
            ix.chat.Send(client, 'ic', client:GetCharacter():GetName())
        end

        hook.Run('RecognizeCharacter', client)
    end
})

if SERVER then
    function PLUGIN:Recognize(client, level)
		if type(level) ~= 'number' then return end
		local targets = {}

		if level < 1 then
			local entity = client:GetEyeTraceNoCursor().Entity

			if (IsValid(entity) && entity:IsPlayer() && entity:GetCharacter()
			&& ix.chat.classes.ic:CanHear(client, entity)) then
				targets[1] = entity
			end
		else
			local class = 'w'

			if level == 2 then
				class = 'ic'
			elseif level == 3 then
				class = 'y'
			end

			class = ix.chat.classes[class]

			for _, v in ipairs(player.GetAll()) do
				if client ~= v && v:GetCharacter() && class:CanHear(client, v) then
					targets[#targets + 1] = v
				end
			end
		end

		if #targets > 0 then
			local id = client:GetCharacter():GetID()
			local i = 0

			for _, v in ipairs(targets) do
				if v:GetCharacter():Recognize(id) then
					i = i + 1
				end
			end

			if i > 0 then
				net.Start('ixRecognizeDone')
				net.Send(client)

				hook.Run('CharacterRecognized', client, id)
			end
		end
    end

    function PLUGIN:RecognizeCharacter(client)
        return self:Recognize(client, 2)
    end
end