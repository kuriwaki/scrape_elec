
library(formattable)
library(webshot)
library(htmltools)


df <- readRDS("data/output/2016-primary_long.Rds")

# functions ---- 
coverage_office <- function(office_subset, dat = df) {
  sub <- dat %>% 
    filter(office == office_subset) %>% 
    filter(party %in% c("D", "R"))
  
  sub %>% 
    mutate(office_party = paste0(office, "-", party)) %>%
    complete(state, office_party) %>%
    group_by(state, office_party) %>% 
    summarize(has_data = sum(vote, na.rm = TRUE) > 0) %>% 
    ungroup() %>% as.data.table() %>%
    dcast(state ~ office_party, value.var = "has_data") %>% 
    select(matches("st"), matches("Dem"), matches("Repub"), matches("Open"), everything()) %>%
    as.data.frame()
}

ft <- function(df) {
  formattable(df, list(
    area(col = -1) ~ formatter("span",
                               style = x ~ style(color = ifelse(x, "green", "red")),
                               x ~ icontext(ifelse(x, "ok", "remove"), ifelse(x, "Yes", "No")))
  ))
}


export_formattable <- function(f, file, width = "50%", height = NULL, 
                               background = "white", delay = 0.1) {
  w <- as.htmlwidget(f, width = width, height = height)
  path <- html_print(w, background = background, viewer = NULL)
  url <- paste0("file:///", gsub("\\\\", "/", normalizePath(path)))
  webshot(url,
          file = file,
          selector = ".formattable_widget",
          delay = delay)
}


ft_pres <- coverage_office("President") %>% ft()
ft_sen <- coverage_office("Governor") %>% ft()
ft_gov <- coverage_office("Senate") %>% ft()



export_formattable(ft_pres, "figures/coverage_pres.png")
export_formattable(ft_sen, "figures/coverage_sen.png")
export_formattable(ft_gov, "figures/coverage_gov.png")

