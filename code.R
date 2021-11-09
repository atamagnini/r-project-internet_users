library(tidyverse)
library(highcharter)
library(htmlwidgets)

dataset <- read.csv('~/data.csv', sep = ';', header = T)
df<- as.data.frame(dataset)
#clean dataset
colnames(df)[1] <- 'Country'
df$Country <- str_trim(df$Country, side = 'both')
glimpse(df)
df$X <- round(df$Internet.users/df$Population, 2)*100
df[df == 'Russian Federation'] <- 'Russia'
df[df == 'Bolivia, Plurnational State of'] <- 'Bolivia'
df[df == 'Venezuela, Bolivarian Republic of'] <- 'Venezuela'
df[df == 'Iran, Islamic Republic of'] <- 'Iran'
df[df == 'United Kingdom of Great Britain and Northern Ireland'] <- 'United Kingdom'
#valores ausentes y condicionales
any(is.na(df$X))
df2 <- df[complete.cases(df), ]
df3 <- df2[df2$X <= 100, ]
glimpse(df3)
#map
p <- hcmap(map = 'custom/world', download_map_data = getOption("highcharter.download_map_data"), data = df3,
           value = 'X', joinBy = c('name', 'Country')) %>%
  hc_tooltip(useHTML = TRUE, headerFormat = '<b>Percentage of internet users<br>',
             pointFormat = '{point.name}:{point.value}%') %>%
  hc_title(text = 'World Internet users', 
           style = list(fontWeight = 'bold', fontSize = '20px'),
           align = 'left') %>%
  hc_credits(enabled = TRUE, text = 'Map by Antonela Tamagnini
             <br> Source: Wikipedia') %>%
  hc_mapNavigation(enabled = TRUE)
p
saveWidget(widget = p, file = "plot.html")
