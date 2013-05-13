# LOAD REQUIRED LIBRARIES
library('opal')
library(dsbaseclient)
library(dsteststatsclient)
library(dsmodellingclient)

# LOGIN TO COLLABORATING SERVERS
server1 <- opal.login('administrator', 'password', 'http://54.242.140.255')
server2 <- opal.login('administrator', 'password', 'http://54.242.46.59')
server3 <- opal.login('administrator', 'password', 'http://23.22.215.42')
opals <- list(server1,server2,server3)

# ASSIGN AGE DATA FROM OPAL DATASOURCE TO R
datashield.assign(server1, 'L', 'HOPpractical1.HOPpractical1')
datashield.assign(server2, 'L', 'HOPpractical2.HOPpractical2')
datashield.assign(server3, 'L', 'HOPpractical3.HOPpractical3')

# CHANGE THE FORMAT OF THE ASSIGN DATA IT INTO DATAFRAME
datashield.assign(opals, "D", quote(data.frame(as.list(L))))

# DISPLAY THE NAMES OF THE VARIABLES
datashield.aggregate(opals[[1]], quote(colnames(D)))

# ARE THERE DIFFERENCES IN CHOLESTEROL LEVELS BETWEEN MALES AND FEMALES?
# using the function 'datashield.t.test'
datashield.t.test(opals, quote(D$LAB_TSC), quote(D$GENDER))
# using the function 'datashield.glm'
datashield.glm(opals, D$LAB_TSC ~ D$GENDER, quote(binomial),quote(20))

