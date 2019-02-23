library(RCurl)
library(tidyverse)
library('RSQLite')
url1 <- 'https://raw.githubusercontent.com/arjunramani3/compas-analysis/master/compas-scores-two-years.csv'
url2 <- 'https://raw.githubusercontent.com/arjunramani3/compas-analysis/master/compas-scores.csv'
url3 <- 'https://raw.githubusercontent.com/propublica/compas-analysis/master/cox-parsed.csv'

compas2Year <- read_csv(url1)
compas <- read_csv(url2) #doesn't have start and end day
cox <- read_csv(url3)

write_csv(compas2Year, 'compas2Year.csv')
write_csv(compas, 'compas.csv')

#SQL portion
con = dbConnect(RSQLite::SQLite(), dbname="compas.db")
alltables = dbListTables(con)
prison = dbGetQuery(con,'select * from prisonhistory' )
people = dbGetQuery(con,'select * from people' )
