-- Holds the name of the image to use
function ImageComponent(newImageName, offset)
  require "Point"
  return {
    type = "ImageComponent",
    imageName = newImageName or nil,
    offset = offset or Point(0, 0)
  }
end