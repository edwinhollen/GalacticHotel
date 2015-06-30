-- Enables the entity to use pathfinding
function PathfindingComponent(newDestination)
  return {
    type = "PathfindingComponent",
    nextHop = nil,
    visited = nil,
    destination = newDestination or nil
  }
end