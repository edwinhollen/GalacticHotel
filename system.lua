

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
    update = function(self, entities, dt)
      for entityKey, entity in ipairs(entities) do
        local pos = entity:getComponent("PositionComponent")
        pos.x = pos.x + (50 * dt)
        pos.y = pos.x + (80 * dt)
      end
    end,
    draw = function(self, entities)
      for entityKey, entity in ipairs(entities) do
        local img = entity:getComponent("ImageComponent")
        local pos = entity:getComponent("PositionComponent")
        -- TODO
        -- round the positions when drawing
        love.graphics.draw(self:getImage(img.imageName), math.round(pos.x), math.round(pos.y))
      end
    end
  }
end