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
opals1<-list(server1)
opals2<-list(server2)

# ASSIGN DATA FROM OPAL DATASOURCE TO R AS A LIST
datashield.assign(server1, 'L', 'CNSIM.CNSIM')
datashield.assign(server2, 'L', 'CNSIM.CNSIM')
datashield.assign(server3, 'L', 'CNSIM.CNSIM')


# CHANGE THE FORMAT OF THE ASSIGNED DATA INTO A DATAFRAME
datashield.assign(opals, "D", quote(data.frame(as.list(L))))

# DISPLAY THE NAMES OF THE VARIABLES
datashield.aggregate(opals, quote(colnames(D)))



#LOOK AT UNIVARIATE DISTRIBUTION IN MORE DETAIL
datashield.aggregate(opals, quote(table.1d(D$DIS_CVA)))                     
datashield.aggregate(opals, quote(table.1d(D$MEDI_LPD)))
datashield.aggregate(opals, quote(table.1d(D$DIS_DIAB)))                     
datashield.aggregate(opals, quote(table.1d(D$DIS_AMI)))                     
datashield.aggregate(opals, quote(table.1d(D$GENDER)))                     
datashield.aggregate(opals, quote(table.1d(D$PM_BMI_CATEGORICAL)))

datashield.aggregate(opals,quote(quantile.mean.ds(D$LAB_TSC)))
datashield.aggregate(opals,quote(quantile.mean.ds(D$LAB_TRIG)))
datashield.aggregate(opals,quote(quantile.mean.ds(D$LAB_HDL)))
datashield.aggregate(opals,quote(quantile.mean.ds(D$LAB_GLUC_ADJUSTED)))
datashield.aggregate(opals,quote(quantile.mean.ds(D$PM_BMI_CONTINUOUS)))



datashield.histogram(opals,quote(D$LAB_HDL))
datashield.histogram(opals,quote(D$PM_BMI_CONTINUOUS))


datashield.aggregate(opals, quote(mean.a.by.b(D$PM_BMI_CONTINUOUS,D$PM_BMI_CATEGORICAL)))
datashield.aggregate(opals, quote(table.2d(D$PM_BMI_CATEGORICAL,D$GENDER)))



datashield.aggregate(opals,quote(t.test(D$LAB_HDL~D$GENDER)))


#Question 1
#To see if there is a difference between numeric variables across two factors we can use a boxplot to view the data.  The R function here is boxplot and the input is a$name of numeric variable~a$name of factor v ariable.
#boxplot(a$LAB_TSC~a$GENDER)

datashield.histogram(opals,quote(D$LAB_TSC))
datashield.aggregate(opals, quote(mean.a.by.b(D$LAB_TSC,D$GENDER)))
datashield.aggregate(opals, quote(var.a.by.b(D$LAB_TSC,D$GENDER)))


#This can then be formally tested using a t-test.  The R function we need is t.test, with the same input a$name of numeri c variable~a$name of factor v ariable
#t.test(a$LAB_TSC~a$GENDER)

datashield.aggregate(opals,quote(t.test(D$LAB_TSC~D$GENDER)))

#We can save the outcome to our workspace by adding in <-
q11<-datashield.aggregate(opals,quote(t.test(D$LAB_TSC~D$GENDER)))

glm.mod1<-datashield.glm(opals, D$LAB_TSC ~ D$GENDER, quote(gaussian),quote(20))
glm.mod1


#To determine if there is a difference across numerical variables between more than one group an ANOVA is used, this is can be viewed again using the boxplot function
#boxplot(a$LAB_GLUC_ADJUSTED~a$PM_BMI_CATERGORIAL)
datashield.assign(opals, 'bmi.f', quote(factor.create.3(D$PM_BMI_CATEGORICAL)))
datashield.assign(opals, 'bmi.n', quote(as.numeric(D$PM_BMI_CATEGORICAL)))

#The ANOVA test can be carried out using the function aov and the same inputs, saving the outcome as object q21
#q21<-aov(a$LAB_GLUC_ADJUSTED~a$PM_BMI_CATERGORIAL)
#we can see whats in q21 by typing it into the console.

datashield.aggregate(opals, quote(table.1d(bmi.f)))
                     
#For a better interpretation of the results we can use the summary function on the outcome of the analysis q21.


glm.mod2<-datashield.glm(opals, D$LAB_GLUC_ADJUSTED ~ bmi.f, quote(gaussian),quote(20))
glm.mod2



#Question 3
#To determine a trend over two categorical factor variables we first create a table of those variables using the function table.
#table(a$DIS_DIAB,a$PM_BMI_CATERGORIAL)

datashield.aggregate(opals, quote(table.2d(D$DIS_DIAB,D$PM_BMI_CATEGORICAL)))

datashield.table.2d(opals,quote(D$DIS_DIAB),quote(bmi.f))

glm.mod3<-datashield.glm(opals, D$LAB_GLUC_ADJUSTED ~ bmi.f, quote(gaussian),quote(20))
glm.mod3


#We can then formally test the differing proportions across the categories using the saved table object q3 and the chi squared function chisq.test(..) .
#chisq.test(q3)  

glm.mod4<-datashield.glm(opals, D$LAB_GLUC_ADJUSTED ~ bmi.n, quote(gaussian),quote(20))
glm.mod4


#4. To determine if total serum cholesterol levels are associated with HDL cholesterol levels
#For example, this can be carried out by plotting a scatter plot or performing a correlation or
#using linear regression using LAB_TSC as an outcome and LAB_HDL  as a covariate other covariates
#can be added to determine other significant variables correlated with total serum cholesterol.

datashield.heatmap.plot(opals, quote(D$LAB_TSC),quote(D$LAB_HDL))
datashield.contour.plot(opals, quote(D$LAB_TSC),quote(D$LAB_HDL))

datashield.heatmap.plot(opals, quote(D$LAB_TSC),quote(D$LAB_GLUC_ADJUSTED))
datashield.contour.plot(opals, quote(D$LAB_TSC),quote(D$LAB_GLUC_ADJUSTED))


#Question5
#To determine predictors of binary outcomes we need to use the function glm.
#The glm function can be used to analyse any input or output whether it be categorical or numerical.  If the outcome to analyse is numeric then we use the “gaussian” option of the glm.  If the outcome contains two categories we can use the “binomial” option.  So the type of glm function we need to answer research question 5 is the one which has family input “binomial”.  

datashield.table.2d(opals,quote(D$DIS_DIAB),quote(bmi.f))

glm.mod5<-datashield.glm(opals, D$DIS_DIAB ~ bmi.f, quote(binomial),quote(20))
glm.mod5

datashield.assign(opals, 'sex.f', quote(factor.create.3(D$GENDER)))


glm.mod6<-datashield.glm(opals, D$DIS_DIAB ~ sex.f+D$PM_BMI_CONTINUOUS+D$LAB_HDL, quote(binomial),quote(20))
glm.mod6

glm.mod7<-datashield.glm(opals, D$DIS_DIAB ~ sex.f*D$PM_BMI_CONTINUOUS+D$LAB_HDL, quote(binomial),quote(20))
glm.mod7


#6. To determine predictors of taking lipid reducing medications
#For example, a logistic regression can, again, be used to determine whether
#HOP variables are significantly associated with a taking lipid reducing medications, MEDI_LPD. 

glm.mod8<-datashield.glm(opals, D$MEDI_LPD ~ sex.f*D$LAB_HDL+D$PM_BMI_CONTINUOUS+D$LAB_TSC, quote(binomial),quote(20))
glm.mod8

datashield.aggregate(opals,quote(quantile.mean.ds(D$LAB_HDL)))

datashield.assign(opals, 'HDL.1.5', quote(D$LAB_HDL-1.5))

glm.mod9<-datashield.glm(opals, D$MEDI_LPD ~ sex.f*HDL.1.5+D$PM_BMI_CONTINUOUS+D$LAB_TSC, quote(binomial),quote(20))
glm.mod9

