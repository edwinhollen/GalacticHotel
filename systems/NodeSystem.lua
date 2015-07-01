function NodeSystem()
  require "util"
  require "Node"
  return {
    accepts = {"NodeComponent", "PositionComponent"},
    drawNodes = true,
    findNearestNode = function(self, nodes, point)
      local nearest
      for nodeKey, node in ipairs(nodes) do
        if (node.walkable and nearest == nil) or (node.walkable and math.distance(point.x, point.y, node.x, node.y) < math.distance(point.x, point.y, nearest.x, nearest.y)) then
          nearest = node 
        end
      end
      return nearest
    end,
    findNeighborsOfNode = function(self, nodes, targetNode, maxNeighbors)
      maxNeighbors = maxNeighbors or 4
      local neighbors = {}
      while #neighbors < maxNeighbors do
        local nearest
        for nodeKey, node in ipairs(nodes) do
          if (node.walkable and node ~= targetNode) and (nearest == nil or (not table.contains(neighbors, node) and math.distance(node.x, node.y, targetNode.x, targetNode.y) < math.distance(nearest.x, nearest.y, targetNode.x, targetNode.y))) then
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
    findRoute = function(self, nodes, originNode, destinationNode)
      -- returns nil if no route possible
      if not (originNode.walkable and destinationNode.walkable) then return nil end
      -- label nodes
      local labeledNodes = {}
      local currentLabel = 1
      labeledNodes[originNode] = currentLabel
      
      local foundDestinationNode = false
      while not (foundDestinationNode or #labeledNodes >= #nodes) do
        currentLabel = currentLabel + 1
        for labeledNode, label in pairs(labeledNodes) do
          if label == (currentLabel - 1) then
            for neighborKey, neighbor in ipairs(self:findNeighborsOfNode(nodes, labeledNode, 4)) do
              labeledNodes[neighbor] = labeledNodes[neighbor] or currentLabel
              if neighbor == destinationNode then
                foundDestinationNode = true
              end
            end
          end
        end
      end
      return labeledNodes
    end,
    update = function(self, entities, dt)
      local nodes = self:generateNodesFromEntities(entities)
      for entityKey, entity in ipairs(entities) do
        local pfc = entity:getComponent("PathfindingComponent")
        if pfc then
          
        end
      end
    end,
    draw = function(self, entities)
      local nodes = self:generateNodesFromEntities(entities)
      for nodeKey, node in ipairs(nodes) do
        if node.walkable then
          love.graphics.setColor(0, 255, 0)
        else
          love.graphics.setColor(255, 0, 0)
        end
        love.graphics.circle("fill", node.x, node.y, 4, 4)
      end
      
      local origin = self:findNearestNode(nodes, Point(32, 32))
      local destination = self:findNearestNode(nodes, Point(512, 512))
      local route = self:findRoute(nodes, origin, destination)
    
      for node, label in pairs(route) do
        love.graphics.print(label, node.x, node.y)
      end
      
    end
  }
end

