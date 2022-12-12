#CallLibraries
library(sp)
library(sf)
library(mapview)
library(raster)
library(leaflet)
library(readr)
#Read Dataframe

NFLlocations <- read.csv("NFLlocations.csv")

#RenderMap
leaflet() %>% 
  addTiles() %>%
  addCircleMarkers(lng=NFLlocations$longitude,
                   lat=NFLlocations$latitude)

iconSet <- iconList(
  TEN_stadium = makeIcon("NFLLogos/titanslogo3.png", 40, 40),
  NYG_stadium = makeIcon("NFLLogos/giantslogo.jpg", 20, 20),
  PIT_stadium = makeIcon("NFLLogos/steelerslogo3.png", 20, 20),
  CAR_stadium = makeIcon("NFLLogos/pantherslogo2.png", 40, 40),
  BAL_stadium = makeIcon("NFLLogos/ravenslogo2.jpg", 30, 30),
  TMB_stadium = makeIcon("NFLLogos/buccaneerslogo2.png", 40, 40),
  IND_stadium = makeIcon("NFLLogos/coltslogo2.png", 40, 40),
  MIN_stadium = makeIcon("NFLLogos/vikingslogo.png", 60, 60),
  ARI_stadium = makeIcon("NFLLogos/cardinalslogo.png", 40, 40),
  DAL_stadium = makeIcon("NFLLogos/cowboyslogo.png", 30, 30),
  ATL_stadium = makeIcon("NFLLogos/falconslogo.png", 40, 40),
  NYJ_stadium = makeIcon("NFLLogos/jetslogo.png", 40, 40),
  DEN_stadium = makeIcon("NFLLogos/broncoslogo.png", 40, 40),
  MIA_stadium = makeIcon("NFLLogos/dolphinslogo.png", 40, 40),
  PHI_stadium = makeIcon("NFLLogos/eagleslogo.png", 40, 40),
  CHI_stadium = makeIcon("NFLLogos/bearslogo.png", 30, 30),
  PAT_stadium = makeIcon("NFLLogos/patriotslogo.png", 40, 40),
  WAS_stadium = makeIcon("NFLLogos/commanderslogo.png", 30, 30),
  GRB_stadium = makeIcon("NFLLogos/packerslogo.png", 40, 40),
  LAC_stadium = makeIcon("NFLLogos/chargerslogo.png", 40, 40),
  NOS_stadium = makeIcon("NFLLogos/saintslogo.png", 25, 25),
  HOU_stadium = makeIcon("NFLLogos/texanslogo.png", 40, 40),
  BUF_stadium = makeIcon("NFLLogos/billslogo.png", 60, 60),
  SAF_stadium = makeIcon("NFLLogos/fortyninerslogo.png", 40, 40),
  JAX_stadium = makeIcon("NFLLogos/jaguarslogo.png", 40, 40),
  CLE_stadium = makeIcon("NFLLogos/brownslogo.png", 40, 40),
  LAV_stadium = makeIcon("NFLLogos/raiderslogo.png", 40, 40),
  KAC_stadium = makeIcon("NFLLogos/chiefslogo.png", 35, 35),
  STL_stadium = makeIcon("NFLLogos/ramslogo2.png", 40, 40),
  SEA_stadium = makeIcon("NFLLogos/seahawkslogo.png", 40, 40),
  CIN_stadium = makeIcon("NFLLogos/bengalslogo.png", 30, 30),
  DET_stadium = makeIcon("NFLLogos/lionslogo.png", 40, 40)
  
)

leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = NFLlocations$longitude,
             lat = NFLlocations$latitude,
             icon = iconSet) %>% 
  addProviderTiles(provider = "Stamen.watercolor")

setView(lat = 38.5, lng = -100, zoom = 3.5) %>%
  addCircles(data = NFLlocations, lng = ~longitude, lat = ~latitude, weight = 4) %>%
  leaflet::addLegend(position = "bottomright", pal = pal, values = ~win_pct, na.label = "No Games Played", title = "Win Percentage", 
                     labFormat = labelFormat(between = "-", suffix = "%"), opacity = .7) %>%
  leaflet::addLegend(position = "bottomleft", labels = "Locations of NFL Stadiums", color = "blue")

