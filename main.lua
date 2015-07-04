require "EntitySystem"
require "Entity"
require "systems/ImageSystem"
require "systems/NodeSystem"
require "systems/UISystem"
require "components/ImageComponent"
require "components/NodeComponent"
require "components/PathfindingComponent"
require "components/PositionComponent"
require "Point"
require "EntityFactory"

local showFps = true

local entitySystem
local testNpc

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  -- init
  entitySystem = EntitySystem()

  -- add systems
  entitySystem:addSystem(ImageSystem())
  entitySystem:addSystem(NodeSystem())
  entitySystem:addSystem(UISystem())

  -- add tiles
  local tileSize = 32
  for row=0, 20 do
    for col=0, 20 do
      local entity = EntityFactory:create("floor tile")
      entity:getComponent("PositionComponent").x = col * tileSize
      entity:getComponent("PositionComponent").y = row * tileSize
      entitySystem:addEntity(entity)
    end
  end
  
  -- add npc
  
  testNpc = Entity(
    PositionComponent(Point(love.math.random(0, 400), love.math.random(0, 400))),
    ImageComponent("images/npc.png", Point(7, 28)),
    NodeComponent(false),
    PathfindingComponent()
  )
  entitySystem:addEntity(testNpc)
end

function love.update(dt)
  entitySystem:organize()
  for pairKey, pair in ipairs(entitySystem.organized) do
    if pair.system.update then
      pair.system:update(pair.entities, dt)
    end
  end
end

function love.mousepressed(x, y, button)
  if button == "l" then
    testNpc:getComponent("PathfindingComponent"):setDestination(Point(love.mouse.getX(), love.mouse.getY()))
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
