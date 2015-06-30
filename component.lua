-- Holds the x,y coordinates of the position
function PositionComponent(newX, newY)
  return {
    type = "PositionComponent",
    x = newX or 0,
    y = newY or 0
  }
end

-- Holds the name of the image to use
function ImageComponent(newImageName)
  return {
    type = "ImageComponent",
    imageName = newImageName or nil
  }
end

-- Lets the object snap into position
function SnappingComponent(newSnap)
  return {
    type = "SnappingComponent",
    snap = newSnap or 32
  }
end

-- Sets the entity as a node in a nodegraph
function NodeComponent(newWalkable, offsetX, offsetY)
  return {
    type = "NodeComponent",
    isWalkable = newWalkable or false,
    offsetX = offsetX or 0,
    offsetY = offsetY or 0
  }
end
