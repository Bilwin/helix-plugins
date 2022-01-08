
rnlib.data = rnlib.data || {}
rnlib.data.stored = rnlib.data.stored || {}

file.CreateDir('rnlib')

function rnlib.data.Set(key, value, bIgnoreMap)
	local path = 'rnlib/' .. (bIgnoreMap && '' || game.GetMap() .. '/')

	file.CreateDir(path)
	file.Write(path .. key .. '.txt', util.TableToJSON({value}))

	rnlib.data.stored[key] = value
	return path
end

function rnlib.data.Get(key, default, bIgnoreMap, bRefresh)
	if !bRefresh then
		local stored = rnlib.data.stored[key]

		if stored != nil then
			return stored
		end
	end

	local path = 'rnlib/' .. (bIgnoreMap && '' || game.GetMap() .. '/')
	local contents = file.Read(path .. key .. '.txt', 'DATA')

	if contents && contents != "" then
		local status, decoded = pcall(util.JSONToTable, contents)

		if status && decoded then
			local value = decoded[1]
			if value != nil then
				return value
			end
		end

		status, decoded = pcall(pon.decode, contents)
		if status && decoded then
			local value = decoded[1]
			if value != nil then
				return value
			end
		end
	end

	return default
end

function rnlib.data.Delete(key, bIgnoreMap)
	local path = 'rnlib/' .. (bIgnoreMap && '' || game.GetMap() .. '/')
	local contents = file.Read(path .. key .. '.txt', 'DATA')

	if contents && contents != '' then
		file.Delete(path .. key .. '.txt')
		rnlib.data.stored[key] = nil
		return true
	end

	return false
end

if SERVER then
	timer.Create('rnlibSaveData', 600, 0, function()
		hook.Run('SaveData')
	end)
end