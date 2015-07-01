-- Sets the entity as a node in a nodegraph
function NodeComponent(newWalkable)
  newWalkable = (newWalkable == nil) and false or newWalkable
  return {
    type = "NodeComponent",
    isWalkable = newWalkable
  }
end