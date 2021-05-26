do
  local hex_digits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'}

  -- A function to convert a single hexadecimal digit to decimal.
  function util.hex_to_decimal(hex)
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
function util.hex_to_decimalimal(hex)
  if isnumber(hex) then return hex end

  local sum = 0
  local chars = table.Reverse(hex:split())
  local idx = 1

  for i = 0, hex:len() - 1 do
    sum = sum + util.hex_to_decimal(chars[idx]) * math.pow(16, i)
    idx = idx + 1
  end

  return sum
end

-- A function to determine whether vector from A to B intersects with a
-- vector from C to D.
function util.vectors_intersect(from, to, from2, to2)
  local d1, d2, a1, a2, b1, b2, c1, c2

  a1 = to.y - from.y
  b1 = from.x - to.x
  c1 = (to.x * from.y) - (from.x * to.y)

  d1 = (a1 * from2.x) + (b1 * from2.y) + c1
  d2 = (a1 * to2.x) + (b1 * to2.y) + c1

  if d1 > 0 and d2 > 0 then return false end
  if d1 < 0 and d2 < 0 then return false end

  a2 = to2.y - from2.y
  b2 = from2.x - to2.x
  c2 = (to2.x * from2.y) - (from2.x * to2.y)

  d1 = (a2 * from.x) + (b2 * from.y) + c2
  d2 = (a2 * to.x) + (b2 * to.y) + c2

  if d1 > 0 and d2 > 0 then return false end
  if d1 < 0 and d2 < 0 then return false end

  -- Vectors are collinear or intersect.
  -- No need for further checks.
  return true
end

-- A function to determine whether a 2D point is inside of a 2D polygon.
function util.vector_in_poly(point, poly_vertices)
  if !isvector(point) or !istable(poly_vertices) or !isvector(poly_vertices[1]) then
    return
  end

  local intersections = 0

  for k, v in ipairs(poly_vertices) do
    local next_vert

    if k < #poly_vertices then
      next_vert = poly_vertices[k + 1]
    elseif k == #poly_vertices then
      next_vert = poly_vertices[1]
    end

    if next_vert and util.vectors_intersect(point, Vector(99999, 99999, 0), v, next_vert) then
      intersections = intersections + 1
    end
  end

  -- Check whether number of intersections is even or odd.
  -- If it's odd then the point is inside the polygon.
  if intersections % 2 == 0 then
    return false
  else
    return true
  end
end

do
  local scale_factor_x = 1 / 1920
  local scale_factor_y = 1 / 1080

  function math.scale(size)
    return math.floor(size * (ScrH() * scale_factor_y))
  end

  function math.scale_x(size)
    return math.floor(size * (ScrW() * scale_factor_x))
  end

  function math.scale_size(x, y)
    return math.scale_x(x), math.scale(y)
  end

  math.scale_y      = math.scale
  math.scale_width  = math.scale_x
  math.scale_height = math.scale
end

function math.even(num)
  return num % 2 == 0
end

function math.odd(num)
  return num % 2 != 0
end

function math.divisible(num, factor)
  return num % factor == 0
end

math.divisible_by = math.divisible

--- Allows math.* methods to be called on number literals.
local number_meta = debug.getmetatable(0) or {}

function number_meta:__index(key)
  local value = math[key]

  if value then
    return value
  elseif isnumber(value) then
    return tostring(self):sub(value, value)
  else
    error('attempt to index a number value with a bad key ('..value..')', 2)
  end
end

debug.setmetatable(0, number_meta)
