my_packages = c("rmarkdown", "shinythemes", "shiny", "ggplot2", "plyr", "maptools", "sp", "plotly", "networkD3", "circlize", "shinycssloaders", "ggmap", "RColorBrewer", "wordcloud", "tm", "tidyverse", "tidytext", "tidyr", "lubridate", "MASS", "caret", "ggrepel", "gt", "htmlwidgets")
install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}
install.packages("rgdal", repos="http://R-Forge.R-project.org")
install.packages("leaflet")
invisible(sapply(my_packages, install_if_missing))
