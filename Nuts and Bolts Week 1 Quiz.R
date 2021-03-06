#Nuts and Bolts R programming: Week 1 Coursera quiz

library("tidyverse")
read.csv("C:\\Users\\chuck\\Desktop\\CourseraR\\hw1_data.csv") -> ozoneData

#view first two rows of the table
head(ozoneData, n = 2)

#last two rows
tail(ozoneData, n=2)

#view everything on row 47
ozoneData[47,]

#summary lists statistics for each variable, including number of NA's
summary(ozoneData)

#view average of a column removing NA's
mean(ozoneData$Ozone, na.rm = T)

#view average of every column  
apply(ozoneData, 2, mean, na.rm = T)

#Filter data with that meets conditions Subset function,
#and perform calculation on column
subset(ozoneData, Ozone > 31 & Temp >90) -> tempData
mean(tempData$Solar.R)

subset(ozoneData, Month == 6) -> juneData
mean(juneData$Temp, na.rm = T)

#Pivot table to view average Ozone by each Month
tapply(ozoneData$Ozone, ozoneData$Month, max, na.rm = T)




