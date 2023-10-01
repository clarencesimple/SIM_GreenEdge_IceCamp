library(dplyr)
library(rio)
library(here)
library(purrr)

# Original pr2 taxonomy file
file_pr2_taxonomy = here("/pr2_taxonomy_4.14.0.xlsx")

# PR2 taxonomy file with trophic mode
file_pr2_trophic = here("/pr2_trophic.xlsx")

# File with trophic mode.  Each time it is update run this script again
file_trophic_mode = here("/trophic_mode_updated.xlsx")

# File with majority rules from Schneider2020
# file_majority_rules= here("schneider_majority_rules.csv")

pr2_taxonomy <- import(file_pr2_taxonomy, guess_max = 100000) #%>% 
  #select(-contains("taxo_"), -reference)
trophic_mode <- import(file_trophic_mode, guess_max = 10000) %>% 
  select(taxon_name, taxon_level, trophic_mode)
# majority_rules <- read.csv(file_majority_rules) %>% 
#  select(taxon_name, taxon_level, dominantTrophy) 
# renaming the header to taxon_name
# names(majority_rules)[names(majority_rules) == "dominantTrophy"] <- "trophic_mode"

# Add majority rules to trophic_mode, but removing those already allocated
#majority_rules_exclusive<-anti_join(majority_rules,trophic_mode,by=c("taxon_level","taxon_name"))
#trophic_mode<-rbind(trophic_mode,majority_rules_exclusive)

pr2_trophic_list <- list()
taxon_levels <- c("species", "genus", "family", "order", "class" , "division", "supergroup")


trophic_mode_merge <- function(x) {
  trophic_mode_one_level <- filter(trophic_mode, taxon_level == x) 
  
  if (x== "species") return(inner_join(pr2_taxonomy, trophic_mode_one_level, by = c("species" = "taxon_name")))
  if (x== "genus") return(inner_join(pr2_taxonomy, trophic_mode_one_level, by = c("genus" = "taxon_name")))
  if (x== "family") return(inner_join(pr2_taxonomy, trophic_mode_one_level, by = c("family" = "taxon_name")))
  if (x== "order") return(inner_join(pr2_taxonomy, trophic_mode_one_level, by = c("order" = "taxon_name")))
  if (x== "class") return(inner_join(pr2_taxonomy, trophic_mode_one_level, by = c("class" = "taxon_name")))
  if (x== "division") return(inner_join(pr2_taxonomy, trophic_mode_one_level, by = c("division" = "taxon_name")))
  if (x== "supergroup") return(inner_join(pr2_taxonomy, trophic_mode_one_level, by = c("supergroup" = "taxon_name")))
  
}

# This is from manually input allocation
for (taxon_level in  taxon_levels) {

# Assign trophic mode for PR2 taxa for a given level  
  pr2_trophic_list[[taxon_level]] <- trophic_mode_merge(taxon_level)

# Remove from PR2 taxa that have been assigned  
  pr2_taxonomy <-pr2_taxonomy %>% 
    filter(!(species %in% pr2_trophic_list[[taxon_level]]$species)) 
  
  cat(glue::glue("Level {taxon_level} done \n\n"))
}

pr2_trophic <- purrr::reduce(pr2_trophic_list, bind_rows)

sheets <- list("with trophic" = pr2_trophic,
               "without trophic" = pr2_taxonomy)

export(sheets, file_pr2_trophic)
