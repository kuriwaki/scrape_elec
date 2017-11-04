rm(list = ls())


library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)
library(data.table)
library(haven)





pp_raw <- read_csv("election_2016_data/data/presidential_primaries_2016_by_county.csv")
sp_raw <- read_csv("election_2016_data/data/senate_primaries_2016_by_county.csv")
gp_raw <- read_csv("election_2016_data/data/governor_primaries_2016_by_county.csv")

# augmentation datasets
pmr_long <- readRDS("data/input/augment/pres_me_r.Rds")


# office / state/ county/ party / candidate  /vote



# select columns ---


std_fmt <- function(df, office) {
  df %>% 
    mutate(office = office,
           geo_race_vote_pct = vote_pct / 100) %>%
    rename(candidate = name,
           ballot = party,
           party = individual_party,
           county = geo_name,
           vote = votes)   %>%
    mutate(party = recode(party, democrat = "D", republican = "R", independent_or_other = "I/O")) %>%
  select(office, state, county, fips, ballot, candidate, party, vote, geo_race_vote_pct)
}


# bind ----- 

races_fmt <- bind_rows(
  std_fmt(pp_raw, "President"),
  std_fmt(gp_raw, "Governor"),
  std_fmt(sp_raw, "Senate")
)


# Sort out ballot remove is.na(ballot)

ballot_fmt <-  races_fmt %>%
  mutate(ballot = case_when(office == "President" & state == "Wyoming" & party == "D" ~ "Democratic",
                            office == "President" & state == "Colorado" & party == "D" ~ "Democratic",
                            TRUE ~ ballot))

filter(races_fmt, state == "Colorado", office == "President", candidate == "H. Clinton") %>% 
  print(n = 64)



# check county code unique ----

stopifnot(
  nrow(distinct(races_fmt, state, county)) == 
    nrow(distinct(races_fmt, state, fips)) 
)

# Do all countys end with "County"

races_fmt %>% filter(!grepl("\\sCounty$", county))


# common edits ----
st_abb <- tibble(state = state.name, 
                 st = state.abb) 


name_fmt <-  ballot_fmt %>%
   mutate(lastname = gsub("[A-Z]\\.\\s", "", candidate),
          ballot = gsub("Democrat$", "Democratic", ballot))

df <- left_join(name_fmt, st_abb) %>% 
  select(office, st, state, county, fips, ballot, candidate, lastname, everything())


# Augment missings ---------

aug <- bind_rows(df, pmr_long)




# wide dataset with major candidates  in prez ----
pp_wide <- aug %>%
  filter(lastname %in% c("Clinton", "Sanders", "Trump", "Carson", "Rubio", "Kasich", "Cruz")) %>% 
  as.data.table() %>%
  dcast(office + st +  state + county + fips ~ lastname,
        value.var = "geo_race_vote_pct")  %>% 
  select(office, st, state, county, fips, Clinton, Sanders, Trump, Kasich, Carson, Cruz, Rubio, everything()) %>% 
  tbl_df()





# label vars -------

attr(aug$geo_race_vote_pct, "label")  <- "Proportion of total votes in party ballot"
attr(aug$party, "label")  <- "Candidate's party"
attr(aug$ballot, "label")  <- "Party ballot for closed primaries, candidate's party for open"
attr(aug$vote, "label") <- "votes for candidate in county"
attr(aug$st, "label") <- "state (abbreviated)"
attr(aug$candidate, "label") <- "candidate name"
attr(aug$lastname, "label") <- "candidate last name"
attr(aug$fips, "label") <- "county FIPS code"



saveRDS(aug, "data/output/2016-primary_long.Rds")
write_dta(aug, "data/output/2016-primary_long.dta")
saveRDS(pp_wide, "data/output/2016-primary_president_wide.Rds")
