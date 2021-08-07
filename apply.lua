
PLUGIN.name = "Adds /Apply command"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "Any"
PLUGIN.version = 1.0

if (SERVER) then
    function PLUGIN:Recognize(client, level)
		if (isnumber(level)) then
			local targets = {}

			if (level < 1) then
				local entity = client:GetEyeTraceNoCursor().Entity

				if (IsValid(entity) and entity:IsPlayer() and entity:GetCharacter()
				and ix.chat.classes.ic:CanHear(client, entity)) then
					targets[1] = entity
				end
			else
				local class = "w"

				if (level == 2) then
					class = "ic"
				elseif (level == 3) then
					class = "y"
				end

				class = ix.chat.classes[class]

				for _, v in ipairs(player.GetAll()) do
					if (client != v and v:GetCharacter() and class:CanHear(client, v)) then
						targets[#targets + 1] = v
					end
				end
			end

			if (#targets > 0) then
				local id = client:GetCharacter():GetID()
				local i = 0

				for _, v in ipairs(targets) do
					if (v:GetCharacter():Recognize(id)) then
						i = i + 1
					end
				end

				if (i > 0) then
					net.Start("ixRecognizeDone")
					net.Send(client)

					hook.Run("CharacterRecognized", client, id)
				end
			end
		end
    end

    function PLUGIN:RecognizeCharacter(client)
        return self:Recognize(client, 2)
    end
end

ix.command.Add("Apply", {
    description = "Introduce yourself",
    OnRun = function(self, client)
        if !client:GetCharacter() then return end
        local cid = client:GetCharacter():GetInventory():HasItem("cid")
        if (cid) then
            ix.chat.Send(client, 'ic', cid:GetData("name", "N/A") .. ", #" .. cid:GetData("id", "N/A"))
        else
            ix.chat.Send(client, 'ic', client:GetCharacter():GetName())
        end

        hook.Run("RecognizeCharacter", client)
    end
})