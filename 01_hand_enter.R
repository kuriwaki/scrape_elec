library(tibble)

cands <- readRDS("data/output/2016-primary_long.Rds")
totals <- readRDS("data/output/2016-primary_totals.Rds")


cands %>% 
  filter(st == "WY")

cands %>% 
  filter(st == "WY") %>% 
  distinct(county, fips) %>% 
  dput()


# Republican 

# Maine (https://www.nytimes.com/elections/2016/results/primaries/maine)

pres_me_r <- tribble(~county, ~Cruz_votes, ~Trump_votes, ~Kasich_votes, ~Rubio_votes, ~Cruz_p, ~Trump_p, ~Kasich_p, ~Rubio_p, 
        "Androscoggin County", 662, 482, 102, 118, 0.480, 0.350, 0.074, 0.086,
        "Aroostook County", 248, 241, 89, 71, 0.362, 0.373, 0.134, 0.107,
        "Cumberland County", 1400, 1231, 703, 394, 0.372, 0.327, 0.187, 0.105,
        "Franklin County", 213, 131, 43, 49, 0.480, 0.295, 0.110, 0.097,
        "Hancock County", 430, 255, 131, 63, 0.482, 0.286, 0.147, 0.071,
        "Kennebec County", 759, 461, 146, 87, 0.516, 0.313, 0.099, 0.059,
        "Knox County", 266, 292, 107, 48, 0.401, 0.365, 0.147, 0.066,
        "Lincoln County", 325, 270, 92, 50, 0.432, 0.359, 0.122, 0.066,
        "Oxford County", 329, 307, 76, 62, 0.418, 0.390, 0.096, 0.079, 
        "Penobscot County", 1409, 537, 161, 144, 0.621, 0.237, 0.071, 0.063,
        "Piscataquis County", 236, 122, 36, 16, 0.569, 0.294, 0.087, 0.039,
        "Sagadahoc County", 285, 221, 103, 77, 0.411, 0.319, 0.149, 0.111,
        "Somerset County", 512, 270, 60, 52, 0.565, 0.298, 0.066, 0.057,
        "Waldo County", 356, 220, 75, 54, 0.498, 0.308, 0.105, 0.076,
        "Washington County", 218, 171, 45, 36, 0.461, 0.362, 0.095, 0.075,
        "York County", 893, 843, 300, 166, 0.398, 0.376, 0.134, 0.074)


pmr_long <- melt(as.data.table(pres_me_r),
                 id.vars = "county",  
                 measure.vars = patterns("_votes", "_p"),
                 variable.name = "lastname", 
                 value.name = c("vote", "geo_race_vote_pct")) %>% 
  tbl_df() %>%
  mutate(candidate = case_when(lastname == 1 ~ "T. Cruz",
                               lastname == 2 ~ "D. Trump",
                               lastname == 3 ~ "J. Kasich", 
                               lastname == 4 ~ "M. Rubio")) %>% 
  mutate(lastname = case_when(lastname == 1 ~ "Cruz", 
                              lastname == 2 ~ "Trump",
                              lastname == 3 ~ "Kasich",
                              lastname == 4 ~ "Rubio")) %>%
  mutate(office = "President",
         ballot = "Republican", 
         party = "R",
         st = "ME",
         state = "Maine")





# Wyoming aggregates pairs of counties (https://www.nytimes.com/elections/2016/results/primaries/wyoming)


saveRDS(pmr_long, "data/input/augment/pres_me_r.Rds")
