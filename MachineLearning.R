library(tidyverse)
library(dplyr)
library(here)
library(janitor)
library(caTools)

#load data set
read.csv("C:\\Users\\chuck\\Desktop\\Excel Workbooks\\Pokemon.csv") -> pokemon

#simplify column names
clean_names(pokemon) -> pokemon

#get rid of first column of numbers
pokemon[-1] -> pokemon

#rename a few columns
pokemon %>% rename(primary_type = type_1) %>% 
  rename(health_points = hp) %>%
  rename(secondary_type = type_2) -> pokemon

#see what we are working with
glimpse(pokemon)

#group by primary type of pokemon
table(pokemon$primary_type)

#find poison grass pokemon with highest speed
pokemon %>% filter(primary_type == 'Grass') -> grass_pokemon
grass_pokemon %>% filter(secondary_type == 'Poison') -> grass_poison_pokemon

range(grass_poison_pokemon$speed)
grass_poison_pokemon %>% filter(speed == 90) -> my_grass_pokemon

#find water psychic pokemon with highest defense
pokemon %>% filter(primary_type == 'Water') -> water_pokemon
water_pokemon %>% filter(secondary_type == 'Psychic') -> water_psychic_pokemon

range(water_psychic_pokemon$defense)
water_psychic_pokemon %>% filter(defense == 180) -> my_water_pokemon

#find fire fighting pokemon with highest attack
pokemon %>% filter(primary_type == 'Fire') -> fire_pokemon
fire_pokemon %>% filter(secondary_type == 'Fighting') -> fire_fighting_pokemon

range(fire_fighting_pokemon$attack)
fire_fighting_pokemon %>% filter(attack == 160) -> my_fire_pokemon

#append my three pokemon in one table
rbind(my_fire_pokemon, my_grass_pokemon, my_water_pokemon) -> my_pokemons

#regression (understanding what influences a pokemons attack)
#splitting data
sample.split(pokemon$attack, SplitRatio = .65) -> split_index
subset(pokemon, split_index==T) -> training_set
subset(pokemon, split_index==F) -> testing_set

#building model
lm(attack~defense, data=training_set) -> model_regress
predict(model_regress, testing_set) -> result_regress
cbind(Actual=testing_set$attack, Predicted=result_regress) -> Final_Data
as.data.frame(Final_Data) -> Final_Data

#find error in model
(Final_Data$Actual - Final_Data$Predicted) -> error
cbind(Final_Data,error) -> Final_Data

#root mean square error (28.5)
rmse<- sqrt(mean(Final_Data$error^2))

#building 2nd model to see how 3 vaiables effect attack variable
lm(attack~defense + speed + health_points, data=training_set) -> model_regress2
predict(model_regress2, testing_set) -> result_regress2
cbind(Actual=testing_set$attack, Predicted=result_regress2) -> Final_Data2
as.data.frame(Final_Data2) -> Final_Data2

#find error in new model (24.7, model is more accurate than previous)
(Final_Data2$Actual - Final_Data2$Predicted) -> error2
cbind(Final_Data2,error2) -> Final_Data2
rmse2 <- sqrt(mean(Final_Data2$error2^2))



