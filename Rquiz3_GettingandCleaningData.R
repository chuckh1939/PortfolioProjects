library(dplyr)

#1
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "C:/Users/chuck/Desktop/fhdh/microdata.csv")
read.csv("C:/Users/chuck/Desktop/fhdh/microdata.csv") -> microdata

head(microdata)
names(microdata)

agricultureLogical <- microdata$ACR == 3 & microdata$AGS ==6
which(agricultureLogical)



#2
install.packages('jpeg')
library(jpeg)

download.file( "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", 
               "C:/Users/chuck/Desktop/fhdh/jeff.jpg", mode = 'wb'  )
readJPEG("C:/Users/chuck/Desktop/fhdh/jeff.jpg", native = 'T') -> jeff

quantile(jeff, probs = c(.3, .8))



#3
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", 
              "C:/Users/chuck/Desktop/fhdh/product.csv")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv",
              "C:/Users/chuck/Desktop/fhdh/educational.csv")

read.csv("C:/Users/chuck/Desktop/fhdh/product.csv") -> product
read.csv("C:/Users/chuck/Desktop/fhdh/educational.csv") -> educational
    
#renaming columns in preperation of merge and for simplicity sake
rename(product, CountryCode = X, GDP = Gross.domestic.product.2012, country = X.2, millions = X.3) -> product        

#merging two tables together on CountryCode
mergedDT <- merge(product, educational, by = 'CountryCode')

#selecting only required columns as the 31 columns is a lot to look at
mergedDT <- mergedDT[, c(1,2,4,5,12)]

#empty string values in GDP need to be removed from data set to get the right answer
#first get logical fector showing where they exist
logicalempty <- mergedDT$GDP == ""

#then we use which function to find the rows and remove them with "-" at beginning of combine function
mergedDT <- mergedDT[-c(which(logicalempty)),]

#arranging by GDP returned strange results out of numerical order       
arrange(mergedDT, desc(GDP))

#summary shows that it is listed as character data type, possibly when merged 
summary(mergedDT)

#change to numeric and now arrange function displays proper order
mergedDT$GDP = as.numeric(mergedDT$GDP)


#4
tapply(mergedDT$GDP, mergedDT$Income.Group, mean)


#5
breaks <- quantile(mergedDT$GDP, probs = seq(0, 1, 0.2), na.rm = T)
cut(mergedDT$GDP, breaks = breaks) -> mergedDT$quantileGDP

