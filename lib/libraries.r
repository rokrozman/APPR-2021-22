library(readr)
library(dplyr)
library(tidyr)
library(knitr)
library(rvest)
library(gsubfn)
library(tmap)
library(shiny)
library(tibble)
library(gghighlight)

library(ggalt)
library(caret)
library(kernlab)
library(dplyr)
library(PRROC)
library(ROCR)

library(ggplot2)
library(ggforce)
library(ggimage)
library(scales)
library(mosaic)

library(shinyWidgets)



options(gsubfn.engine="R")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding="UTF-8")
