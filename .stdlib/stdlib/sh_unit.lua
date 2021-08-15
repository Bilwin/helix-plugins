--- A class to convert conventional metrics to Source Engine units.
class 'Unit'

-- Constants for faster convertion.
local inches_in_cm = 1 / 2.54
local inches_in_mm = inches_in_cm * 0.1
local inches_in_ft = 1 / 12
local feet_in_yd = 1 / 3
local feet_in_mi = 1 / 5280

--- Converts a number of inches to Source Engine units.
-- Since Source Engine units are actually inches, we just return the value as-is.
-- @return [Number]
function Unit:inch(n)
  return n
end

--- Converts a number of millimeters to Source Engine units.
-- @return [Number]
function Unit:millimeter(n)
  return n * inches_in_cm
end

--- Converts a number of centimeters to Source Engine units.
-- @return [Number]
function Unit:centimeter(n)
  return n * inches_in_cm
end

--- Converts a number of meters to Source Engine units.
-- @return [Number]
function Unit:meter(n)
  return self:centimeter(n * 100)
end

--- Converts a number of kilometers to Source Engine units.
-- @return [Number]
function Unit:kilometer(n)
  return self:meter(n * 1000)
end

--- Converts a number of feet to Source Engine units.
-- @return [Number]
function Unit:foot(n)
  return n * 12
end

--- Converts a number of yards to Source Engine units.
-- @return [Number]
function Unit:yard(n)
  return self:foot(n * 3)
end

--- Converts a number of miles to Source Engine units.
-- @return [Number]
function Unit:mile(n)
  return self:foot(n * 5280)
end

--- Converts the amount of driving hours at 100 km/h average speed to
-- Source Engine units.
-- @return [Number]
function Unit:time_to_drive_there(n)
  return self:kilometer(n * 100)
end

--- Converts the amount of Source Engine units to centimeters.
-- @return [Number]
function Unit:to_centimeters(n)
  return n * 2.54
end

--- Converts the amount of Source Engine units to meters.
-- @return [Number]
function Unit:to_meters(n)
  return self:to_centimeters(n) * 0.01
end

--- Converts the amount of Source Engine units to millimeters.
-- @return [Number]
function Unit:to_millimeters(n)
  return self:to_centimeters(n) * 10
end

--- Converts the amount of Source Engine units to kilometers.
-- @return [Number]
function Unit:to_kilometers(n)
  return self:to_meters(n) * 0.001
end

--- Converts the amount of Source Engine units to inches.
-- @return [Number]
function Unit:to_inches(n)
  return n
end

--- Converts the amount of Source Engine units to feet.
-- @return [Number]
function Unit:to_feet(n)
  return n * inches_in_ft
end

--- Converts the amount of Source Engine units to yards.
-- @return [Number]
function Unit:to_yards(n)
  return self:to_feet(n) * feet_in_yd
end

--- Converts the amount of Source Engine units to miles.
-- @return [Number]
function Unit:to_miles(n)
  return self:to_feet(n) * feet_in_mi
end

--- Formats the distance for human-friendly display in either imperial or metric.
-- @param n [Number] The Source Engine units.
-- @param system=imperial [String] Whether to use 'imperial', 'metric' or 'units'. Will use
--   Imperial by default.
-- @return [String] Formatted text as phrases.
function Unit:format(n, system)
  system = (system or 'imperial'):lower()

  local result = ''

  if system == 'metric' then
    local km = Unit:to_km(n):floor()
    local m  = Unit:to_m(n):floor()
    local cm = Unit:to_cm(n):floor()
    local mm = Unit:to_mm(n):floor()

    mm = mm - cm * 10
    cm = cm - m  * 100
    m  = m  - km * 1000

    if km > 0 then
      result = km..t'ui.unit.km'

      if m > 0 then
        result = result..' '..m..t'ui.unit.m'
      end
    elseif m > 0 then
      result = m..t'ui.unit.m'

      if cm > 0 then
        result = result..' '..cm..t'ui.unit.cm'
      end
    elseif cm > 0 then
      result = cm..t'ui.unit.cm'

      if mm > 0 then
        result = result..' '..mm..t'ui.unit.mm'
      end
    else
      result = mm..t'ui.unit.mm'
    end
  elseif system == 'units' then
    result = n:round(1)..' '..t'ui.unit.units'
  else
    local mi = Unit:to_mi(n):round(2)
    local ft = Unit:to_ft(n):floor()

    n  = n:floor() - ft * 12
    ft = ft - mi * 5280

    if mi > 0.3 then
      result = mi..t'ui.unit.mi'
    else
      result = ft.."'"..n..'"'
    end
  end

  return result
end

-- Aliases for convenience.
Unit.inches         = Unit.inch
Unit.unit           = Unit.inch
Unit.units          = Unit.inch
Unit.millimeters    = Unit.millimeter
Unit.mm             = Unit.millimeter
Unit.centimeters    = Unit.centimeter
Unit.cm             = Unit.centimeter
Unit.meters         = Unit.meter
Unit.m              = Unit.meter
Unit.kilometers     = Unit.kilometer
Unit.km             = Unit.kilometer
Unit.feet           = Unit.foot
Unit.ft             = Unit.foot
Unit.yards          = Unit.yard
Unit.yd             = Unit.yard
Unit.miles          = Unit.mile
Unit.mi             = Unit.mile
Unit.to_inch        = Unit.to_inches
Unit.to_unit        = Unit.to_inches
Unit.to_units       = Unit.to_inches
Unit.to_foot        = Unit.to_feet
Unit.to_ft          = Unit.to_feet
Unit.to_yard        = Unit.to_yards
Unit.to_yd          = Unit.to_yards
Unit.to_mile        = Unit.to_miles
Unit.to_mi          = Unit.to_miles
Unit.to_meter       = Unit.to_meters
Unit.to_m           = Unit.to_meters
Unit.to_millimeter  = Unit.to_millimeters
Unit.to_mm          = Unit.to_millimeters
Unit.to_centimeter  = Unit.to_centimeters
Unit.to_cm          = Unit.to_centimeters
Unit.to_kilometer   = Unit.to_kilometers
Unit.to_km          = Unit.to_kilometers

--- Install Unit shortcuts into the math library.\
local function installable(func)
  return function(n)
    return func(Unit, n)
  end
end

math.inch           = installable(Unit.inch)
math.inches         = installable(Unit.inch)
math.unit           = installable(Unit.inch)
math.units          = installable(Unit.inch)
math.millimeter     = installable(Unit.millimeter)
math.millimeters    = installable(Unit.millimeter)
math.mm             = installable(Unit.millimeter)
math.centimeter     = installable(Unit.centimeter)
math.centimeters    = installable(Unit.centimeter)
math.cm             = installable(Unit.centimeter)
math.meter          = installable(Unit.meter)
math.meters         = installable(Unit.meter)
math.m              = installable(Unit.meter)
math.kilometer      = installable(Unit.kilometer)
math.kilometers     = installable(Unit.kilometer)
math.km             = installable(Unit.kilometer)
math.foot           = installable(Unit.foot)
math.feet           = installable(Unit.foot)
math.ft             = installable(Unit.foot)
math.yard           = installable(Unit.yard)
math.yards          = installable(Unit.yard)
math.yd             = installable(Unit.yard)
math.mile           = installable(Unit.mile)
math.miles          = installable(Unit.mile)
math.mi             = installable(Unit.mile)
math.to_inches      = installable(Unit.to_inches)
math.to_inch        = installable(Unit.to_inches)
math.to_unit        = installable(Unit.to_inches)
math.to_units       = installable(Unit.to_inches)
math.to_feet        = installable(Unit.to_feet)
math.to_foot        = installable(Unit.to_feet)
math.to_ft          = installable(Unit.to_feet)
math.to_yards       = installable(Unit.to_yards)
math.to_yard        = installable(Unit.to_yards)
math.to_yd          = installable(Unit.to_yards)
math.to_miles       = installable(Unit.to_miles)
math.to_mile        = installable(Unit.to_miles)
math.to_mi          = installable(Unit.to_miles)
math.to_meters      = installable(Unit.to_meters)
math.to_meter       = installable(Unit.to_meters)
math.to_m           = installable(Unit.to_meters)
math.to_millimeters = installable(Unit.to_millimeters)
math.to_millimeter  = installable(Unit.to_millimeters)
math.to_mm          = installable(Unit.to_millimeters)
math.to_centimeters = installable(Unit.to_centimeters)
math.to_centimeter  = installable(Unit.to_centimeters)
math.to_cm          = installable(Unit.to_centimeters)
math.to_kilometers  = installable(Unit.to_kilometers)
math.to_kilometer   = installable(Unit.to_kilometers)
math.to_km          = installable(Unit.to_kilometers)
