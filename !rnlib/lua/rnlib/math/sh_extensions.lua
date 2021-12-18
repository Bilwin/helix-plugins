
if CLIENT then
	function VerticalScale(size)
		return size * (ScrH() / 480.0)
	end
	VScale = VerticalScale
	
	function ScreenScaleMin(size)
		return math.min(SScale(size), VScale(size))
	end
	SScaleMin = ScreenScaleMin
end

function util.Validate(...)
	local validate = {...}

	if #validate <= 0 then return false end

	for _, v in ipairs(validate) do
		if !IsValid(v) then
			return false
		end
	end

	return true
end

do
	local hex_digits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'}

	function util.HexToDecimal(hex)
		if isnumber(hex) then
			return hex
		end

		hex = hex:lower()

		local negative = false

		if hex:starts('-') then
			hex = hex:sub(2, 2)
			negative = true
		end

		for k, v in ipairs(hex_digits) do
			if v == hex then
				if !negative then
					return k - 1
				else
					return -(k - 1)
				end
			end
		end

		ErrorNoHalt("hex_to_dec - '"..hex.."' is not a hexadecimal number!")

		return 0
	end
end

-- A function to convert hexadecimal number to decimal.
function util.HexToDecilimal(hex)
	if isnumber(hex) then return hex end

	local sum = 0
	local chars = table.Reverse(hex:split())
	local idx = 1

	for i = 0, hex:len() - 1 do
		sum = sum + util.HexToDecimal(chars[idx]) * math.pow(16, i)
		idx = idx + 1
	end

	return sum
end

function util.HexToColor(hex)
	if hex:starts('#') then
		hex = hex:sub(2, hex:len())
	end

	local len = hex:len()

	if len != 3 and len != 6 and len != 8 then
		return Color(255, 255, 255)
	end

	local hex_colors = {}

	if len == 3 then
		for i = 1, 3 do
			local v = hex[i]

			table.insert(hex_colors, v..v) -- Duplicate the number.
		end
	else
		local initial_length = len * 0.5

		for i = 1, len * 0.5 do
			table.insert(hex_colors, hex:sub(1, 2))

			if i != initial_length then
				hex = hex:sub(3, hex:len())
			end
		end
	end

	local color = {}

	for _, v in ipairs(hex_colors) do
		table.insert(color, util.HexToDecilimal(v))
	end

	return Color(color[1], color[2], color[3], (color[4] or 255))
end