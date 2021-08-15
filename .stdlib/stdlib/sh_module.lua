--- Create a module with a specified name.
-- The resulting object will have the `include` method by default.
-- ```
-- mod 'Talkable'
--
-- -- You can include other modules too.
-- Talkable:include 'Living'
--
-- function Talkable:talk()
--   -- ...
-- end
-- ```
-- @return [Object(created module)]
function mod(name)
  local parent = nil
  parent, name = name:parse_parent()
  parent[name] = parent[name] or {}

  if name[1]:is_lower() then
    error('bad module name ('..name..')\nmodule names must follow the ConstantStyle!\n')
  end

  local obj = {}

  obj.included_modules = {}

  obj.include = function(self, what)
    local module_table = isstring(what) and what:parse_table() or what

    if !istable(module_table) then return end

    for k, v in pairs(module_table) do
      if !self[k] then
        self[k] = v
      end
    end

    table.insert(self.included_modules, module_table)
  end

  parent[name] = obj

  return obj
end
