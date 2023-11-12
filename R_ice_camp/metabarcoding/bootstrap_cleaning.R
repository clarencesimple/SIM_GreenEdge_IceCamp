library(dplyr)
library(readxl)
library(writexl) 

# load asv table (downloaded from metaPR2 as asv.xlsx)
asv_table <- read_excel("./asv.xlsx") 

boot_levels <- c("domain_boot","supergroup_boot","division_boot",
                 "subdivision_boot","class_boot","order_boot",
                 "family_boot","genus_boot","species_boot")

# retrieving most confident bootstrap taxonomic level (>=80%) and its taxon name 
for(y in boot_levels) {
  for(x in 1:length(asv_table$asv_code)) {
    if(asv_table[[y]][x] >= 80) {
      asv_table$confident_boot[x] <- as.character(y)
      y <- gsub("_boot", "",y)
      asv_table$confident_taxon[x] <- asv_table[[y]][x]
      y <- paste(y,"_boot",sep="")
    } 
  }
}

#removing the word "boot" from confident_boot column
asv_table$confident_boot <- gsub("_boot", "", asv_table$confident_boot)

# updating taxon name at every level based on their most confident bootstrap level
for(x in 1:length(asv_table$asv_code)) {
  if(asv_table$confident_boot[x]=="domain") {
    asv_table$supergroup[x] <- paste(asv_table$confident_taxon[x],"_X",sep="")
    asv_table$division[x] <- paste(asv_table$confident_taxon[x],"_XX",sep="")
    asv_table$subdivision[x] <- paste(asv_table$confident_taxon[x],"_XXX",sep="")
    asv_table$class[x] <- paste(asv_table$confident_taxon[x],"_XXXX",sep="")
    asv_table$order[x] <- paste(asv_table$confident_taxon[x],"_XXXXX",sep="")
    asv_table$family[x] <- paste(asv_table$confident_taxon[x],"_XXXXXX",sep="")
    asv_table$genus[x] <- paste(asv_table$confident_taxon[x],"_XXXXXXX",sep="")
    asv_table$species[x] <- paste(asv_table$confident_taxon[x],"_XXXXXXX_sp.",sep="")
  }
  if(asv_table$confident_boot[x]=="supergroup") {
    asv_table$division[x] <- paste(asv_table$confident_taxon[x],"_X",sep="")
    asv_table$subdivision[x] <- paste(asv_table$confident_taxon[x],"_XX",sep="")
    asv_table$class[x] <- paste(asv_table$confident_taxon[x],"_XXX",sep="")
    asv_table$order[x] <- paste(asv_table$confident_taxon[x],"_XXXX",sep="")
    asv_table$family[x] <- paste(asv_table$confident_taxon[x],"_XXXXX",sep="")
    asv_table$genus[x] <- paste(asv_table$confident_taxon[x],"_XXXXXX",sep="")
    asv_table$species[x] <- paste(asv_table$confident_taxon[x],"_XXXXXX_sp.",sep="")
  }
  if(asv_table$confident_boot[x]=="division") {
    asv_table$subdivision[x] <- paste(asv_table$confident_taxon[x],"_X",sep="")
    asv_table$class[x] <- paste(asv_table$confident_taxon[x],"_XX",sep="")
    asv_table$order[x] <- paste(asv_table$confident_taxon[x],"_XXX",sep="")
    asv_table$family[x] <- paste(asv_table$confident_taxon[x],"_XXXX",sep="")
    asv_table$genus[x] <- paste(asv_table$confident_taxon[x],"_XXXXX",sep="")
    asv_table$species[x] <- paste(asv_table$confident_taxon[x],"_XXXXX_sp.",sep="")
  }
  if(asv_table$confident_boot[x]=="subdivision") {
    asv_table$class[x] <- paste(asv_table$confident_taxon[x],"_X",sep="")
    asv_table$order[x] <- paste(asv_table$confident_taxon[x],"_XX",sep="")
    asv_table$family[x] <- paste(asv_table$confident_taxon[x],"_XXX",sep="")
    asv_table$genus[x] <- paste(asv_table$confident_taxon[x],"_XXXX",sep="")
    asv_table$species[x] <- paste(asv_table$confident_taxon[x],"_XXXX_sp.",sep="")
  }
  if(asv_table$confident_boot[x]=="class") {
    asv_table$order[x] <- paste(asv_table$confident_taxon[x],"_X",sep="")
    asv_table$family[x] <- paste(asv_table$confident_taxon[x],"_XX",sep="")
    asv_table$genus[x] <- paste(asv_table$confident_taxon[x],"_XXX",sep="")
    asv_table$species[x] <- paste(asv_table$confident_taxon[x],"_XXX_sp.",sep="")
  }
  if(asv_table$confident_boot[x]=="order") {
    asv_table$family[x] <- paste(asv_table$confident_taxon[x],"_X",sep="")
    asv_table$genus[x] <- paste(asv_table$confident_taxon[x],"_XX",sep="")
    asv_table$species[x] <- paste(asv_table$confident_taxon[x],"_XX_sp.",sep="")
  }
  if(asv_table$confident_boot[x]=="family") {
    asv_table$genus[x] <- paste(asv_table$confident_taxon[x],"_X",sep="")
    asv_table$species[x] <- paste(asv_table$confident_taxon[x],"_X_sp.",sep="")
  }
  if(asv_table$confident_boot[x]=="genus") {
    asv_table$species[x] <- paste(asv_table$confident_taxon[x],"_sp.",sep="")
  }
}

# Ensuring no additional underscore in taxa names (ie taxon level that has first bootstrap value above 80 is already defined as _X or _XX)

asv_table[] <- lapply(asv_table, gsub, pattern="X_X", replacement="XX")

write_xlsx(asv_table,"./asv_cleaned.xlsx") 
  