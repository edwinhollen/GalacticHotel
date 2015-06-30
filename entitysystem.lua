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
          local entityIsAcceptable = true
          for acceptableKey, acceptable in ipairs(system.accepts) do
            if not entity:hasComponentOfType(acceptable) then
              entityIsAcceptable = false
              break
            end
          end
          if entityIsAcceptable then
            table.insert(acceptedEntities, entity)
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
    end,
    addSystem = function(self, newSystem)
      table.insert(self.systems, newSystem)
    end,
  }
end
