setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


###############
### Samples ###
###############

# all samples from GE campaign (ice camp and amundsen)
sample_metadata <- read_excel("../R_ice_camp/metabarcoding/samples_metadata.xlsx") 

# Taking only samples involved in GE Ice Camp
samples <- data.frame(sample_data(ps)) %>%
  select() %>%
  rownames_to_column("file_code") %>% 
  left_join(sample_metadata, by="file_code")

samples$file_code <- gsub("-",".",samples$file_code)

# Allocation of bloom phase and bloom-fraction cluster
samples$bloom_stage<-ifelse(samples$date=="2016-05-09"|samples$date=="2016-05-23"|samples$date=="2016-05-30", "Stage_I",
                            ifelse(samples$date=="2016-06-06"|samples$date=="2016-06-13", "Stage_II", "Stage_III"))

#this cluster refers to substrate-stage cluster
samples$cluster<-str_c(samples$substrate," - ", samples$bloom_stage)

#this cluster refers to dark and light stages
samples$bloom_cluster <- ifelse(samples$bloom_stage=="Stage_I","Stage_I","Stages_II_and_III")


# Allocation of water depth and water levels
#6 water depths simplified into 4 levels + 2 ice levels)
samples$depth_level<-str_sub(samples$metadata_code,-1)
samples$depth_level<-ifelse(samples$depth_level=="3" & samples$substrate=="ice","ICE_0",samples$depth_level)
samples$depth_level<-ifelse(samples$depth_level=="4" & samples$substrate=="ice","ICE_1",samples$depth_level)
samples$depth_level<-ifelse(samples$depth_level=="2" ,"WATER_1",
                            ifelse(samples$depth_level=="3" ,"WATER_2",
                                   ifelse(samples$depth_level=="4" ,"WATER_3",
                                          ifelse(samples$depth_level=="6" ,"WATER_4",samples$depth_level))))

#put file_code back as samples's rowname
samples <- samples %>%
  column_to_rownames("file_code")



####################################
### TAXA TROPHIC MODE ASSIGNMENT ###
####################################

# Taking only samples involved in GE Ice Camp
taxa <- read_excel("../R_ice_camp/metabarcoding/asv_cleaned.xlsx") %>%
  select(asv_code, domain:species_boot, confident_boot, confident_taxon, sequence) 

taxa_metadata <- taxa %>%
  select(asv_code,domain:sequence)

taxonomy <- taxa %>%
  select(asv_code, domain:species)

# load trophic_mode assignment table (from schneider, schneider majority rules, and manual input)
trophic_mode <- read_excel("../R_ice_camp/trophic_mode_assignment/trophic_mode_updated.xlsx") %>% 
  select(taxon_name, taxon_level, trophic_mode)

trophic_mode$taxon_name <- gsub("_var_","_var.",trophic_mode$taxon_name)
trophic_mode$taxon_name <- gsub("_f_","_f.",trophic_mode$taxon_name)

#mapping the PR2 4.14 taxon names with the PR2 5.0 taxonomy 
new_taxon_level <- vector("character", length(trophic_mode$taxon_name))
for (i in 1:length(trophic_mode$taxon_name)) {
  taxon_name <- trophic_mode$taxon_name[i]
  matching_columns <- which(apply(taxonomy == taxon_name, 2, any))
  if (length(matching_columns) > 0) {
    new_taxon_level[i] <- colnames(taxonomy)[matching_columns[1]]
  } else {
    new_taxon_level[i] <- NA  
  }
}
trophic_mode$new_taxon_level <-new_taxon_level

trophic_mode <- trophic_mode %>%
  drop_na(new_taxon_level) %>%
  select(-taxon_level) %>%
  rename(taxon_level=new_taxon_level) %>%
  distinct(taxon_name,.keep_all = TRUE)

property <- trophic_mode

pr2_trophic_list <- list()
taxon_levels <- c("species", "genus", "family", "order", "class" , "subdivision", "division", "supergroup")

property_merge <- function(x) {
  property_one_level <- filter(property, taxon_level == x) 
  
  if (x== "species") return(inner_join(taxonomy, property_one_level, by = c("species" = "taxon_name")))
  if (x== "genus") return(inner_join(taxonomy, property_one_level, by = c("genus" = "taxon_name")))
  if (x== "family") return(inner_join(taxonomy, property_one_level, by = c("family" = "taxon_name")))
  if (x== "order") return(inner_join(taxonomy, property_one_level, by = c("order" = "taxon_name")))
  if (x== "class") return(inner_join(taxonomy, property_one_level, by = c("class" = "taxon_name")))
  if (x== "subdivision") return(inner_join(taxonomy, property_one_level, by = c("subdivision" = "taxon_name")))
  if (x== "division") return(inner_join(taxonomy, property_one_level, by = c("division" = "taxon_name")))
  if (x== "supergroup") return(inner_join(taxonomy, property_one_level, by = c("supergroup" = "taxon_name")))
  
}

# This is from manually input allocation
for (taxon_level in  taxon_levels) {
  # Assign trophic mode for PR2 taxa for a given level  
  pr2_trophic_list[[taxon_level]] <- property_merge(taxon_level)
  # Remove from PR2 taxa that have been assigned  
  taxonomy <-taxonomy %>% 
    filter(!(species %in% pr2_trophic_list[[taxon_level]]$species)) 
  cat(glue::glue("Level {taxon_level} done \n\n"))
}

pr2_trophic <- purrr::reduce(pr2_trophic_list, bind_rows)

taxa <- data.frame(tax_table(ps)) %>% 
  select() %>% 
  rownames_to_column("asv_code") %>%
  left_join(pr2_trophic %>% select(asv_code,trophic_mode,taxon_level),by="asv_code") %>%
  rename(taxon_level_trophic=taxon_level) %>%
  left_join(taxa_metadata,by="asv_code")

# If taxa is not even resolved at class level, then impossible to assign
taxa$trophic_mode <- ifelse(str_sub(taxa$class, -1) == "X" & is.na(taxa$trophic_mode)=="TRUE", "unassigned_euks", taxa$trophic_mode)
taxa$trophic_mode <- ifelse(str_sub(taxa$subdivision, -1) == "X" & is.na(taxa$trophic_mode)=="TRUE", "unassigned_euks", taxa$trophic_mode)

# only assign those confident at species and genus level, the rest are "unassigned dinos"
taxa$trophic_mode<-ifelse(taxa$class %in% c("Dinophyceae","Dinoflagellata_X") & ! taxa$taxon_level_trophic %in% c("genus","species"),
                          "other_Dinophyceae",taxa$trophic_mode)

#Renaming trophic modes
taxa$trophic_mode<-ifelse(taxa$trophic_mode=="phytoplankton","photosynthetic",
                          ifelse(taxa$trophic_mode=="mixoplankton","mixotrophic",
                                 ifelse(taxa$trophic_mode=="protozooplankton","heterotrophic",
                                        ifelse(taxa$trophic_mode=="dinoflagellata","unassigned_euks",
                                          taxa$trophic_mode))))


#########################
### TAXA BIOGEOGRAPHY ###
#########################

# add metaPR2 cASVs 
metapr2_cASV <- read_excel("../R_ice_camp/biogeoraphy_assignment_metaPR2/metapr2 clusters_asv_set_ge2_2022-11-28.xlsx", sheet="H") %>%
  mutate(asv_code=hash_value) %>% 
  mutate(casv_code=hash_value_centroid) %>% 
  select(asv_code,casv_code)

taxa<-left_join(taxa,metapr2_cASV,by="asv_code")
taxa$casv_code <- ifelse(is.na(taxa$casv_code)==TRUE, taxa$asv_code, taxa$casv_code)

# add biogeo to ASVs
biogeo<-read.csv("../R_ice_camp/biogeoraphy_assignment_metaPR2/biogeo_casv.csv") %>% select(-X) %>% select(casv_code,biogeo)
taxa<-left_join(taxa,biogeo, by="casv_code") 
taxa$biogeo <- ifelse(is.na(taxa$biogeo)==TRUE, "Unallocated", taxa$biogeo) 



##########################
### TAXA Culturability ###
##########################

#Culturability of ASVs with BLAST against PR2 Culture sequences
blast<-read_tsv("../R_ice_camp/biogeoraphy_assignment_metaPR2/metapr2_usearch_all_cultures.tsv.gz") %>% 
  filter(pct_id==100) %>%
  group_by(hash_value) %>%
  count() %>%
  rename(asv_code=hash_value, PR2_matches=n)
blast$asv_code<-substr(blast$asv_code,1,10)
taxa <- taxa %>% 
  left_join(blast,by="asv_code") %>%
  replace(is.na(.), 0)


####################################################
### TAXA Manual curation of ASVs from NCBI BLAST ###
####################################################
i <- which(taxa$asv_code==("c699cb1809"))

taxa$trophic_mode[i] <- "mixotrophic"
taxa$order[i] <- "Pyrenomonadales"	
taxa$family[i] <- "Baffinellaceae"
taxa$genus[i] <- "Baffinella"
taxa$species[i] <- "Baffinella_frigidus"

i <- which(taxa$asv_code==("f8124a0c4a"))

taxa$trophic_mode[i] <- "mixotrophic"
taxa$order[i] <- "Pyrenomonadales"	
taxa$family[i] <- "Baffinellaceae"
taxa$genus[i] <- "Baffinella"
taxa$species[i] <- "Baffinella_frigidus"

#KY980391.1
i <- which(taxa$asv_code==("3105a2354e"))
taxa$trophic_mode[i] <- "mixotrophic"
taxa$family[i] <- "Strombidiidae"
taxa$genus[i] <- "Strombidium"
taxa$species[i] <- "Strombidium_caudispina"

#KY980391.1 100% match
i <- which(taxa$asv_code==("7c17a19c86"))
taxa$trophic_mode[i] <- "mixotrophic"
taxa$family[i] <- "Strombidiidae"
taxa$genus[i] <- "Strombidium"
taxa$species[i] <- "Strombidium_caudispina"


#########################
### Creating phyloseq ###
#########################

#put ASV back as taxa's rowname
taxa <- taxa %>% column_to_rownames("asv_code")
otus <- data.frame(otu_table(ps))

otus= phyloseq::otu_table(as.matrix(otus), taxa_are_rows = TRUE)
taxa = phyloseq::tax_table(as.matrix(taxa))
samples = phyloseq::sample_data(samples)
ps <- phyloseq(otus, taxa, samples)
