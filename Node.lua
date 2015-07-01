function Node(newX, newY, newWalkable)
  return {
    x = newX or 0,
    y = newY or 0,
    walkable = newWalkable
  }
end