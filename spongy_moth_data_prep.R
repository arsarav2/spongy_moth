library(sf)
library(folderfun)
library(terra)

setff("In", "H:/Shared drives/Data/Original/pest-occurrence/Asian Gypsy Moth/")
setff("states", "H:/Shared drives/Data/Vector/USA/")


states <- vect(ffstates("us_lower_48_states.gpkg"))
plot(states)
spongy <- st_read(ffIn("GyspyMothTrapCatchArchive_Edited.gpkg"))
plot(spongy)

## use terra instead
spongy <- vect(ffIn("GyspyMothTrapCatchArchive_Edited.gpkg"))
plot(spongy, add = TRUE)
