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
casearrest = dbGetQuery(con, 'select * from casearrest')
compas_inter = dbGetQuery(con, 'select * from compas')
charge = dbGetQuery(con, 'select * from charge')

both = merge(people, prison, by=c('first', 'last', 'dob'))

#Marital Status
compas_inter_mar <- unique(select(compas_inter, c(first, last, marital_status)))
both2 <- merge(both, compas_inter_mar, by = c('first', 'last'))
write.csv(both2, 'merged1.csv')


####PREPROCESSING
both2$in_cust_date <- as.Date(both2$in_custody)
both2$out_cust_date <- as.Date(both2$out_custody)
both2$prison_length <- both2$out_cust_date - both2$in_cust_date
both2$prison_length

library(dplyr)
trim <- select(both2, c(first, last, dob, sex, race, age, marital_status, juv_fel_count, juv_misd_count, juv_other_count,
                  priors_count, c_charge_degree, c_charge_desc, is_recid, 
                  num_r_cases, r_charge_degree, r_charge_desc, is_violent_recid,
                  prison_length))
trim2 <- select(both2, c(first, last, dob, age, marital_status, juv_fel_count, juv_misd_count, juv_other_count,
                        priors_count, c_charge_degree, c_charge_desc, is_recid, prison_length))
trim2 <- trim2[trim2$is_recid != -1, ]

write.csv(trim, 'with_recid_vars.csv')
write.csv(trim2, 'trimmed.csv')

rps1 <- select(trim2, c(age, marital_status, juv_fel_count, juv_misd_count, juv_other_count,
                        priors_count, c_charge_degree, c_charge_desc, is_recid, prison_length))
