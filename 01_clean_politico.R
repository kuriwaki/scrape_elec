library(ggplot2)
library(dplyr)
library(readr)
library(data.table)
library(ggridges)

pp_raw <- read_csv("election_2016_data/data/presidential_primaries_2016_by_county.csv")
sp_raw <- read_csv("election_2016_data/data/senate_primaries_2016_by_county.csv")
gp_raw <- read_csv("election_2016_data/data/governor_primaries_2016_by_county.csv")



pp_wide <-  pp %>% 
  as.data.table() %>% 
  dcast(state + fips + geo_name ~ name,
        value.var = "votes",
        fun.aggregate = sum)



table(pp$individual_party)
table(pp$party)

# office / state/ county/ party / candidate  /vote



# select columns ---


std_fmt <- function(df, office) {
  df %>% 
    mutate(office = office,
           geo_race_vote_pct = vote_pct / 100) %>%
    rename(candidate = name,
           primary_type = party,
           party = individual_party,
           county = geo_name,
           vote = votes)   %>%
    mutate(party = recode(party, democrat = "D", republican = "R", independent_or_other = "I/O")) %>%
  select(office, state, county, fips, primary_type, candidate, party, vote, geo_race_vote_pct)
}


# bind ----- 

races_fmt <- bind_rows(
  std_fmt(pp_raw, "President"),
  std_fmt(gp_raw, "Governor"),
  std_fmt(sp_raw, "Senate")
)


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


name_fmt <-  races_fmt %>%
   mutate(lastname = gsub("[A-Z]\\.\\s", "", candidate),
          primary_type = gsub("Democrat$", "Democratic", primary_type))

df <- left_join(name_fmt, st_abb) %>% 
  select(office, st, state, county, fips, primary_type, candidate, lastname, everything())



# wide dataset with major candidates
cand_wide <- df %>%
  filter(lastname %in% c("Clinton", "Sanders", "Trump", "Carson", "Rubio", "Kasich", "Cruz")) %>% 
  as.data.table() %>%
  dcast(office + st +  state + county + fips ~ lastname,
        value.var = "geo_race_vote_pct")  %>% 
  select(office, st, state, county, fips, Clinton, Sanders, Trump, Kasich, Carson, Cruz, Rubio, everything()) %>% 
  tbl_df()


ggplot(cand_wide, aes(x = Trump)) + 
  geom_histogram(bins = 20) +
  facet_wrap(~state)


# Aggregate counts
totals  <-  df %>% 
  group_by(office, state, st, county, fips) %>%
  summarize(total_votes_R = sum(vote*(primary_type == "Republican"), na.rm = TRUE),
            total_votes_D = sum(vote*(primary_type == "Democratic"), na.rm = TRUE)) %>% 
  ungroup()




# check missings 
cand_wide %>% 
  filter(st %in%  c("WY", "CO", "ME"))


filter(pp_raw, state == "Maine") %>% 
  sample_n(10)



saveRDS(df, "data/output/2016-primary_long.Rds")
saveRDS(cand_wide, "data/output/2016-primary_wide.Rds")
saveRDS(totals, "data/output/2016-primary_totals.Rds")
