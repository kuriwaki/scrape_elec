Primary Elections Data Documentation
================

Candidate-level data
--------------------

`2016_primary_long` has vote and vote share at the candidate level.

``` r
sample_n(readRDS("data/output/2016-primary_long.Rds"), 10)
```

    ## # A tibble: 10 x 11
    ##       office    st          state           county  fips       ballot
    ##        <chr> <chr>          <chr>            <chr> <int>        <chr>
    ##  1 President    OK       Oklahoma  Okfuskee County 40107   Republican
    ##  2  Governor    WA     Washington  Columbia County 53013 Open Primary
    ##  3 President    FL        Florida    Martin County 12085   Republican
    ##  4 President    KY       Kentucky  Calloway County 21035   Democratic
    ##  5 President    GA        Georgia    Elbert County 13105   Democratic
    ##  6 President    OK       Oklahoma   Choctaw County 40023   Democratic
    ##  7 President    NY       New York    Ulster County 36111   Republican
    ##  8 President    MI       Michigan    Branch County 26023   Republican
    ##  9 President    AR       Arkansas     White County  5145   Democratic
    ## 10 President    NC North Carolina Henderson County 37089   Republican
    ## # ... with 5 more variables: candidate <chr>, lastname <chr>, party <chr>,
    ## #   vote <dbl>, geo_race_vote_pct <dbl>

County-level data
-----------------

`2016_primary_wide` has the vote share of the major presidential candidates at the county level.

``` r
sample_n(readRDS("data/output/2016-primary_president_wide.Rds"), 10)
```

    ## # A tibble: 10 x 12
    ##       office    st          state            county  fips Clinton Sanders
    ##        <chr> <chr>          <chr>             <chr> <int>   <dbl>   <dbl>
    ##  1 President    FL        Florida Okeechobee County 12093   0.552   0.376
    ##  2 President    IN        Indiana     Tipton County 18159   0.419   0.581
    ##  3 President    WI      Wisconsin    Burnett County 55013   0.494   0.503
    ##  4 President    ID          Idaho     Valley County 16085   0.269   0.731
    ##  5 President    AL        Alabama     Monroe County  1099   0.909   0.076
    ##  6 President    GA        Georgia     Gordon County 13129   0.575   0.410
    ##  7 President    NC North Carolina   Randolph County 37151   0.466   0.458
    ##  8 President    PA   Pennsylvania     Beaver County 42007   0.567   0.418
    ##  9 President    FL        Florida   Sarasota County 12115   0.611   0.373
    ## 10    Senate    FL        Florida    Manatee County 12081      NA      NA
    ## # ... with 5 more variables: Trump <dbl>, Kasich <dbl>, Carson <dbl>,
    ## #   Cruz <dbl>, Rubio <dbl>

Data Construction
-----------------

Almost all of the data comes from (<https://github.com/Prooffreader/election_2016_data>), which scraped Politico election results. Most of the Politico results come from the AP feed.

Missings of Races
-----------------

Some primary races are missing due to lack of county-level data from AP. Only looking at Democratic and Republican Candidates,

### President

![](figures/coverage_pres.png)

### Senate

![](figures/coverage_sen.png)

### Governor

![](figures/coverage_gov.png)
