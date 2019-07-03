#### Basics of R ####

# Step 1: Setting working directory
# If you're looking for a file to work on, we need to be in the right directory. So let's see where R is
# looking first using getwd()
getwd()

# If R is not in the right folder or it's too far out, you can set working directory in 2 ways:
#   1. Click on the "Files" tab on the bottom right box and navigate towards the folder you want. Click on the 
#     "More" tab and click on "Set As Working Directory".
#   2. Type in setwd("~/...)" replacing the ... with your directory - this also appears in the console when you do
#     the above.
setwd("~/Documents/GitHub/DataAnalysisTemplate")

# Step 2: Install and load necessary libraries
# Libraries are helpful packages which hold functions that can assist you in your data. For our purposes, let's
# get libraries dplyr and ggplot2. First, we need to see whether we have these packages. We can check by clicking
# the "Packages" tab on the bottom right box and searching for those names.
# If you don't have the package, let's install them. NOTE: you only have to do this once.
install.packages("dplyr")
install.packages("ggplot2")

# Now let's load our packages in our RScript. NOTE: you have to do this everytime you work in R
library(dplyr)
library(ggplot2)

