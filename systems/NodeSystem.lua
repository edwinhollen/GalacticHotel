function NodeSystem()
  require "util"
  require "Node"
  require "Point"
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
    findNeighborsOfNode = function(self, nodes, targetNode, maxNeighbors, maxDistance)
      maxNeighbors = maxNeighbors or 4
      local neighbors = {}
      while #neighbors < maxNeighbors do
        local nearest
        for nodeKey, node in ipairs(nodes) do
          if (node.walkable and node ~= targetNode) and (nearest == nil or (not table.contains(neighbors, node) and ((node.x == targetNode.x and node.y ~= targetNode.y) or (node.x ~= targetNode.x and node.y == targetNode.y)) and math.distance(node.x, node.y, targetNode.x, targetNode.y) < math.distance(nearest.x, nearest.y, targetNode.x, targetNode.y))) then
            nearest = node
          end
        end
        table.insert(neighbors, nearest)
      end
      
      -- check for max distance
      if maxDistance ~= nil then
        local neighborsWithinMaxDistance = {}
        for neighborKey, neighbor in ipairs(neighbors) do
          if math.distance(neighbor.x, neighbor.y, targetNode.x, targetNode.y) <= maxDistance then
            table.insert(neighborsWithinMaxDistance, neighbor)
          end
        end
        neighbors = neighborsWithinMaxDistance
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
      -- label nodes
      local labeledNodes = {}
      local currentLabel = 1
      labeledNodes[originNode] = currentLabel
      
      local foundDestinationNode = false
      while (not foundDestinationNode) do
        currentLabel = currentLabel + 1
        if currentLabel > #nodes then
          return nil
        end
        for labeledNode, label in pairs(labeledNodes) do
          if label == (currentLabel - 1) then
            
            local neighbors = self:findNeighborsOfNode(nodes, labeledNode, 4, 32)
            
            for neighborKey, neighbor in ipairs(neighbors) do
              labeledNodes[neighbor] = labeledNodes[neighbor] or currentLabel
              if neighbor == destinationNode then
                foundDestinationNode = true
                break
              end
            end
          end
        end
      end
      
      local route = {}
      route[currentLabel] = destinationNode
      
      while currentLabel > 0 do
        currentLabel = currentLabel - 1
        
        local nodesWithCurrentLabel = {}
        for labeledNode, label in pairs(labeledNodes) do
          if label == currentLabel then
            table.insert(nodesWithCurrentLabel, labeledNode)
          end
        end
        local neighborsOfCurrentRouteNode = self:findNeighborsOfNode(nodes, route[currentLabel + 1], 4, 32)
        -- find common nodes
        local commonNodes = {}
        for neighborKey, neighborNode in ipairs(neighborsOfCurrentRouteNode) do
          local match = false
          for nodeWithCurrentLabelKey, nodeWithCurrentLabel in ipairs(nodesWithCurrentLabel) do
            if neighborNode == nodeWithCurrentLabel then
              match = true
            end
          end
          if match == true then
            table.insert(commonNodes, neighborNode)
          end
        end
        route[currentLabel] = commonNodes[1]
      end
      
      return route
    end,
    update = function(self, entities, dt)
      local nodes = self:generateNodesFromEntities(entities)
      for entityKey, entity in ipairs(entities) do
        local pfc = entity:getComponent("PathfindingComponent")
        local pos = entity:getComponent("PositionComponent")
        
        if pfc then
          if pfc.destination and not pfc.route then
            local origin = self:findNearestNode(nodes, Point(pos.x, pos.y))
            pfc.destination = self:findNearestNode(nodes, pfc.destination)
            pfc.route = self:findRoute(nodes, origin, pfc.destination)
            if pfc.route == nil then
              pfc.destination = nil
              pfc.route = nil
            end
          end
          if pfc.destination and pfc.route then
            if math.round(pos.x) == pfc.route[1].x and math.round(pos.y) == pfc.route[1].y then
              table.remove(pfc.route, 1)
              if #pfc.route < 1 then
                pfc.route = nil
                pfc.destination = nil
              end
            else
              local direction = math.atan2(pfc.route[1].y - pos.y, pfc.route[1].x - pos.x)
              local speed = 50 * dt
              pos.x = pos.x + speed * math.cos(direction)
              pos.y = pos.y + speed * math.sin(direction)
            end
          end
        end
      end
    end,
    draw = function(self, entities)
      local nodes = self:generateNodesFromEntities(entities)
      --[[
      for nodeKey, node in ipairs(nodes) do
        if node.walkable then
          love.graphics.setColor(0, 255, 0, 20)
        else
          love.graphics.setColor(255, 0, 0, 20)
        end
        love.graphics.circle("fill", node.x, node.y, 3, 3)
      end
      ]]--
      for entityKey, entity in ipairs(entities) do
        local pfc = entity:getComponent("PathfindingComponent")
        --[[
        if pfc and pfc.route then
          if #pfc.route > 1 then
            love.graphics.setColor(0, 0, 0, 20)
            local points = {}
            for key, node in ipairs(pfc.route) do
              table.insert(points, node.x)
              table.insert(points, node.y)
            end
            love.graphics.line(points)
          end
        end
        ]]--
      end
    end
  }
end

