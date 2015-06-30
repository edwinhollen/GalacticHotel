function NodeSystem()
  return {
    accepts = {"NodeComponent", "PositionComponent"},
    nodeGraph = nil,
    drawNodes = true,
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
        if pfc then
          
        end
      end
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
        end
      end
    end
  }
end