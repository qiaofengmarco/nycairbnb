my_packages = c("shinythemes", "shiny", "ggplot2", "rgdal", "rgeos", "plyr", "maptools", "sp", "plotly", "networkD3", "chorddiag", "circlize", "leaflet", "shinycssloaders", "ggmap", "RColorBrewer", "wordcloud", "NLP", "tm", "tidyverse", "tidytext", "tidyr", "lubridate", "MASS", "caret", "ggrepel", "gt", "htmlwidgets", "rmarkdown")
install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}
install.packages("devtools")
devtools::install_github("mattflor/chorddiag", build_vignettes = TRUE)
invisible(sapply(my_packages, install_if_missing))