#########################################
####    R Statistical Programming    ####
#### Week 9: Metrics and Enginnering ####
#########################################


#### Loading Up ####

install.packages("caret")
install.packages("yardstick")
install.packages("pROC")
library(caret)
library(pROC)
library(yardstick)
library(MASS)
library(tidyverse)

data("mpg")
data("biopsy")


#### Model Metrics ####

# Let's first build some models to predict hwy and class
mpg_model <- lm(hwy ~ displ + cyl + drv, data = mpg)
summary(mpg_model)
biopsy_model <- glm(class ~ V1 + V5 + V7, data = biopsy, family = "binomial")
summary(biopsy_model)

# For linear regression, we can look at resdiuals to determine
# model performance
mpg_output <- augment(mpg_model)

# MAE: mean absolute error
mean(abs(mpg_output$.resid))
mpg_output %>%
  mae(truth = hwy, estimate = .fitted)
# MSE: mean square error
mean(mpg_output$.resid^2)
# RMSE: root-mean square error
sqrt(mean(mpg_model$residuals^2))
mpg_output %>%
  rmse(truth = hwy, estimate = .fitted)

# For classification, we can use both our class and probability predictions
biopsy_output <- augment(biopsy_model, type.predict = "prob") %>%
  mutate(.fitted_class = factor(ifelse(.fitted >= .5,
                                       "malignant", "benign"))) %>%
  select(class, V1, V5, V7, .fitted, .fitted_class)

# Accuracy can be used to find the total percent accuracy
mean(biopsy_output$class == biopsy_output$.fitted_class)
biopsy_output %>%
  accuracy(truth = class, estimate = .fitted_class)
# Accuracy might not tell the whole story
cm_biopsy <- xtabs(~ .fitted_class + class, data = biopsy_output)
cm_biopsy

# Sensitivity is the proportion of true positives over all actual positives
cm_biopsy[2, 2] / (cm_biopsy[1, 2] + cm_biopsy[2, 2])
# By default, the first level is the positive class
options(yardstick.event_first = FALSE)
biopsy_output %>%
  sens(truth = class, estimate = .fitted_class)
# Specificity does the same with the negative class
cm_biopsy[1, 1] / (cm_biopsy[2, 1] + cm_biopsy[1, 1])
biopsy_output %>%
  spec(truth = class, estimate = .fitted_class)

# The ROC curve and its AUC value give us an idea of how classification
# performs at different threshholds
roc(response = biopsy_output$class,
    predictor = biopsy_output$.fitted, plot = T)


#### Feature Engineering ####

# Let's look at how we can manipulate some columns in mpg
# We'll add in some random columns to represent car price and year made
set.seed(1234)
mpg <- mpg %>%
  mutate(price = paste("$", round(rnorm(n = 234, mean = 20000, sd = 5000),
                                  digits = 0), sep = "")) %>%
  mutate(production_date = sample(seq(as.Date('1998/01/01'),
                                      as.Date('2008/12/31'), by="day"), 234))

# Maybe we want to simplify trans to either be auto or manual
# str_split can be used to split up a character vector
transmission <- str_split_fixed(string = mpg$trans, pattern = "[(]", n = 2)
mpg <- mpg %>%
  mutate(trans_simplified = transmission[, 1])

# Price could be good to model with, but the $ makes it a character
# Use gsub to substitute out values
mpg <- mpg %>%
  mutate(price = gsub(pattern = "[$]", replacement = "", price)) %>%
  mutate(price = as.numeric(price))

# Date types can be created by as.Date
# We specify format using the format argument
as.Date("2020-03-24", format = "%Y-%m-%d")
# We could pull out a specific aspect of a date type using format
mpg <- mpg %>%
  mutate(month = format(x = production_date, "%m"),
         year = format(x = production_date, "%Y"),
         day = format(x = production_date, "%d"))
