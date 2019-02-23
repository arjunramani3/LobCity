library(RCurl)
library(tidyverse)
url1 <- 'https://raw.githubusercontent.com/arjunramani3/compas-analysis/master/compas-scores-two-years.csv'
url2 <- 'https://raw.githubusercontent.com/arjunramani3/compas-analysis/master/compas-scores.csv'

compas2Year <- read_csv(url1)
compas <- read_csv(url2)
write_csv(compas2Year, 'compas2Year.csv')
write_csv(compas, 'compas.csv')
