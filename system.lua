

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
