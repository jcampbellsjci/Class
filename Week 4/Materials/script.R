###############################################
####      R Statistical Programming        ####
####   Lesson 4: The Grammar of Graphics   ####
###############################################


#### Data Prep ####

# First need to make sure we have ggplot2 installed and loaded
  # Part of the tidyverse series of packages
library(tidyverse)

# We'll be using the diamonds dataset to introduce ggplot2
data("diamonds")
# Take a sample from diamonds 
  # Planning on doing some advanced plots that can take time with a
  # large dataset
set.seed(1234)
diamonds <- diamonds %>%
  sample_n(size = 5000, replace = F)


#### ggplot2 Coding ####

# Let's start by creating a scatterplot comparing price and carat
  # We start by calling the ggplot command
  # "+" is used to string code into larger chuncks
  ggplot(data = diamonds, aes(x = carat, y = price)) +
  # Now we'll specify the designated geom; think of this as the type of plot 
  # you want
  geom_point()

# We can add additional aesthetics, such as shape or color
  ggplot(data = diamonds, aes(x = carat, y = price, 
                              shape = cut, color = clarity)) + 
  geom_point() +
  labs(x = "Diamond Carat", y = "Diamond Price ($)", 
       title = "Diamond Price vs. Diamond Carat",
       color = "ABC")


#### Common Plotting ####

# Histogram
ggplot(data = diamonds, aes(x = price)) +
  geom_histogram()
# We can specify the number of bins with a histogram
ggplot(data = diamonds, aes(x = price)) +
  geom_histogram(bins = 1)

# Barplots
ggplot(data = diamonds, aes(x = cut)) +
  geom_bar()
# We can create different filled bar plots by specifying the position argument
# Stacked bar
ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "stack")
# 100% filled bar
ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill")
# Plot fill levels next to instead of on top of each other
ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge")

# Density plot
ggplot(data = diamonds, aes(x = price)) +
  geom_density()

# Boxplots
ggplot(data = diamonds, aes(x = cut, y = price)) +
  #geom_point()
  geom_boxplot()


#### Plot Layering ####

# We can layer plots of different types on each other
# For example, say we wanted to layer both a smooth line on top of a 
# scatterplot
ggplot(data = diamonds, aes(x = carat, y = price)) +
  # First plot the points
  geom_point() +
  # Than plot the smooth line
  geom_smooth(size = 2) +
  labs(x = "Diamond Carat", y = "Diamond Price ($)", 
       title = "Diamond Price vs. Diamond Carat")

  
#### Faceting ####
  
# Let's take the carat/price scatter plot and facet it on cut
ggplot(data = diamonds, aes(x = carat, y = price)) + 
  geom_point() + 
  facet_wrap(~ cut) + 
  geom_smooth() + 
  labs(x = "Diamond Carat", y = "Diamond Price ($)", 
       title = "Diamond Price vs. Diamond Carat by Cut")

# Here, we facet on every combo of color and cut
ggplot(data = diamonds, aes(x = carat, y = price)) + 
  geom_point() + 
  facet_wrap(~ cut + color) + 
  #facet_grid(cut ~ color)
  geom_smooth() + 
  labs(x = "Diamond Carat", y = "Diamond Price ($)", 
       title = "Diamond Price vs. Diamond Carat by Cut")


#### Additional Functions ####

# Scale arguments can help us do a couple things: 
# Change labels
ggplot(data = diamonds, aes(x = cut)) +
  geom_bar(fill = "lightcoral") +
  scale_x_discrete(labels = c("A", "B", "C", "D", "E"))

# Change scale limits
# Discrete
ggplot(data = diamonds, aes(x = cut)) +
  geom_bar(fill = "lightcoral") +
  scale_x_discrete(limits = c("Fair", "Good"))
# Continous
ggplot(data = diamonds, aes(x = cut, y = price)) +
  geom_boxplot(fill = "skyblue") +
  scale_y_continuous(limits = c(1000, 1500))

# Change legend info
ggplot(data = diamonds, aes(x = carat, y = price, color = cut)) +
  geom_point() +
  scale_color_discrete(labels = c("A", "B", "C", "D", "E")) +
  labs(color = "Diamond Cuts")
# Can also change color/fill values
ggplot(data = diamonds, aes(x = clarity, fill=cut)) +
  geom_bar(position = "stack") +
  scale_fill_manual(values = c("blue", "green", "red",
                               "lightcoral", "skyblue"))

# Theme arguments allow us to change up visual characteristics
# We can use it to adjust title positions and angles
ggplot(data = diamonds, aes(x = cut)) +
  geom_histogram(stat = "count", fill = "lightcoral", col = "black") +
  labs(title = "Count of Diamond Cuts") +
  theme(plot.title = element_text(hjust = .5), 
        axis.text.x = element_text(angle = 45, hjust = 1))

# Can also adjust things like font, color, or legend position
ggplot(data = diamonds, aes(x = carat, y = price, color = cut)) + 
  geom_point() +
  theme(legend.position = "top", 
        axis.title.y = element_text(face = "bold", color = "red"),
        axis.text.x = element_text(size = 100))
  