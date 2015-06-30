function EntitySystem()
  return {
    entities = {},
    systems = {},
    organized = {},
    organize = function(self)
      local returnTable = {}
      for systemKey, system in ipairs(self.systems) do
        local acceptedEntities = {}
        for entityKey, entity in ipairs(self.entities) do
          for acceptableKey, acceptable in ipairs(system.accepts) do
            local entityIsAcceptable = true
            if not entity:hasComponentOfType(acceptable) then
              entityIsAcceptable = false
              break
            end
            if entityIsAcceptable then
              table.insert(acceptedEntities, entity)
            end
          end
        end
        table.insert(returnTable, {
          system = system,
          entities = acceptedEntities
        })
      end
      self.organized = returnTable
    end,
    addEntity = function(self, newEntity)
      table.insert(self.entities, newEntity)
      self:organize()
    end,
    addSystem = function(self, newSystem)
      table.insert(self.systems, newSystem)
      self:organize()
    end,
  }
end
