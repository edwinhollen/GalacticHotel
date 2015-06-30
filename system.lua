

function ImageSystem()
  require "util"
  return {
    accepts = {"ImageComponent", "PositionComponent"},
    loadedImages = {},
    getImage = function(self, imageName)
      if not self.loadedImages[imageName] then
        local image = love.graphics.newImage(imageName)
        self.loadedImages[imageName] = image
      end
      return self.loadedImages[imageName]
    end,
    draw = function(self, entities)
      for entityKey, entity in ipairs(entities) do
        local img = entity:getComponent("ImageComponent")
        local pos = entity:getComponent("PositionComponent")
        love.graphics.draw(self:getImage(img.imageName), math.round(pos.x), math.round(pos.y))
      end
    end
  }
end

function SnappingSystem(snapSize)
  return {
    accepts = {"PositionComponent", "SnappingComponent"},
    update = function(self, entities, dt)
      for entityKey, entity in ipairs(entities) do
        local snap = entity:getComponent("SnappingComponent")
        local pos = entity:getComponent("PositionComponent")
        if pos.x % snap.snap ~= 0 then
          pos.x = math.roundToNearest(pos.x, snap.snap)
        end
        if pos.y % snap.snap ~= 0 then
          pos.y = math.roundToNearest(pos.y, snap.snap)
        end
      end
    end
  }
end

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
        table.insert(self.nodeGraph, {
          x = pos.x + nc.offsetX,
          y = pos.y + nc.offsetY,
          isWalkable = nc.isWalkable
        })
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
    end
  }
end
