local is_development = ix.stdlib.Debug || false
local metrics = {}

if is_development then
  function add_debug_metric(id, obj)
    local count = 1

    if !metrics[id] then
      metrics[id] = { obj }
    else
      count = table.insert(metrics[id], obj)
    end

    return count
  end

  function get_debug_metric(id)
    return metrics[id]
  end

  function print_debug_metric(id, format)
    format = format or '{count} {id} were registered.'

    MsgC(
      Color(255, 255, 255),
      'Debug: ',
      Color(175, 175, 175),
      string.fmt(format, { id = tostring(id), count = tostring(#metrics[id]) }),
      '\n'
    )
  end

  function print_debug_metrics()
    for id, objects in pairs(metrics) do
      print_debug_metric(id)
    end
  end
else
  function add_debug_metric(id, obj)
  end

  function get_debug_metric(id)
  end

  function print_debug_metric(id, format)
  end

  function print_debug_metrics()
  end
end
