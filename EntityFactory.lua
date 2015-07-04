require "components/ImageComponent"
require "components/NodeComponent"
require "components/PathfindingComponent"
require "components/PositionComponent"
require "Point"
require "Entity"

EntityFactory = {}

function EntityFactory:create(name)
  name = string.lower(name)
  local e = Entity()
  if name == "potted plant" then
    return nil
  end
  if name == "floor tile" then
    e:addComponent(
      PositionComponent(), 
      ImageComponent("images/floortile.png", Point(16, 16)), 
      NodeComponent(true)
    )
  end
  return e
end
