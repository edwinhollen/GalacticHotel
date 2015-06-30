require "entitysystem"
require "system"
require "entity"
require "component"

local showFps = true

local entitySystem

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  -- init
  entitySystem = EntitySystem()

  -- add systems
  entitySystem:addSystem(ImageSystem())
  entitySystem:addSystem(SnappingSystem())
  
  -- add entities
  entitySystem:addEntity(Entity(
    PositionComponent(20, 20),
    ImageComponent("images/test.png")
  ))
  -- add tiles
  local tileSize = 32
  for row=0, 20 do
    for col=0, 20 do
      entitySystem:addEntity(Entity(
        PositionComponent(col * tileSize, row * tileSize),
        SnappingComponent(tileSize),
        ImageComponent("images/floortile.png")
      ))
    end
  end
  
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
  if showFps then
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("FPS: "..love.timer.getFPS(), 20, 20)
  end
end
