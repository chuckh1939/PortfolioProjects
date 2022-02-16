library(tidyverse)
library(dplyr)
library(janitor)
library(readxl)
library(here)

#read files from hard drive
dailyActivity <- read_excel("C:\\Users\\chuck\\Desktop\\Datasets\\FitBit\\dailyActivity_merged.xlsx")
sleepDay <- read_excel("C:\\Users\\chuck\\Desktop\\Datasets\\FitBit\\sleepDay_merged.xlsx")

#I really like glimpse function to see what I am working with. Head/str functions also also be helpful
glimpse(dailyActivity)
glimpse(sleepDay)

#simplify column names to make working with variables throughout analysis easier 
clean_names(dailyActivity) -> dailyActivity
clean_names(sleepDay) -> sleepDay

#rename date columns in preparation of join
rename(dailyActivity, date = activity_date) -> dailyActivity
rename(sleepDay, date = sleep_day) -> sleepDay

#check for duplicates
distinct(dailyActivity)
#sleepDay had around 5 duplicate rows so I save this output to sleepDay data frame
distinct(sleepDay) -> sleepDay 


#check if all users exist in both data frames. This tells me some users did not record any sleep data.
n_distinct(dailyActivity$id)
n_distinct(sleepDay$id)

#join sleepData on dailyActivity table. Verify new object has same rows as dailyActivity 
left_join(dailyActivity, sleepDay) -> dailyData

#summary statistics
dailyData %>% select(total_steps, total_distance, sedentary_minutes) %>% summary()
summary(dailyActivity [1:4])

#check for correlations
ggplot(data = dailyActivity, aes(x=total_steps, y=sedentary_minutes)) + geom_point()
ggplot(data = sleepDay, aes(x=total_minutes_asleep, y= total_time_in_bed)) +geom_point()



