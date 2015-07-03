-- Enables the entity to use pathfinding
function PathfindingComponent(newDestination)
  return {
    type = "PathfindingComponent",
    nextHop = nil,
    destination = newDestination or nil,
    route = nil,
    setDestination = function(self, newDestination)
      self.nextHop = nil
      self.route = nil
      self.destination = newDestination
    end
  }
end