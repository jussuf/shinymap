places <- read.csv("data/places.csv")

# Make sure names are chr not factor
places$Kohanimi <- as.character(places$Kohanimi)

# subset of all place names to include towns and villages
selplaces <- c("küla", "alevik", "alev", "vallasisene linn", "linn")
places <- places[places$Nimeobjekti.liik %in% selplaces, ]