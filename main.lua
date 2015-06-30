require "entitysystem"
require "system"
require "entity"
require "component"

local entitySystem

function love.load()
  entitySystem = EntitySystem()

  -- add systems
  entitySystem:addSystem(ImageSystem())
  
  -- add entities
  entitySystem:addEntity(Entity({
    PositionComponent(20, 20),
    ImageComponent("images/test.png")
  }))
end

function love.update(dt)
  entitySystem:organize()
  for pairKey, pair in ipairs(entitySystem.organized) do
    if pair.system.update then
      pair.system:update(pair.entities, dt)
    end
  end
end

function love.draw()
  for pairKey, pair in ipairs(entitySystem.organized) do
    if pair.system.draw then
      pair.system:draw(pair.entities)
    end
  end
end
