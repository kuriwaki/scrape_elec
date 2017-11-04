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

pres_me_r <- tribble(~county, ~Cruz, ~Trump, ~Kasich, ~Rubio,
        "Androscoggin County", 662, 482, 102, 118,
        "Aroostook County", 248, 241, 89, 71,
        "Cumberland County", 1400, 1231, 703, 394,
        "Franklin County", 213, 131, 43, 49,
        "Hancock County", 430, 255, 131, 63,
        "Kennebec County", 759, 461, 146, 87,
        "Knox County", 266, 292, 107, 48,
        "Lincoln County", 325, 270, 92, 50,
        "Oxford County", 329, 307, 76, 62,
        "Penobscot County", 1409, 537, 161, 144,
        "Piscataquis County", 236, 122, 36, 16,
        "Sagadahoc County", 285, 221, 103, 77,
        "Somerset County", 512, 270, 60, 52,
        "Waldo County", 356, 220, 75, 54,
        "Washington County", 218, 171, 45, 36,
        "York County", 893, 843, 300, 166)

# Wyoming aggregates pairs of counties (https://www.nytimes.com/elections/2016/results/primaries/wyoming)


saveRDS(pres_me_r, "data/input/augment/pres_me_r.Rds")