function NodeSystem()
  require "util"
  require "Node"
  return {
    accepts = {"NodeComponent", "PositionComponent"},
    drawNodes = true,
    findNearestNode = function(self, nodes, point)
      local nearest
      for nodeKey, node in ipairs(nodes) do
        if node.isWalkable and (nearest == nil or math.distance(point.x, point.y, node.x, node.y) < math.distance(point.x, point.y, nearest.x, nearest.y)) then
          nearest = node
        end
      end
      return nearest
    end,
    findNeighborsOfNode = function(self, nodes, targetNode, maxNeighbors)
      maxNeighbors = maxNeighbors or 4
      walkable = walkable or true
      local neighbors = {}
      while #neighbors < maxNeighbors do
        local nearest
        for nodeKey, node in ipairs(nodes) do
          if (node.isWalkable and node ~= targetNode) and (nearest == nil or (not table.contains(neighbors, node) and math.distance(node.x, node.y, targetNode.x, targetNode.y) < math.distance(nearest.x, nearest.y, targetNode.x, targetNode.y))) then
            nearest = node
          end
        end
        table.insert(neighbors, nearest)
      end
      
      return neighbors
    end,
    generateNodesFromEntities = function(self, entities)
      local nodes = {}
      for entityKey, entity in ipairs(entities) do
        local n = Node(
          entity:getComponent("PositionComponent").x, 
          entity:getComponent("PositionComponent").y, 
          entity:getComponent("NodeComponent").isWalkable
        )
        table.insert(nodes, n)
      end
      return nodes
    end,
    update = function(self, entities, dt)
      --local nodes = self:generateNodesFromEntities(entities)
    end,
    draw = function(self, entities)
      for nodeKey, node in ipairs(self:generateNodesFromEntities(entities)) do
        if node.walkable then
          love.graphics.setColor(0, 255, 0)
        else
          love.graphics.setColor(255, 0, 0)
        end
        love.graphics.circle("fill", node.x, node.y, 4, 4)
      end
    end
  }
end

