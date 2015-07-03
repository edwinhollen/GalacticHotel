require "EntitySystem"
require "Entity"
require "systems/ImageSystem"
require "systems/NodeSystem"
require "components/ImageComponent"
require "components/NodeComponent"
require "components/PathfindingComponent"
require "components/PositionComponent"
require "Point"

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

  -- add tiles
  local tileSize = 32
  for row=0, 20 do
    for col=0, 20 do
      local e = Entity()
      local image = "images/floortile.png"
      local walkable = true
      if love.math.random(0, 10) < 2 then
        image = "images/wall.png"
        walkable = false
      end
      
      entitySystem:addEntity(Entity(
        PositionComponent(Point(col * tileSize, row * tileSize)),
        ImageComponent(image, Point(16, 16)),
        NodeComponent(walkable)
      ))
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
