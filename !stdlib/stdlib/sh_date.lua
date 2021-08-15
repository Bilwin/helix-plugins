--- The Date class is the base class for most time-related classes in Flux.
-- The Date class represents a point in time, not a time interval.
-- For time intervals, please use Time.
-- @see [Time]
class 'Date'

local d_const = 60 * 60 * 24

--- Initializes a new Date object.
-- ```
-- local my_birthday = Date.new(1999, 12, 04) -- April 12, 1999
-- ```
-- @param year [Number]
-- @param month [Number]
-- @param day [Number]
function Date:init(year, month, day)
  if istable(year) then
    self.year = year.year
    self.month = year.month
    self.day = year.day

    if year.class_name == 'Date' then
      self.time = year.time
      return
    end
  else
    self.year = year
    self.month = month
    self.day = day
  end

  self.time = os.time {
    year = self.year,
    month = self.month,
    day = self.day
  }
end

--- Returns the current date.
-- @return [Date today]
function Date:today()
  local date = os.date('*t', os.time())
  return Date.new(date.year, date.month, date.day)
end

--- Returns the following day's date.
-- @return [Date tomorrow]
function Date:tomorrow()
  local date = os.date('*t', os.time() + d_const)
  return Date.new(date.year, date.month, date.day)
end

--- Returns the previous day's date.
-- @return [Date yesterday]
function Date:yesterday()
  local date = os.date('*t', os.time() - d_const)
  return Date.new(date.year, date.month, date.day)
end

--- Returns the date at a specified point in time.
-- @param seconds [Number UNIX timestamp]
-- @return [Date]
function Date:at(seconds)
  local date = os.date('*t', seconds)
  return Date.new(date.year, date.month, date.day)
end

--- Converts the Date object to DateTime.
-- @return [DateTime this Date as DateTime]
function Date:to_datetime()
  return DateTime.new(self)
end

--- Converts the Date object to Time.
-- @return [Time this Date as Time]
function Date:to_time()
  return Time.new(self)
end

--- Converts the Date object into a ISO string.
-- If the first argument is given, converts the given UNIX time into the ISO date.
-- ```
-- print(date_obj:iso()) -- current date, such as "2019-09-24"
-- print(Date:iso(1569283200)) -- 2019-09-24
-- ```
-- @param time=Date object [Number UNIX time]
-- @return [String ISO date format]
function Date:iso(time)
  return os.date('%Y-%m-%d', time or self.time)
end

--- Formats date-time using a format string.
-- @param fmt [String DateTime format]
-- @param time=DateTime [Number UNIX time]
-- @return [String formatted string]
function Date:strftime(fmt, time)
  return os.date(fmt, time or self.time)
end

--- @ignore
local function run_if_valid_time(right, callback)
  if istable(right) and right.class_name == 'Time' then
    return callback(right)
  end
end

--- Add the specified amount of Time to the Date.
-- @param right [Time]
-- @return [Date or DateTime]
function Date:__add(right)
  return run_if_valid_time(right, function(right)
    return self.class:at(self.time + right.time)
  end)
end

--- Subtracts the specified amount of Time from the Date.
-- @param right [Time]
-- @return [Date or DateTime]
function Date:__sub(right)
  return run_if_valid_time(right, function(right)
    return self.class:at(self.time - right.time)
  end)
end

--- Add the specified amount of Time to the Date.
-- @param right [Time]
-- @return [Date or DateTime]
-- @see [Date#__add]
function Date:__concat(right)
  return run_if_valid_time(right, function(right)
    return self.class:at(self.time + right.time)
  end)
end

--- Converts this Date object to ISO-8601 string.
-- @return [String ISO representation of the Date]
function Date:__tostring()
  return self:iso()
end
