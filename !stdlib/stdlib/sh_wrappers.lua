--- Gets the type of an object while ensuring the output is always lowercase.
-- Functions exactly the same as `type`.
-- @return [String type]
-- @see [type]
function typeof(obj)
  return string.lower(type(obj))
end

--- A wrapper for pcall for shorthand writing.
-- @return [Vararg]
function try(func, ...)
  local success, a, b, c, d, e, f = pcall(func, ...)

  if !success then
    error_with_traceback(tostring(a))
  end

  return a, b, c, d, e, f
end
