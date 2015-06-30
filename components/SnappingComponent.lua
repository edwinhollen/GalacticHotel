-- Lets the object snap into position
function SnappingComponent(newSnap)
  return {
    type = "SnappingComponent",
    snap = newSnap or 32
  }
end