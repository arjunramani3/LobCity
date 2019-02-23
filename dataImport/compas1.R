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
both = merge(people, prison, by=c('first', 'last'))

write.csv(both, 'merged1.csv')


####PREPROCESSING
both$in_cust_date <- as.Date(both$in_custody)
both$out_cust_date <- as.Date(both$out_custody)
both$prison_length <- both$out_cust_date - both$in_cust_date
both$prison_length

library(dplyr)
trim <- select(both, c(sex, race, age, juv_fel_count, juv_misd_count, juv_other_count,
                  priors_count, c_charge_degree, c_charge_desc, is_recid, 
                  num_r_cases, r_charge_degree, r_charge_desc, is_violent_recid,
                  prison_length))
trim2 <- select(both, c(age, juv_fel_count, juv_misd_count, juv_other_count,
                        priors_count, c_charge_degree, c_charge_desc, is_recid, prison_length))