#########################################
####### R Statistical Programming #######
####   Lesson 10: Model Validation  #####
#########################################

# Install and load the caret package
install.packages("caret")
library(caret)
library(mlbench)
library(yardstick)
library(broom)
library(tidyverse)

# Bring the sonar dataset into our environment
data("Sonar")
# We'll take a subset of these sonar columns
Sonar <- Sonar[, c(1:20, 61)]

#### Building a Basic GLM ####

# We can use caret's create data partition to split our data into a
# training and test set
data_split <- createDataPartition(Sonar$Class, p = .75, list = F)
# Index Sonar by data.split to get a training and testing set
training <- Sonar[data_split, ]
testing <- Sonar[-data_split, ]

# Use glm to try and predict class
sonar_glm1 <- glm(Class ~ ., data = training, family = "binomial")
summary(sonar_glm1)

# Get the predicted probabilities and classes
training_output <- augment(sonar_glm1, type.predict = "prob") %>%
  mutate(.fitted_class = factor(ifelse(.fitted >= .5, "R", "M")))
testing_output <- augment(sonar_glm1, newdata = testing,
                          type.predict = "response") %>%
  mutate(.fitted_class = factor(ifelse(.fitted >= .5, "R", "M")))
# Find accuracy of model
training_output %>%
  accuracy(truth = Class, estimate = .fitted_class)
testing_output %>%
  accuracy(truth = Class, estimate = .fitted_class)


#### Using Caret for Model Building ####

# Use train to develop a model and specify what method you want to use
sonar_glm_cv <- train(Class ~ ., data = training,
                      method = "glm", family = "binomial",
                      trControl = trainControl(method = "repeatedcv",
                                               repeats = 3, number = 5,
                                               savePredictions = T))
sonar_glm_cv$results
sonar_glm_cv

# By calling resample, we can see how caret performed on each held out fold
sonar_glm_cv$resample
# We can even plot the accuracy distribution
ggplot(data = sonar_glm_cv$resample, aes(x = Accuracy)) +
  geom_density(alpha = .2, fill="red")

# If we needed to get a non-caret object, we can extract the final model
sonar_glm2 <- sonar_glm_cv$finalModel
summary(sonar_glm2)

# We can try different validation methods by specifying them in
# the control parameter
sonar_glm_cv2 <- train(Class ~ ., data = training,
                       method = "glm", family = "binomial",
                       trControl=trainControl(method = "boot", number = 5,
                                              savePredictions = T))
sonar_glm_cv2
sonar_glm_cv2$resample
  
# Calling predict on the caret output brings back class predictions
class_predictions <- predict(sonar_glm_cv, newdata = testing)
# We can create confusion matrices with the caret package
confusionMatrix(data = class_predictions, reference = testing$Class,
                positive = "R")
