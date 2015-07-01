-- Holds the x,y coordinates of the position
function PositionComponent(newPos)
  newPos = newPos or Point(0, 0)
  return {
    type = "PositionComponent",
    x = newPos.x,
    y = newPos.y
  }
end