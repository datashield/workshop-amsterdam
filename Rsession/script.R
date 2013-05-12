# load the data
a <- read.table("dummyHOPNCDS.csv", head=T, sep=",")


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
