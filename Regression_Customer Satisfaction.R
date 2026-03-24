#### BUAN 348/448 
# Week 4
### Simple Linear Regression
#-----------------------------------------------------------------------------
# 1.Define/understand purpose
### Our goal is to figure out the drivers of overall satisfaction

# 2. Obtain data

park <- read.csv("customer satisfaction.csv")
str(park)
#------------------------------------------
# This data file contains customer satisfaction information from an amusement park.

# Weekend: Whether the respondent visited on a weekend
# num.child: Number of children they brought with them
# distance: distance traveled to the park
# rides: satisfaction level (0-100) with the rides
# games: satisfaction level (0-100) with the games
# wait: satisfaction level (0-100) with the waiting time
# clean: satisfaction level (0-100) with the cleanliness
# overall: overall satisfaction level (0-100)


# 3. Explore, clean, pre-process data
#-----------------------------------------------------------
## Step 1: scatter plot matrix
install.packages("car")
library(car)
# histograms on the diagonal
scatterplotMatrix(park[,-1])

# The fitted lines on scatterplots help us visualize the linear relationships.  

#-------------------------------------------------------------------
## Step 2: Transforming Variables before Computing Correlations
#-------------------------------------------------------------------

# Check: linear relationship?
# Pro :improves predictive performance
# But Hard to interpret

# For example: The relationship between 'satisfaction' and `distance` is not linear.

# Some commonly used transformations:

# * unit sales, revenue, household income, and price: log scale.
# * distance: an inverse or log scale.
# * right-tailed distributions: a square root or log
# * left-tailed distributions: a quadratic (x^2)
#-----------------------------------------------------------

# log transformation
park$logDistance<-log(park$distance)
scatterplotMatrix(park[,c(-1)])

# Box-Cox Transformation: 
# Box-Cox Transformation is a flexible approach to transform many different types 
# of non-normal distributed variable into a normal variable 
# it requires a coefficient for B-C transformation
# powerTransform() helps us to find the value of a coefficient
# bcPower() helps us to transform the value to be normally distributed

?powerTransform
powerTransform(park$distance)
c=coef(powerTransform(park$distance))
str(powerTransform(park$distance))

c=powerTransform(park$distance)$lambda

# c is 0.0515469   
# Creating a new variable called "bcDistance"
bcPower(park$distance,c)
park$bcDistance <- bcPower(park$distance,c)
scatterplotMatrix(park[,c(-1)])

#------------------------------------------
# Step 3: Correlation
#------------------------------------------
#  Correlation measures the linear relationship between variables.
#------------------------------------------

# Cohen's rules of thumb:
# |r| <= 0.1 give small (but should still be paid attention to) correlation, 
# |r| <= 0.3 is medium,
# |r| = 0.5 is large and can be observed by a casual observer.  

#-----------------------------------------------------

# Correlation matrix
cor(park[,c(2,4:9)])


install.packages("corrplot")
library(corrplot)

cmat <- cor(park[,c(2,4:9)])
corrplot.mixed(cmat)

# plot
k=plot(x=park$rides,y=park$overall,col="purple", xlab="satisfaction level (0-100) with the rides",ylab="overall satisfaction level (0-100)") 



#4. Reduce the data & 5. Specify task - Prediction using a single varible 
#choose rides

#6. Choose technique & Use Algorithm
#-----------------------------------------------------------------------
# Linear Model/regression with a single variable
#-----------------------------------------------------------------------


# 7. use Algorithm
# People who rate `rides` with high scores also rate the `overall satisfaction` highly.  
# The relationship between the two variables looks linear, with a positive slope.

lm1 <- lm(overall ~ rides, data=park)
# overall = -94.962 + 1.703*rides
# As expected, the slope is positive.

# 8. Assess result
summary(lm1)
str(summary(lm1))
summary(lm1)$r.squared 
summary(lm1)$coefficients[,c("t value")]
summary(lm1)$coefficients[,3]


#how to call Fstatistic value??

# Prediction:
park$pred=predict(lm1, newdata = park)

park2=as.data.frame(90)#to use predict function, the column name should be same as the original variable name.
predict(lm1, newdata = park2)

colnames(park2)

colnames(park2)[1]<-c("rides")
predict(lm1, newdata = park2)

summary(lm1)$coefficients
# If someone gives a rating of 90 for the `rides``, they are expected
# to give the following rating for overall `satisfaction`:
-94.962246 + 1.703285*90
# which comes out to be 58.3334.

# Note that this relationship is one of correlation, not necessarily causation!  
# Spending a few million dollars on new rides may not necessarily increase the overall satisfaction.
# The model is only applicable for predictions.

