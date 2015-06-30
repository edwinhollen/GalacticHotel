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