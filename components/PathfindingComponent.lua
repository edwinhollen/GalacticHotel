-- Enables the entity to use pathfinding
function PathfindingComponent(newDestination)
  return {
    type = "PathfindingComponent",
    destination = newDestination or nil,
    route = nil,
    setDestination = function(self, newDestination)
      self.route = nil
      self.destination = newDestination
    end
  }
end