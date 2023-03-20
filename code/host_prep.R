library(terra)
library(raster)

files = list.files(path= '/Users/andreasaravitz/Downloads/folder', pattern="\\.tif$", full.names = TRUE)
dlist <- lapply(files, rast)

h <- function(x) {
  g <- project(x, dlist[[1]])
  g <- resample(g, dlist[[1]])
  g <- crop(g, dlist[[1]])
  return(g)
}

#preps the hardwood data
hardwood = list.files(path= '~/Google Drive/Shared drives/Data/Original/Live Tree Basal Area 250m FIA/RasterMaps/Hardwood', pattern="\\.img$", full.names = TRUE)
hardwoods <- rast(hardwood)
hardwoods <- h(hardwoods)
hardwoodsum <- tapp(hardwoods, index=rep(1, nlyr(hardwoods)), fun=sum)
writeRaster(hardwoodsum, filename = "hardwood_sum.tif")


#preping the total wood data
totalwood = list.files(path= '~/Google Drive/Shared drives/Data/Original/Live Tree Basal Area 250m FIA/RasterMaps', pattern="\\.img$", full.names = TRUE)
totalwood <- rast(totalwood)
totalwood <- h(totalwood)
totalwoodsum <- tapp(totalwood, index=rep(1, nlyr(totalwood)), fun=sum)
writeRaster(totalwoodsum, filename = "totalwood_sum.tif")

#finding percentage hardwood
percentage <- (hardwoodsum / totalwoodsum)*100


#exporting percentage
writeRaster(percentage, filename = "hardwood_percentage.tif")

out_file <- rast("/Users/andreasaravitz/spongy_moth/hardwood_percentage.tif")
plot(out_file)
