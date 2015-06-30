function Entity(...)
  return {
    components = {...} or {},
    hasComponentOfType = function(self, type)
      if self:getComponent(type) then
        return true
      else
        return false
      end
    end,
    getComponents = function(self, type)
      local returnComponents = {}
      for componentKey, component in ipairs(self.components) do
        if component.type == type then
          table.insert(returnComponents, component)
        end
      end
      return returnComponents
    end,
    getComponent = function(self, type)
      return self:getComponents(type)[1] or nil
    end
  }
end