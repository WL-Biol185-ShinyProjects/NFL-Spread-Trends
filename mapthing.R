#Call Libraries
library(sf)
library(mapview)
library(leaflet)
#Read NFL Location csv
NFLTeamLocations <- read.csv("NFLlocations.csv")
#Render map
mapview(NFLTeamLocations, xcol="longitude", ycol="latitude", crs=4269, grid=FALSE)
m <- leaflet %>% 
  addTiles() %>%
  addMarkers(lng=-86.77129, lat=36.16646, popup = "Bottom Right Corner") %>% 
  htmlwidgets::onRender("
                        function(el, x)
                        {console.log(this);
                        var myMap = this;
                        var imageUrl = "https://cdn.freebiesupply.com/images/large/2x/tennessee-titans-logo-transparent.png"
                        var imageBounds = [[36.16646, -86.77129], [36.26646, -86.87129]];
                        L.imageOverlay(imageUrl, imageBounds) .addTo(myMap);
                        }
                        ")

