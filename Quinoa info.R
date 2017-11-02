setwd("/Users/lillianzhao/Documents/Data Science/quinoa")

rm(list = ls())
library(tidyverse)
library(plotly)
library(reshape2)
library(stringr)

## Import files
df_export <- read.csv(file="/Users/lillianzhao/Documents/Data Science/quinoa/FAOSTAT_data_10-31-2017-2.csv", header=TRUE, sep=",")
df_google <- read.csv(file="/Users/lillianzhao/Documents/Data Science/quinoa/google_trends.csv", header=TRUE, sep=",")
df_google2 <- read.csv(file="/Users/lillianzhao/Documents/Data Science/quinoa/what_is_google_trends.csv", header=TRUE, sep=",")

## Separate exportation volume data into countries
df_export_bolivia <- filter(df_export, Area.Code == 19)
df_export_bolivia

df_export_peru <- filter(df_export, Area.Code == 170)
df_export_peru

## Clean "quinoa" google data search by splitting the date into month & year
## Then summarize annual search values
df_google["Year"] <- NA
df_google["Date"] <- df_google$Month
df_google$Month <- sapply(strsplit(as.character(df_google$Date),'-'), "[", 2)
df_google$Year <- sapply(strsplit(as.character(df_google$Date),'-'), "[", 1)

df_google$Year <- as.double(df_google$Year)

df_google_sum <- df_google %>%
  group_by(Year) %>%
  summarise(avg = mean(quinoa)) %>%
  arrange(avg)

## Clean "what is quinoa" google data search by splitting the date into month & year
## Then summarize annual search values

df_google2["Year"] <- NA
df_google2["Date"] <- df_google2$Month
df_google2$Month <- sapply(strsplit(as.character(df_google2$Date),'-'), "[", 2)
df_google2$Year <- sapply(strsplit(as.character(df_google2$Date),'-'), "[", 1)

df_google2$avg <- as.double(df_google2$Year)

df_google2_sum <- df_google2 %>% 
  group_by(Year) %>%
  summarise(avg = mean(what.is.quinoa)) %>%
  arrange(avg)


## Isolate trends since year = 2000
ggplot() + 
  geom_line(data = df_export_bolivia, 
            aes(x = Year, 
                y = Value, 
                color = 'Bolivia')) + 
  geom_line(data = df_export_peru, 
            aes(x = Year, 
                y = Value,
                color = 'Peru')) + 
  geom_line(data = df_google_sum,
            aes(x = Year, 
                y = avg *1200,
                color = 'Google Search: Quinoa'))  + 
  ggtitle("Peru & Bolivia Quinoa Exports") + 
  labs(x = "Year", 
       y = "Quinoa Exports in Tonnes", 
       colour="Country") + 
  xlim(2004, 2017)

ggsave(filename = "export v. google.pdf", width = 10, height = 7.5)

##   geom_line(data = df_google2_sum,
## aes(x = Year, 
##    y = avg *1200,
##    color = 'What is Quinoa'))

## Graph rise of quinoa over all time
ggplot() + 
  geom_line(data = df_export_bolivia, 
            aes(x = Year, 
                y = Value, 
                color = 'Bolivia')) + 
  geom_line(data = df_export_peru, 
            aes(x = Year, 
                y = Value,
                color = 'Peru')) + 
  ggtitle("Peru & Bolivia Quinoa Exports") + 
  labs(x = "Year", 
       y = "Quinoa Exports in Tonnes", 
       colour="Country")

ggsave(filename = "export_volume.pdf", width = 10, height = 7.5)
