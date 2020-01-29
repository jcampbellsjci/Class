#######################################################
####          R Statistical Programming           #####
####   Lesson 3: Introduction to the Tidyverse    #####
#######################################################


# Tidyverse contains several outside packages, so we need to install it first
install.packages("tidyverse")
# Bring up the package with library()
library(tidyverse)

# We'll also be using the starwars dataset
initial.starwars <- starwars[, 1:10]


#### dplyr ####

# We can select (or index) specific columns using select
initial.starwars %>%
  # Select height and birth year of all characters
  select(height, birth_year)

# We can filter a dataframe with filter
initial.starwars %>%
  # Filter on only males
  filter(gender == "male")

# We can order rows in a specific order with arrange
initial.starwars %>%
  # Arrange by height
  arrange(height)
# To arrange by descending height, we have to specify desc()
initial.starwars %>%
  arrange(desc(height))

# We can rename columns using rename
initial.starwars %>%
  # Rename name to full_name
  rename(full_name = name)

# We create new columns using mutate
new.starwars <- initial.starwars %>%
  # Creating a new column that is the square root of height
  mutate(sqrt_height = sqrt(height))

# We can summarize info using summarize
initial.starwars %>%
  # Here we are finding the average height of all characters
  summarize(avg.height = mean(height, na.rm=T))

# We can use the pipe operator to chain multiple functions together
initial.starwars %>%
  # Filter characters taller than 200 cm
  filter(height > 200) %>%
  # Select the mass column
  select(mass) %>%
  # Order mass in descending order
  arrange(desc(mass))

# We can group functions by other variables using group_by
initial.starwars %>%
  # Grouping by gender
  group_by(gender) %>%
  # Finding average height
  summarize(avg.height = mean(height, na.rm=T)) %>%
  # Remember to ungroup if you want to perform non-grouped functions after 
  # grouping
  ungroup()

# We can use join functions similar to how we would in SQL
join_tbl <- new.starwars %>%
  select(name, sqrt_height) %>%
  .[1:5, ] %>%
  bind_rows(tibble(name = c("fake_1", "fake_2"),
                   sqrt_height = c(22, .96)))
# Inner join will show data only in both tables
sw_ij <- initial.starwars %>%
  inner_join(join_tbl, by = "name")
# Full join will show all data in both tables
sw_fj <- initial.starwars %>%
  full_join(join_tbl, by = "name")
# Left and right joins show all data in one table
sw_lj <- initial.starwars %>%
  left_join(join_tbl, by = "name")
sw_rj <- initial.starwars %>%
  right_join(join_tbl, by = "name")


#### tidyr ####

# We'll be using a dataset documenting the number of TB cases documented by WHO 
# in several countries in 1999 and 2000
initial.tb <- table4a %>%
  rename(Year1=`1999`, Year2=`2000`)

# We can convert from wide to long by gathering our data
long.tb <- gather(Year1, Year2, data = initial.tb,
                  key = Year, value = Cases)

# We can convert from long to wide by spreading our data
wide.tb<- spread(data = long.tb, key = Year, value = Cases)
