###############################################
########## R Statistical Programming ##########
####   Lesson 7: Linear Regression Pt. 2   ####
###############################################

# Load up some packages
library(car)
library(GGally)
library(mlbench)
library(MASS)
library(broom)
library(tidyverse)

# We're going to be loading up the crime dataset
crime <- read_csv(file = "~/Class/Week 7/Materials/uscrime.csv")
# Also going to load up the Ozone dataset
data("Ozone")
# Also loading up a version of the mtcars data set
mtcars <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/auto-mpg/auto-mpg.data")
# Editing column V4 to make it numeric
mtcars$V4 <- as.numeric(as.character(
  ifelse(mtcars$V4 == "?", "NA", mtcars$V4)))


#### Getting a look at our data ####

# Let's look at a summary of our data
summary(crime)
# And also what data types we are dealing with
str(crime)

# Creating a scatterplot matrix
ggpairs(crime[, c("GDP", "Ed", "y")],
        lower = list(continuous = "smooth"))


#### Developing a linear model ####

# Let's start by making a simple model with just two variables; GDP and Ed
# We'll be predicting the crime rate, y
crime.lm1 <- lm(y ~ GDP + Ed, data=crime)
summary(crime.lm1)
# Check model assumptions
augment(crime.lm1) %>%
  ggplot(aes(sample = .resid)) +
  geom_qq_line() +
  geom_qq()
augment(crime.lm1) %>%
  ggplot(aes(x = .fitted, y = .resid)) +
  geom_point() +
  geom_hline(yintercept = 0)
# We have an additional assumption that variables are not colinear
vif(mod = crime.lm1)

# Let's make a model using some additional variables
crime.lm2 <- lm(y ~ GDP + Ed + Po1 + Po2, data = crime)
summary(crime.lm2)

# We can use anova() to compare nested models 
anova(crime.lm1, crime.lm2)

# Now let's check the model assumptions
augment(crime.lm2) %>%
  ggplot(aes(sample = .resid)) +
  geom_qq_line() +
  geom_qq()
augment(crime.lm2) %>%
  ggplot(aes(x = .fitted, y = .resid)) +
  geom_point() +
  geom_hline(yintercept = 0)
vif(crime.lm2)
# po1 and po2 appear to be very strongly correlated
crime %>%
  ggplot(aes(Po1, Po2)) +
  geom_point()
# We can remove one of these variables
crime.lm3 <- lm(y ~ GDP + Ed + Po1, data = crime)
vif(crime.lm3)


#### Transforming the Response ####

# Using the ozone dataset to try and predict maximum ozone reading (V4)
# Create the linear model
ozone.lm1 <- lm(V4 ~ V1 + V7, data = Ozone)
summary(ozone.lm1)
# Verify assumptions
augment(ozone.lm1) %>%
  ggplot(aes(sample = .resid)) +
  geom_qq_line() +
  geom_qq()
augment(ozone.lm1) %>%
  ggplot(aes(x = .fitted, y = .resid)) +
  geom_point() +
  geom_hline(yintercept = 0)

# Check out the distribution of the response
Ozone %>%
  ggplot(aes(x = V4)) +
  geom_histogram()

# Use box-cox transformation from the MASS package to help identify best transformation
bc <- boxcox(V4 ~ V1 + V7, data = Ozone)
bc
# Identify which value of x leads to the most normalized data
bc$x[which.max(bc$y)]

# Create a model of where the response is taken to the .5 power (or square root)
ozone.lm2 <- lm(sqrt(V4) ~ V1 + V7, data = Ozone)
summary(ozone.lm2)
augment(ozone.lm2) %>%
  ggplot(aes(sample = .resid)) +
  geom_qq_line() +
  geom_qq()
augment(ozone.lm2) %>%
  ggplot(aes(x = .fitted, y = .resid)) +
  geom_point() +
  geom_hline(yintercept = 0)


#### Polynomial Regression ####

# Try predicting horsepower (V3) based on mpg (V1)
mtcars %>%
  ggplot(aes(x = V1, y = V3)) +
  geom_point() +
  #smooth line
  geom_smooth(se = F, color = "red") +
  #linear line
  geom_smooth(method = "lm", se = F) +
  #curved line
  geom_smooth(method = "lm", se = F, formula = y ~ poly(x, 2), color = "green")

# Try modeling the two variables 
mtcars.lm1 <- lm(V3 ~ V1, data = mtcars)

# Check assumptions
augment(mtcars.lm1) %>%
  ggplot(aes(sample = .resid)) +
  geom_qq_line() +
  geom_qq()
augment(mtcars.lm1) %>%
  ggplot(aes(x = .fitted, y = .resid)) +
  geom_point() +
  geom_hline(yintercept = 0)

# We can model using polynomials of predictors
mtcars.lm2 <- lm(V3 ~ poly(V1, degree = 2), data = mtcars)
summary(mtcars.lm2)

# Use a partial f-test to determine if adding a polynomial to the function 
# improves the model
anova(mtcars.lm1, mtcars.lm2)
