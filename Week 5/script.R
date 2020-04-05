########################################
####    R Statistical Programming   ####
####   Lesson 5: The Importance of  ####
####     Exploratory Analysis       ####
########################################

library(GGally)
library(tidyverse)
data("iris")

#### Summary Statistics ####

# mean calculates the average
mean(iris$Sepal.Length)
# median calculates the middle value
median(iris$Sepal.Length)

# Quantiles bin the values based on order
quantile(iris$Sepal.Length)
# By specifying probs, we can specify where those bins are cut
quantile(iris$Sepal.Length, probs = c(0, .33, .66, 1))

# table can be used to get counts of different levels
table(iris$Species)

# Variance measures how much our data is spread out
var(iris$Petal.Length)
# Standard deviation puts the variance on the same level as the variable
sd(iris$Petal.Length)

# Covariance measures how related two variables are
cov(iris$Sepal.Length, iris$Sepal.Width)
# Correlation standardizes covariance on a scale of -1 to 1
cor(iris$Sepal.Length, iris$Sepal.Width)

# Could get a lot of this info via the summary function
summary(iris)

# A lot of summary statistics can be used with dplyr to get interesting
# grouped statistics
iris %>%
  group_by(Species) %>%
  summarize(max_width = max(Petal.Width),
            min_length = min(Petal.Length))


#### Plotting ####

# Use plots correctly, or else results can be ugly
# Ex: using a scatterplot with a categorical variable
iris %>%
  ggplot(aes(x = Species, y = Sepal.Length)) +
  geom_point()

# Avoid plotting no-no's, like rescaling
iris %>%
  .[1:145, ] %>% 
  ggplot(aes(x = Species)) +
  geom_bar() +
  coord_cartesian(ylim = c(40, 50))

# To plot multiple relationships at once, we can use ggpairs
ggpairs(iris)
# Base pairs is faster, but focuses on scatterplots
pairs(iris)
