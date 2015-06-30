function math.round(n)
  return math.floor(n + 0.5)
end

function math.roundToNearest(n, multiple)
  if multiple == 0 then return 0 end
  return ((n + multiple - 1) / multiple) * multiple
end
