park <- read.csv("customer satisfaction.csv")
str(park)

install.packages("car")
library(car)
scatterplotMatrix(park[,-1])

park$logDistance<-log(park$distance)
scatterplotMatrix(park[,c(-1)])

?powerTransform
powerTransform(park$distance)
c=coef(powerTransform(park$distance))
str(powerTransform(park$distance))

c=powerTransform(park$distance)$lambda

bcPower(park$distance,c)
park$bcDistance <- bcPower(park$distance,c)
scatterplotMatrix(park[,c(-1)])

cor(park[,c(2,4:9)])

install.packages("corrplot")
library(corrplot)

cmat <- cor(park[,c(2,4:9)])
corrplot.mixed(cmat)

k=plot(x=park$rides,y=park$overall,col="purple", xlab="satisfaction level (0-100) with the rides",ylab="overall satisfaction level (0-100)")

lm1 <- lm(overall ~ rides, data=park)

summary(lm1)
summary(lm1)$r.squared 
summary(lm1)$coefficients[,c("t value")]
summary(lm1)$coefficients[,3]

lm2 <- lm(distance ~ rides + games + wait + clean, data=park)
summary(lm2)

park$pred=predict(lm1, newdata = park)

park2=as.data.frame(90)
predict(lm1, newdata = park2)

colnames(park2)

colnames(park2)[1]<-c("rides")
predict(lm1, newdata = park2)

summary(lm1)$coefficients
-94.962246 + 1.703285*90
