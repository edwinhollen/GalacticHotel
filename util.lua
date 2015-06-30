function math.round(n)
  return math.floor(n + 0.5)
end

function math.roundToNearest(n, multiple)
  if multiple == 0 then return 0 end
  return ((n + multiple - 1) / multiple) * multiple
end

function math.distance(x1, y1, x2, y2)
  return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end
