# uncomment the below line to set the working directory 
#(CHANGE YOUR USER ID ACCORDINGLY!)
# setwd("/home/datashield/ws2/workshop-amsterdam/Rsession")

a<-read.csv("data.csv")

is.factor(a[,7])

a[,7]<-as.factor(a[,7])

a[,8]<-as.factor(a[,8])

a[,9]<-as.factor(a[,9])

a[,10]<-as.factor(a[,10])

a[,11]<-as.factor(a[,11])

a[,12]<-as.factor(a[,12])


#########################Q1
boxplot(a$LAB_TSC~a$GENDER)

t.test(a$LAB_TSC~a$GENDER)
##or
q1<-glm(a$LAB_TSC~a$GENDER,family="gaussian")
summary(q1)


##########################Q2
boxplot(a$LAB_GLUC_ADJUSTED~a$PM_BMI_CATERGORIAL)
q21<-aov(a$LAB_GLUC_ADJUSTED~a$PM_BMI_CATERGORIAL)
summary(q21)
q22<-glm(a$LAB_GLUC_ADJUSTED~a$PM_BMI_CATERGORIAL)
summary(q22)
##########################Q3
table(a$DIS_DIAB,a$PM_BMI_CATERGORIAL)
q3<-table(a$DIS_DIAB,a$PM_BMI_CATERGORIAL)
chisq.test(q3)  

#########################q4
  
plot(a$LAB_TSC,a$LAB_GLUC_ADJUSTED)


cor(a$LAB_TSC,a$LAB_GLUC_ADJUSTED)

cor.test(a$LAB_TSC,a$LAB_GLUC_ADJUSTED)
q4<-glm(a$LAB_TSC~a$LAB_GLUC_ADJUSTED)
summary(q4)

###########################q5
q5<-glm(a$DIS_DIAB~a$LAB_GLUC_ADJUSTED+a$PM_BMI_CONTINUOUS,family="binomial")
summary(q5)

###########################q6
q6<-glm(a$MEDI_LPD~a$LAB_TSC+a$PM_BMI_CONTINUOUS,family="binomial")
summary(q5)

