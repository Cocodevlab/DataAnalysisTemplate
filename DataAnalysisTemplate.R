#### Basics of R ####

#### Step 1: Setting working directory ####
# If you're looking for a file to work on, we need to be in the right directory. So let's see where R is
# looking first using getwd()
getwd()

# If R is not in the right folder or it's too far out, you can set working directory in 2 ways:
#   1. Click on the "Files" tab on the bottom right box and navigate towards the folder you want. Click on the 
#     "More" tab and click on "Set As Working Directory".
#   2. Type in setwd("~/...)" replacing the ... with your directory - this also appears in the console when you do
#     the above.
setwd("~/Documents/GitHub/DataAnalysisTemplate")


#### Step 2: Install and load necessary libraries ####
# Libraries are helpful packages which hold functions that can assist you in your data. For our purposes, let's
# get libraries dplyr, tidyverse and ggplot2. First, we need to see whether we have these packages. We can check 
# by clicking the "Packages" tab on the bottom right box and searching for those names.
# If you don't have the package, let's install them. NOTE: you only have to do this once.
install.packages("dplyr")
install.packages("ggplot2")
install.packages("tidyverse")
install.packages("psych")

# Now let's load our packages in our RScript. NOTE: you have to do this everytime you work in R
library(dplyr)
library(ggplot2)
library(tidyverse)
library(psych)


#### Step 3: Read in files ####
# Now we're ready to read in the file within the directory. By giving it a name, we can see it show up in our Global
# Environment and click on it to view the data frame
dataset = read.csv("Example Data - Sheet1.csv")


#### Step 4: Cleaning up your data ####
# First, let's rename R-unfriendly columns using rename(dataframe, new_name = old_name). 
# NOTE: you can do this for more than one column
dataset <- rename(dataset, "Subject_ID" = "Subject.ID")
#dataset <- dataset %>% rename(Subject_ID = Subject.ID)

# Second, let's keep only the necessary columns using select(dataframe, columns). 
# NOTE: you can name the columns or also index which columns
clean_dataset <- select(dataset, Subject_ID, Sex, Age_Months, Elapsed_Time, Visit1_Date, Excluded, 13:20)

# Third, remove trailing white spaces from columns using trimws(dataframe$column)
clean_dataset$Phase <- trimws(clean_dataset$Phase)

# Fourth, filter out the excluded rows using filter(dataframe, condition)
clean_dataset <- filter(clean_dataset, Excluded == "N")
clean_dataset <- filter(clean_dataset, approach != "NR")

# Fifth, changing value classes such as as.numeric(dataframe$column) from a factor to numeric
# NOTE: you can check the class by writing class(clean_dataset$score)
clean_dataset$score <- as.numeric(clean_dataset$score)

# Sixth, rename values in a column using dataframe$old_column = transmute(dataframe, new_column = 
# case_when(old_column == old_value ~ new_value))
# NOTE: If you want to just create a new column but not replace the old one, do the following
clean_dataset <- mutate(clean_dataset, new_score = case_when(score == 1 ~ 0, score == 2 ~ 1))
#clean_dataset$score = transmute(clean_dataset, new_score = case_when (score == 1 ~ 0, score == 2 ~ 1))


#### Step 5: Descriptive Statistics ####
table(clean_dataset$Sex)
describe(clean_dataset$Age_Months)


#### Step 6: Visualizing Data ####
# Let's set up the data into a new dataframe to graph it. Say we're interested in their average score for each phase
# for each participant:
performance <- clean_dataset %>%
  mutate(phase_order = case_when(Phase == "v2.occ2" ~ 1, Phase == "history" ~ 2, Phase == "test" ~ 3)) %>%
  group_by(Subject_ID, phase_order) %>%
  summarise(Accuracy = mean(new_score))
# Line graph
ggplot(performance, aes(x=phase_order, y=Accuracy)) +
  geom_point(aes(color=Subject_ID)) +  
  geom_line(aes(color=Subject_ID)) +
  geom_hline(yintercept = 0.50, linetype = "dashed") +
  scale_y_continuous("Accuracy") +
  scale_x_discrete(limit = c(1, 2, 3)) + 
  theme_classic() + ggtitle("Performance Across Phases") + theme(plot.title = element_text(hjust = 0.5))

# Now, say we're interested in how everyone performs on average per phase:
performance <- clean_dataset %>%
  group_by(Phase) %>%
  summarise(Accuracy = mean(new_score), SD = sd(new_score), SE = SD/sqrt(length(Subject_ID)))
# Bar graph
ggplot(performance, aes(x=Phase, y=Accuracy, fill=Phase)) +
  geom_bar(stat = "identity") + 
  geom_hline(yintercept = 0.50, linetype = "dashed") +
  scale_y_continuous("Accuracy") +
  theme_classic() + ggtitle("Performance Across Phases") + 
  geom_errorbar(performance, mapping = aes(ymin = Accuracy-SE, ymax = Accuracy+SE), width = 0.2, size=0.5) +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "none")



