--- The DateTime class represents a point in time, not a time interval.
-- For time intervals, please use Time.
-- @see [Time]
class 'DateTime' extends 'Date'

--- Initializes a new DateTime object.
-- ```
-- local my_birthday = DateTime.new(1999, 12, 04, 15, 30, 00) -- 3:30PM, April 12, 1999
-- ```
-- @param year [Number]
-- @param month [Number]
-- @param day [Number]
-- @param hour [Number]
-- @param minute [Number]
-- @param second [Number]
-- @param timezone='utc' [String]
function DateTime:init(year, month, day, hour, minute, second, timezone)
  if istable(year) then
    self.year = year.year
    self.month = year.month
    self.day = year.day
    self.hour = year.hour
    self.min = year.min
    self.sec = year.sec

    if year.class_name == 'DateTime' then
      self.time = year.time
      self.timezone = year.timezone
      return
    end
  else
    self.year = year
    self.month = month
    self.day = day
    self.hour = hour
    self.min = min
    self.sec = sec
  end

  self.time = os.time {
    year = self.year,
    month = self.month,
    day = self.day,
    hour = self.hour,
    min = self.min,
    sec = self.sec
  }
  self.timezone = timezone or self:zone()
end

--- Gets the timezone abbreviation / information string.
-- @return [String time zone]
function DateTime:zone()
  return os.date('%z', self.time)
end

--- Returns the date-time at a specified point in time.
-- @param seconds [Number UNIX timestamp]
-- @param timezone [String time zone]
-- @return [DateTime]
function DateTime:at(seconds, timezone)
  local date = os.date('*t', seconds)
  return DateTime.new(date.year, date.month, date.day, date.hours, date.min, date.sec, timezone)
end

--- Returns the current date-time.
-- @return [DateTime present time]
function DateTime:now()
  return DateTime:at(os.time())
end

--- Get the UTC time, or alternatively a UTC time at a specified UNIX timestamp.
-- @param time=DateTime
-- @return [DateTime]
function DateTime:utc(time)
  local date = os.date('!*t', time or self.time)
  return DateTime.new(date.year, date.month, date.day, date.hour, date.min, date.sec, 'utc')
end

--- Converts the DateTime object to Date.
-- @return [Date this DateTime as Date]
function DateTime:to_date()
  return Date.new(self)
end

--- Converts the DateTime object to Time.
-- @return [Time this DateTime as Time]
function DateTime:to_time()
  return Time.new(self)
end

--- Converts the DateTime object into a ISO-8601 string.
-- If the first argument is given, converts the given UNIX time into the ISO date.
-- ```
-- print(date_time_obj:iso()) -- current date and time in UTC, such as "2019-09-24T18:09:00Z"
-- print(DateTime:iso(1569283200)) -- 2019-09-24T00:00:00Z
-- ```
-- @param time=Date object [Number UNIX time]
-- @return [String ISO date format]
function DateTime:iso(time)
  return os.date('!%Y-%m-%dT%H:%M:%SZ', time or self.time)
end
