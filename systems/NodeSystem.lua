function NodeSystem()
  require "util"
  return {
    accepts = {"NodeComponent", "PositionComponent"},
    testPoint = {x=0,y=0},
    nodeGraph = nil,
    drawNodes = true,
    findNearestNode = function(self, point)
      local nearest = nil
      for nodeKey, node in ipairs(self.nodeGraph) do
        if nearest == nil and node.isWalkable then
          nearest = node
        else
          if node.isWalkable and math.distance(point.x, point.y, node.x, node.y) < math.distance(point.x, point.y, nearest.x, nearest.y) then
            nearest = node
          end
        end
      end
      return nearest
    end,
    findNeighborsOfNode = function(self, targetNode, maxNeighbors)
      local neighbors = {}
      
      while #neighbors < maxNeighbors do
        local nearest
        for nodeKey, node in ipairs(self.nodeGraph) do
          if nearest == nil or node ~= targetNode and node.isWalkable and not table.contains(neighbors, node) and math.distance(targetNode.x, targetNode.y, node.x, node.y) < math.distance(targetNode.x, targetNode.y, nearest.x, nearest.y) then
            nearest = node
          end
        end
        table.insert(neighbors, nearest)
      end
      return neighbors
    end,
    update = function(self, entities, dt)
      self.nodeGraph = {}
      for entityKey, entity in ipairs(entities) do
        local nc = entity:getComponent("NodeComponent")
        local pos = entity:getComponent("PositionComponent")
        local pfc = entity:getComponent("PathfindingComponent")
        table.insert(self.nodeGraph, {
          x = pos.x + nc.offsetX,
          y = pos.y + nc.offsetY,
          isWalkable = nc.isWalkable
        })
      end
      for entityKey, entity in ipairs(entities) do
        local nc = entity:getComponent("NodeComponent")
        local pos = entity:getComponent("PositionComponent")
        local pfc = entity:getComponent("PathfindingComponent")
        local adjustedPos = {x=pos.x+nc.offsetX, y=pos.y+nc.offsetY}
        if pfc then
          if not pfc.nextHop then
            pfc.destination = self:findNearestNode(pfc.destination)
            pfc.nextHop = self:findNearestNode(adjustedPos)
            pfc.visited = {}
          end
          local speed = 50 * dt
          local dir = math.atan2(pfc.nextHop.y - adjustedPos.y, pfc.nextHop.x - adjustedPos.x) * 180 / math.pi
          pos.x = pos.x + (math.cos(dir * math.pi / 180) * speed)
          pos.y = pos.y + (math.sin(dir * math.pi / 180) * speed)
          if math.round(adjustedPos.x) == pfc.nextHop.x and math.round(adjustedPos.y) == pfc.nextHop.y then
            -- set hop as visited
            table.insert(pfc.visited, pfc.nextHop)
            -- set the next hop
            local neighbors = self:findNeighborsOfNode(pfc.nextHop, 4)
            local uniqueNeighbors = {}
            for neighborKey, neighbor in ipairs(neighbors) do
              if not table.contains(pfc.visited, neighbor) then
                table.insert(uniqueNeighbors, neighbor)
              end
            end
            local closestUniqueNeighbor = uniqueNeighbors[1]
            for uniqueNeighborKey, uniqueNeighbor in ipairs(uniqueNeighbors) do
              if math.distance(uniqueNeighbor.x, uniqueNeighbor.y, pfc.destination.x, pfc.destination.y) < math.distance(closestUniqueNeighbor.x, closestUniqueNeighbor.y, pfc.destination.x, pfc.destination.y) then
                closestUniqueNeighbor = uniqueNeighbor
              end
            end
            pfc.nextHop = closestUniqueNeighbor
          end
        end
      end
      self.testPoint = {x=love.mouse.getX(), y=love.mouse.getY()}
    end,
    draw = function(self, entities)
      for nodeKey, node in ipairs(self.nodeGraph) do
        if node.isWalkable then
          love.graphics.setColor(0, 255, 0)
        else
          love.graphics.setColor(255, 0, 0)
        end
        love.graphics.circle("fill", node.x, node.y, 4)
      end
      for entityKey, entity in ipairs(entities) do
        local nc = entity:getComponent("NodeComponent")
        local pos = entity:getComponent("PositionComponent")
        local pfc = entity:getComponent("PathfindingComponent")
        if pfc then
          if pfc.destination then
            love.graphics.line(pos.x + nc.offsetX, pos.y + nc.offsetY, pfc.destination.x, pfc.destination.y)
          end
          local nearest = self:findNearestNode({x=pos.x+nc.offsetX, y=pos.y+nc.offsetY})
          love.graphics.setColor(255, 255, 0)
          love.graphics.line(pos.x + nc.offsetX, pos.y + nc.offsetY, nearest.x, nearest.y)
        end
      end
      
      local testNearest = self:findNearestNode(self.testPoint)
      love.graphics.setColor(255, 0, 255)
      love.graphics.rectangle("fill", testNearest.x-8, testNearest.y-8, 16, 16)
      for neighborKey, neighbor in ipairs(self:findNeighborsOfNode(testNearest, 4)) do
        love.graphics.setColor(200, 0, 200)
        love.graphics.rectangle("fill", neighbor.x-3, neighbor.y-3, 6, 6)
      end
      
    end
  }
end