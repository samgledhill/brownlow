library(rvest)
library(tidyverse)
library(janitor)
library(jsonlite)

############################
## 
## Custom functions 
##
#############################

## Function to get player details

get_players <- function(team) {
  
  players <- read_html(paste0("https://www.footywire.com/afl/footy/tp-", team))
  
  players %>%
    html_elements(xpath = '//*[@id="team-players-div"]/table') %>%
    html_table(header = TRUE) %>%
    .[[1]] %>%
    clean_names() %>%
    mutate(team = team)
  
}

get_players("hawthorn-hawks")

## Get fixture

fixture <- fromJSON("https://fixturedownload.com/feed/json/afl-2024")

## Pull team names

teams <- fixture %>%
  distinct(HomeTeam)





players <- read_html("https://www.footywire.com/afl/footy/tp-hawthorn-hawks")

players %>%
  html_elements(xpath = '//*[@id="team-players-div"]/table') %>%
  html_table(header = TRUE) %>%
  .[[1]] %>%
  clean_names()
