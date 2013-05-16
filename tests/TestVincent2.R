#!/usr/bin/Rscript

library('datashieldclient')

GlobalAssign <- function(opals, variable) { 
  lapply(opals, function(o) {
   datashield.assign(o, variable, paste(o$table, variable, sep=":"))
  })
}

# Login in opal of each study
credentials <- list(
  sslcert=paste0(Sys.glob('~'),'/.ssh/publickey.pem'),
  sslkey=paste0(Sys.glob('~'),'/.ssh/privatekey.pem'),
  ssl.verifyhost=0,
  ssl.verifypeer=0,
  sslversion=3)

ncds <- opal.login(url='https://lamp-api-32.rcs.le.ac.uk:8443', opts=credentials)
hunt <- opal.login(url='https://opal.medisin.ntnu.no', opts=credentials)
prevend <- opal.login(url='https://molgenis34.target.rug.nl:8443', opts=credentials)
finrisk <- opal.login(url='https://opal.thl.fi:8443', opts=credentials)
kora <- opal.login(url='https://146.107.6.14:8443/', opts=credentials)
#opals<-list(ncds, finrisk, hunt, prevend, kora)

ncds$table <- "hop.HOP"
hunt$table <- "bioshare.HOP"
prevend$table <- "hop-prevend.HOP"
finrisk$table <- "HOPcopy.HOP"
kora$table <- "bioshare.HOP"


# Q1: ARE THERE DIFFERENCES IN CHOLESTEROL LEVELS BETWEEN MALES AND FEMALES?
# using the function 'datashield.t.test'
# datashield.t.test(opals, quote(D$LAB_TSC), quote(D$GENDER))
# using the function 'datashield.glm'
# GLM test

opals<-list(ncds, finrisk, hunt, kora)
GlobalAssign(opals, "LAB_TSC")
GlobalAssign(opals, "GENDER")
daa1 <- datashield.glm(opals, LAB_TSC ~ GENDER, quote(gaussian), quote(20))
summary(a1)


# Q2: DO PEOPLE WHO ARE OBESE HAVE HIGHER GLUCOSE LEVELS? (GLUCOSE LEVEL BY BMI CATEGORY)
opals<-list(ncds, finrisk, kora)
GlobalAssign(opals, "LAB_GLUC_FASTING")
GlobalAssign(opals, "PM_BMI_CATEGORIAL")
a2 <- datashield.glm(opals, LAB_GLUC_FASTING ~ PM_BMI_CATEGORIAL, quote(gaussian), quote(20))
summary(a2)


# Q3: IS THE PREVALENCE OF DIABETES HIGHER AMONG THE OBESE PEOPLE?
# using the function 'datashield.table.2d' 

opals<-list(ncds, finrisk, hunt, prevend, kora)
GlobalAssign(opals, "PM_BMI_CATEGORIAL")
GlobalAssign(opals, "DIS_DIAB")
datashield.table.2d(opals, quote(DIS_DIAB), quote(PM_BMI_CATEGORIAL))

# using the function 'datashield.glm' D$MEDI_LPD
a3 <- datashield.glm(opals, DIS_DIAB ~ PM_BMI_CATEGORIAL, quote(binomial), quote(20))
summary(a3)


# Q4: ARE THE VARIABLES TOTAL SERUM CHOLESTEROL AND TOTAL HDL CHOLESTEROL ASSOCIATED
# visualize using the function 'datashield.heatmap.plot'
opals<-list(ncds, finrisk, hunt, prevend kora)
GlobalAssign(opals, "LAB_HDL")
GlobalAssign(opals, "LAB_TSC")
datashield.heatmap.plot(opals, quote(LAB_TSC), quote(LAB_HDL))
# using the function 'datashield.glm'
a4 <- datashield.glm(opals, LAB_TSC ~ LAB_HDL, quote(gaussian), quote(20))
summary(a4)


# Q5: CAN WE PREDICT DIABETES, IN THE HOP 'POPULATION', USING SOME HOP VARIABLES?
# predict using non-fasting glucose and bmi
GlobalAssign(opals, "PM_BMI_CONTINUOUS")
GlobalAssign(opals, "LAB_GLUC_FASTING")

a5 <- datashield.glm(opals, DIS_DIAB ~ LAB_GLUC_FASTING + PM_BMI_CONTINUOUS, quote(binomial), quote(20))
summary(a5)


# Q6: ARE SOME HOP VARIABLES ASSOCIATED WITH A TAKING LIPID REDUCING MEDICATIONS?
GlobalAssign(opals, "MEDI_LPD")

a6 <- datashield.glm(opals, MEDI_LPD ~ LAB_TSC + PM_BMI_CONTINUOUS, quote(binomial), quote(20))
summary(a6)
