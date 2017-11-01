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

## Clean google data search by splitting the date into month & year
df_google["Year"] <- NA
df_google["Date"] <- df_google$Month
df_google$Month <- sapply(strsplit(as.character(df_google$Date),'-'), "[", 2)
df_google$Year <- sapply(strsplit(as.character(df_google$Date),'-'), "[", 1)

df_google$Year <- as.double(df_google$Year)

# figure out loop to summarize data based on year for comparative graph
# n <- 2004
# while (n < 2018) {
#  filter(df_google, df_google$Year == n);
#  summarise_each(df_google$Year, funs(mean));
#  n <- n + 1;
#}

## Graph rise of quinoa
ggplot() + 
  geom_line(data = df_export_bolivia, 
            aes(x = Year, 
                y = Value, 
                color = 'Bolivia')) + 
  geom_line(data = df_export_peru, 
            aes(x = Year, 
                y = Value,
                color = 'Peru'))

ggsave(filename = "export_volume.pdf", width = 10, height = 7.5)

