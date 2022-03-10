#reading multiple files from folder/directory with functions

#pollutant mean fuction takes directory, "nitrate" or "sulfate", and optional range of files, returns mean
pollutantmean <- function(directory, pollutant, id = 1:332){
  fileList <- list.files(directory, pattern = ".csv", full.names = T)
  values <- numeric()
  
  for(i in id){
    data <- read.csv(fileList[i])
    values <- c(values, data[[pollutant]])
  }
  mean(values, na.rm  = T)
}

pollutantmean("C:\\Users\\chuck\\Desktop\\specdata", "nitrate", 5)

#complete function takes same arguments, returns the number of complete rows (no Na's) in the file(s)
complete <- function(directory, id = 1:332){
  fileList <- list.files(directory, pattern = ".csv", full.names = T)
  
  for(i in id){
    file <- read.csv(fileList[i])
    complete <- file[complete.cases(file), ]
    print(nrow(complete))
  }
  
}

complete("C:\\Users\\chuck\\Desktop\\specdata", c(6, 10, 20))

#corr function takes the directory where files are located and an integer for threshold which represents complete cases
#returns the correlation between sulfate and nitrate
corr <- function(directory, threshold){
  fileList <- list.files(directory, pattern = ".csv", full.names = T)
  
  for(i in 1:332){
    file <- read.csv(fileList[i])
    complete <- file[complete.cases(file), ]
    if(nrow(complete) >= threshold){
      cor(complete$sulfate, complete$nitrate)-> corellation
      print(corellation)
    }
    
  }
}

corr("C:\\Users\\chuck\\Desktop\\specdata", 129)




       