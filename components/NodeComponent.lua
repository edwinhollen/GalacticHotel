-- Sets the entity as a node in a nodegraph
function NodeComponent(newWalkable, offsetX, offsetY)
  return {
    type = "NodeComponent",
    isWalkable = newWalkable or false,
    offsetX = offsetX or 0,
    offsetY = offsetY or 0
  }
end