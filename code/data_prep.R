# Asian Gypsy Moth: Data Processing
# Programmer: Elizabeth Beyer and Chris Jones
# Start Date: March 9, 2021
# Purpose: Extract erroneous data points from data files.

library(folderfun)

# Set current working directory:
folderfun::setff("In", "H:/Shared drives/Data/Original/pest-occurrence/Asian Gypsy Moth/Original Data/")

# Load sf package:
library(sf)

# Add original annual trap catch data:
GMTCA_original = read.csv(ffIn("GypsyMothTrapCatchArchive_2000.csv"))

# Append subsequent years of data:
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2001.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2002.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2003.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2004.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2005.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2006.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2007.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2008.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2009.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2010.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2011.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2012.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2013.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2014.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2015.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2016.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2017.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2018.csv")))
GMTCA_original = rbind(GMTCA_original,read.csv(ffIn("GypsyMothTrapCatchArchive_2019.csv")))

# Add the state data:
US_lower_48_states = st_read("H:/Shared drives/Data/Vector/USA/US_lower_48_states.gpkg")

# Buffer the state data:
US_lower_48_states_buff = st_buffer(US_lower_48_states,10000)

# Export the buffered state data to visualize:
## st_write(US_lower_48_states_buff, dsn="US_lower_48_states_buff.gpkg", layer='buffered states', append=FALSE)

# Add the state codes to the state data:
US_lower_48_statecodes = read.csv("H:/Shared drives/Data/Original/pest-occurrence/Asian Gypsy Moth/State_Codes.csv")
names(US_lower_48_statecodes) <- c("STATE_CODE")
US_lower_48_states_buff$State_Code = US_lower_48_statecodes
names(US_lower_48_states_buff)

# Convert data to sf object:
GMTCA_coord <- st_as_sf(x = GMTCA_original,
                        coords = c("x", "y"),
                        crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

# Check that each point is within state geometry:
test = st_within(GMTCA_coord, US_lower_48_states_buff$geom, sparse = FALSE, prepared = TRUE)

# Add the state codes as column names to the test matrix:
statecodes = US_lower_48_statecodes$STATE_CODE
colnames(test) = c(statecodes)

# Add "test" matrix to data:
GMTCA = cbind(GMTCA_original,test)

# Create an empty data matrix for the final data:
colnames_final = colnames(GMTCA_original)
GMTCA_final = data.frame(matrix(ncol = ncol(GMTCA_original),nrow = 0))
colnames(GMTCA_final) = colnames_final

# Add correct points to final data frame:
for (row in 1:nrow(GMTCA)) {
  target_state <- GMTCA[row, "STATE"]
  if (GMTCA[row, target_state] == "TRUE") {
    GMTCA_final = rbind(GMTCA_final, GMTCA_original[row,])
  }
  print(row)
}

# Convert output to csv:
write.csv(GMTCA_final,ffIn("GypsyMothTrapCatchArchive_changed.csv"), row.names = FALSE)
