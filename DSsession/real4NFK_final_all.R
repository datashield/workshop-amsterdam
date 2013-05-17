# LOAD REQUIRED LIBRARIES
library('datashieldclient')

GlobalAssign <- function(opals, variable) { 
  lapply(opals, function(o) {
    datashield.assign(o, variable, paste(o$table, variable, sep=":"))
  })
}

# LOGIN TO COLLABORATING SERVERS
credentials <- list(
  sslcert=paste0(Sys.glob('~'),'/.ssh/publickey.pem'),
  sslkey=paste0(Sys.glob('~'),'/.ssh/privatekey.pem'),
  ssl.verifyhost=0,
  ssl.verifypeer=0,
  sslversion=3)

ncds <- opal.login(url='https://lamp-api-32.rcs.le.ac.uk:8443', opts=credentials)
finrisk <- opal.login(url='https://opal.thl.fi:8443', opts=credentials)
kora <- opal.login(url='https://146.107.6.14:8443/', opts=credentials)
prevend <- opal.login(url='https://molgenis34.target.rug.nl:8443', opts=credentials)
hunt <- opal.login(url='https://opal.medisin.ntnu.no', opts=credentials)

opals<-list(ncds, finrisk, kora, prevend)

ncds$table <- "hop.HOP"
finrisk$table <- "HOPcopy.HOP"
kora$table <- "bioshare.HOP"
hunt$table <- "bioshare.HOP"
preventable <- "hop-prevend.HOP"

GlobalAssign(opals, "PM_BMI_CATEGORIAL")
GlobalAssign(opals, "GENDER")
GlobalAssign(opals, "DIS_CVA")
GlobalAssign(opals, "MEDI_LPD")
GlobalAssign(opals, "DIS_DIAB")
GlobalAssign(opals, "DIS_AMI")
GlobalAssign(opals, "LAB_TSC")
GlobalAssign(opals, "LAB_TRIG")
GlobalAssign(opals, "LAB_HDL")
GlobalAssign(opals, "LAB_GLUC_FASTING")
GlobalAssign(opals, "PM_BMI_CONTINUOUS")

# REMORE MISSING VALUES FOR CATEGORICAL VARIABLES
datashield.assign(opals, "BMI_NM",quote(replace.9.na(PM_BMI_CATEGORIAL)))
datashield.assign(opals, "DIS_CVA_NM",quote(replace.9.na(DIS_CVA)))
datashield.assign(opals, "MEDI_LPD_NM",quote(replace.9.na(MEDI_LPD)))
datashield.assign(opals, "DIS_DIAB_NM",quote(replace.9.na(DIS_DIAB)))
datashield.assign(opals, "DIS_AMI_NM",quote(replace.9.na(DIS_AMI)))

#LOOK AT UNIVARIATE DISTRIBUTION IN MORE DETAIL
datashield.aggregate(opals, quote(table.1d(DIS_CVA_NM)))                     
datashield.aggregate(opals, quote(table.1d(MEDI_LPD_NM)))
datashield.aggregate(opals, quote(table.1d(DIS_DIAB_NM)))                     
datashield.aggregate(opals, quote(table.1d(DIS_AMI_NM)))                     
datashield.aggregate(opals, quote(table.1d(GENDER)))                     
datashield.aggregate(opals, quote(table.1d(BMI_NM)))

datashield.aggregate(opals,quote(quantile.mean.ds(LAB_TSC)))
datashield.aggregate(opals,quote(quantile.mean.ds(LAB_TRIG)))
datashield.aggregate(opals,quote(quantile.mean.ds(LAB_HDL)))
datashield.aggregate(opals,quote(quantile.mean.ds(LAB_GLUC_FASTING)))
datashield.aggregate(opals,quote(quantile.mean.ds(PM_BMI_CONTINUOUS)))

datashield.histogram(opals,quote(LAB_HDL))
datashield.histogram(opals,quote(PM_BMI_CONTINUOUS))

datashield.aggregate(opals, quote(mean.a.by.b(PM_BMI_CONTINUOUS,BMI_NM)))

#Question 1
datashield.histogram(opals,quote(LAB_TSC))
datashield.aggregate(opals, quote(mean.a.by.b(LAB_TSC,GENDER)))
datashield.aggregate(opals, quote(var.a.by.b(LAB_TSC,GENDER)))

glm.mod1<-datashield.glm(opals, LAB_TSC ~ GENDER, quote(gaussian),quote(20))
glm.mod1

#opals <- list(ncds, kora)
#To determine if there is a difference across numerical variables between more than one group an ANOVA is used, this is can be viewed again using the boxplot function
datashield.assign(opals, 'bmi.f', quote(factor.create.3(BMI_NM)))
datashield.assign(opals, 'bmi.n', quote(as.numeric(BMI_NM)))

datashield.aggregate(opals, quote(table.1d(bmi.f)))

#For a better interpretation of the results we can use the summary function on the outcome of the analysis q21.
glm.mod2<-datashield.glm(opals, LAB_GLUC_FASTING ~ BMI_NM, quote(gaussian),quote(20))
glm.mod2

#Question 3
#To determine a trend over two categorical factor variables we first create a table of those variables using the function table.
datashield.aggregate(opals, quote(table.2d(DIS_DIAB_NM,BMI_NM)))

glm.mod3<-datashield.glm(opals, LAB_GLUC_FASTING ~ BMI_NM, quote(gaussian),quote(20))
glm.mod3
                    
glm.mod4<-datashield.glm(opals, LAB_GLUC_FASTING ~ bmi.n, quote(gaussian),quote(20))
glm.mod4
#opals <- list(ncds, finrisk, kora)
#We can then formally test the differing proportions across the categories using the saved table object q3 and the chi squared function chisq.test(..) .
#4. To determine if total serum cholesterol levels are associated with HDL cholesterol levels
#For example, this can be carried out by plotting a scatter plot or performing a correlation or
#using linear regression using LAB_TSC as an outcome and LAB_HDL  as a covariate other covariates
#can be added to determine other significant variables correlated with total serum cholesterol.
datashield.heatmap.plot(opals, quote(LAB_TSC),quote(LAB_HDL))
datashield.contour.plot(opals, quote(LAB_TSC),quote(LAB_HDL))

datashield.heatmap.plot(opals, quote(LAB_TSC),quote(LAB_GLUC_FASTING))
#opals <- list(ncds, kora)
#Question5
#To determine predictors of binary outcomes we need to use the function glm.
#The glm function can be used to analyse any input or output whether it be categorical or numerical.  If the outcome to analyse is numeric then we use the gaussian option of the glm.  If the outcome contains two categories we can use the binomial option.  So the type of glm function we need to answer research question 5 is the one which has family input binomial.  
glm.mod5<-datashield.glm(opals, DIS_DIAB_NM ~ bmi.f, quote(binomial),quote(20))
glm.mod5
#opals <- list(ncds, finrisk, kora)

datashield.assign(opals, 'sex.f', quote(factor.create.3(GENDER)))

glm.mod6<-datashield.glm(opals, DIS_DIAB_NM ~ sex.f+PM_BMI_CONTINUOUS+LAB_HDL, quote(binomial),quote(20))
glm.mod6

glm.mod7<-datashield.glm(opals, DIS_DIAB_NM ~ sex.f*PM_BMI_CONTINUOUS+LAB_HDL, quote(binomial),quote(20))
glm.mod7

#6. To determine predictors of taking lipid reducing medications
#For example, a logistic regression can, again, be used to determine whether
#HOP variables are significantly associated with a taking lipid reducing medications, MEDI_LPD_NM. 
glm.mod8<-datashield.glm(opals, MEDI_LPD_NM ~ sex.f*LAB_HDL+PM_BMI_CONTINUOUS+LAB_TSC, quote(binomial),quote(20))
glm.mod8

datashield.aggregate(opals,quote(quantile.mean.ds(LAB_HDL)))

datashield.assign(opals, 'HDL.1.5', quote(LAB_HDL-1.5))

glm.mod9<-datashield.glm(opals, MEDI_LPD_NM ~ sex.f*HDL.1.5+PM_BMI_CONTINUOUS+LAB_TSC, quote(binomial),quote(20))
glm.mod9