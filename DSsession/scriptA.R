# LOAD REQUIRED LIBRARIES
library('datashieldclient')


# LOGIN TO COLLABORATING SERVERS
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
opals<-list(ncds, finrisk, hunt, prevend, kora)


# ASSIGN AGE DATA FROM OPAL DATASOURCE TO R
datashield.assign(ncds, 'L', 'hop.HOP')
datashield.assign(finrisk, 'L', 'HOPcopy.HOP')
datashield.assign(hunt, 'L', 'bioshare.HOP')
datashield.assign(prevend, 'L', 'hop-prevend.HOP')
datashield.assign(kora, 'L', 'bioshare.HOP')


# CHANGE THE FORMAT OF THE ASSIGN DATA IT INTO DATAFRAME
datashield.assign(opals, "D", quote(data.frame(as.list(L))))


# DISPLAY THE NAMES OF THE VARIABLES
datashield.aggregate(opals[[1]], quote(colnames(D)))


# Q1: ARE THERE DIFFERENCES IN CHOLESTEROL LEVELS BETWEEN MALES AND FEMALES?
a1 <- datashield.glm(opals, D$LAB_TSC ~ D$GENDER, quote(gaussian), quote(20))
summary(a1)

# Q2: DO PEOPLE WHO ARE OBESE HAVE HIGHER GLUCOSE LEVELS? (GLUCOSE LEVEL BY BMI CATEGORY)
a2 <- datashield.glm(opals, D$LAB_GLUC_FASTING ~ D$PM_BMI_CATEGORIAL, quote(gaussian), quote(20))
summary(a2)


# Q3: IS THE PREVALENCE OF DIABETES HIGHER AMONG THE OBESE PEOPLE?
# using the function 'datashield.table.2d' 
#datashield.table.2d(opals, quote(D$DIS_DIAB), quote(D$PM_BMI_CATEGORIAL))
# using the function 'datashield.glm' D$MEDI_LPD
a3 <- datashield.glm(opals, D$DIS_DIAB ~ D$PM_BMI_CATEGORIAL, quote(binomial), quote(20))
summary(a3)


# Q4: ARE THE VARIABLES TOTAL SERUM CHOLESTEROL AND TOTAL HDL CHOLESTEROL ASSOCIATED
# visualize using the function 'datashield.heatmap.plot'
datashield.heatmap.plot(opals, quote(D$LAB_TSC), quote(D$LAB_HDL))
# using the function 'datashield.glm'
a4 <- datashield.glm(opals, D$LAB_TSC ~ D$LAB_HDL, quote(gaussian), quote(20))
summary(a4)


# Q5: CAN WE PREDICT DIABETES, IN THE HOP 'POPULATION', USING SOME HOP VARIABLES?
# predict using non-fasting glucose and bmi
a5 <- datashield.glm(opals, D$DIS_DIAB ~ D$LAB_GLUC_FASTING + D$PM_BMI_CONTINUOUS, quote(binomial), quote(20))
summary(a5)


# Q6: ARE SOME HOP VARIABLES ASSOCIATED WITH A TAKING LIPID REDUCING MEDICATIONS?
a6 <- datashield.glm(opals, D$MEDI_LPD ~ D$LAB_TSC + D$PM_BMI_CONTINUOUS, quote(binomial), quote(20))
summary(a6)




