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
        love.graphics.draw(self:getImage(img.imageName), math.round(pos.x - img.offset.x), math.round(pos.y - img.offset.y))
      end
    end
  }
end