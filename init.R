my_packages = c("rmarkdown", "shinythemes", "shiny", "ggplot2", "rgdal", "rgeos", "plyr", "maptools", "sp", "plotly", "networkD3", "circlize", "leaflet", "shinycssloaders", "ggmap", "RColorBrewer", "wordcloud", "NLP", "tm", "tidyverse", "tidytext", "tidyr", "lubridate", "MASS", "caret", "ggrepel", "gt", "htmlwidgets")
install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}
invisible(sapply(my_packages, install_if_missing))
