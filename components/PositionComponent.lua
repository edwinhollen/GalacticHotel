-- Holds the x,y coordinates of the position
function PositionComponent(newX, newY)
  return {
    type = "PositionComponent",
    x = newX or 0,
    y = newY or 0
  }
end