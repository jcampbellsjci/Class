###########################################
####     R Statistical Programming     ####
####      Lesson 2: Data Objects       ####
###########################################


#### Packages ####

# We can load up packages using library()
library(MASS)
# We install packages with install.packages()
install.packages("tidyverse")
# We need to install a package once, but load it up every new session
library(tidyverse)


#### Data Types ####

# Use class() to identify data type
class(100)
class("Jake")
class(factor(c("second", "first"), levels = c("first", "second")))
class(FALSE)

# Factors can be a bit confusing
# They have labels and levels
month_levels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
month_factor <- factor(c("Dec", "Aug", "Oct"), levels = month_levels)
month_factor
# The levels provide a specific order
sort(month_factor)
# We can resort and edit factors using the forcats package
fct_relevel(month_factor, c("Feb", "Mar"))

# We can change between data types using the as.x functions
# Changing from numeric to character
test_character <- as.character(100)
class(test_character)
# Changing from character to numeric
test_number <- as.numeric(test_character)
class(test_number)
# Going from factor directly to numeric bases the change on the levels
test_factor <- factor(c(100, 200, 300), levels = c(200, 300, 100))
test_factor
sort(test_factor)
as.numeric(test_factor)
# If we want to base it on the labels, we have to use as.character first
as.numeric(as.character(test_factor))


#### Data Objects ####

# Vectors hold one data type in one dimension
test_vector <- c(1:10)
test_vector

# Matrices hold one data type in two dimensions
# We have to specify the number of rows and columns in a matrix
test_matrix <- matrix(data = 1:9, nrow = 3, ncol = 3)
test_matrix

# Lists hold multiple data types
test_list <- list(name = c("Jake", "Hannah", "Jim"), 
                  age = c(25, 26, 33))
test_list

# Data frames hold multiple data types in two dimensions
test_df <- data.frame(name = c("Jake", "Hannah", "Jim"), 
                      age = c(25, 26, 33))
test_df

# We can use brackets to index specific parts of a data object
test_vector[3]
test_list[1]
# Multi-dimensional objects need to be indexed by row and columns
test_df[1, ]
test_matrix[, 3]
# We can index named columns or elements using $
test_df$name


#### Functions ####

# Functions are created using function()
# We specify argument names inside function()
test_function <- function(input) {
  #Whatever is inside the {} is what the function does
  input + 1
}

test_function(input = 1)
