-- Holds the name of the image to use
function ImageComponent(newImageName)
  return {
    type = "ImageComponent",
    imageName = newImageName or nil
  }
end