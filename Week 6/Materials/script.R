###############################################
########## R Statistical Programming ##########
####   Lesson 6: Linear Regression Pt. 1   ####
###############################################

# We're going to load up an outside dataset called prestige
  # Prestige comes from a social survey measuring how much prestige certain jobs
  # bring
  # It contains various pieces of info on different jobs
  # Can we develop a model to predict a job's prestige using information from 
  # the survey?

library(broom)
library(tidyverse)

# The prestige dataset is stored in a csv file
prestige <- read_csv(file = "~/Class/Week 6/Materials/prestige.csv",
                     col_types = cols(type = "f"))
  
  
#### Checking out the data ####
  
# We'll use the str() command to look at the different data types
str(prestige)

# Summary can be used to look at distribution and counts of our data
summary(prestige)

# Let's look at the graphical distribution of prestige
prestige %>%
  ggplot(aes(x = prestige)) +
  geom_histogram() +
  labs(title = "Distribution of Prestige")
prestige %>%
  ggplot(aes(x = prestige)) +
  geom_density(fill = "lightcoral") +
  labs(title = "Distribution of Prestige")


#### Simple Linear Regression ####

# Let's say we wanted to take education, x, and predict prestige, y
  
# Let's first look at a scatterplot of education and prestige
prestige %>%
    ggplot(aes(x = education, y = prestige)) +
    geom_point(size = 2) +
    labs(title = "Relationship Between Education and Prestige")

# We can create a linear model in r using lm()
pres.lm1 <- lm(prestige ~ education, data = prestige)
# To get info from the model, we need to call summary
summary(pres.lm1)
# We can clean up the output using broom package functions
# Put coefficient output into a tibble
tidy(pres.lm1)
# Put general model output into a tibble
glance(pres.lm1)
# Combine predictions into original tibble
output_pres <- augment(pres.lm1)

# We can plot our regression line on our previous scatterplot using the 
# geom_smooth function
  # Specify the method argument to be "lm"
prestige %>%
  ggplot(aes(x = education, y = prestige)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", color = "red", se = F) +
  labs(title = "Relationship Between Education and Prestige")

# Linear regression has assumptions
# 1. Normality of residuals
output_pres %>%
  ggplot(aes(sample = .resid)) +
  geom_qq() +
  geom_qq_line()
# 2. Constant variance
# 3. Linearity
output_pres %>%
  ggplot(aes(x = .fitted, y = .resid)) +
  geom_point() +
  geom_hline(yintercept = 0)
# 4. Independence of observations

# We may want to use our model to make future predictions
predict(pres.lm1)
# Let's say we had a vector of 10 new education levels
set.seed(1234)
new.edu <- data.frame(education = rnorm(10, mean = 10, sd = 3))
# We can use predict() to predict the prestige of these numbers
predict(pres.lm1, newdata = new.edu)


#### Simple Linear Regression with Categorical Independent ####

# Categorical data are treated a little bit differently in R
# Let's try and predict prestige using the type variable

# First we'll make a boxplot to show prestige distributions by type
prestige %>%
  ggplot(aes(x = type, y = prestige)) +
  geom_boxplot() +
  labs(title = "Relationship Between Type and Prestige")

# Let's make the model
pres.lm2 <- lm(prestige ~ type, data = prestige)
summary(pres.lm2)
# To see if the variable as a whole is significant, we can use anova()
anova(pres.lm2)

# Same assumptions still apply
augment(pres.lm2) %>%
  ggplot(aes(sample = .resid)) +
  geom_qq() +
  geom_qq_line()
augment(pres.lm2) %>%
  ggplot(aes(x = .fitted, y = .resid)) +
  geom_point(alpha = .2) +
  geom_hline(yintercept = 0)
