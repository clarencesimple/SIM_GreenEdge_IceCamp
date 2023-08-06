setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

otus <- data.frame(otu_table(ps_unsorted))
taxa <- data.frame(tax_table(ps_unsorted)) 
samples <- data.frame(sample_data(ps_unsorted))

row.names(samples) <- gsub("-",".",row.names(samples))

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

taxa <- taxa %>% rownames_to_column("asv_code")
taxa$asv_code <- substr(taxa$asv_code,1,10)

#verified by alignment
taxa$genus <- ifelse(taxa$genus=="Falcomonas", "Baffinella", taxa$genus)
taxa$species <- ifelse(taxa$species=="Falcomonas_daucoides", "Baffinella_frigidus", taxa$species)

# add metaPR2 cASVs 
metapr2_cASV <- read_excel("../R_ice_camp/data/metapr2 clusters_asv_set_ge2_2022-11-28.xlsx", sheet="H") %>%
  mutate(asv_code=hash_value) %>% 
  mutate(casv_code=hash_value_centroid) %>% 
  select(asv_code,casv_code)

taxa<-left_join(taxa,metapr2_cASV,by="asv_code")
taxa$casv_code <- ifelse(is.na(taxa$casv_code)==TRUE, taxa$asv_code, taxa$casv_code)


#Culturability of ASVs with BLAST against PR2 Culture sequences
blast<-read_tsv("../R_ice_camp/data/metapr2_usearch_all_cultures.tsv.gz") %>% 
  filter(pct_id==100) %>%
  group_by(hash_value) %>%
  count() %>%
  rename(asv_code=hash_value, PR2_matches=n)
blast$asv_code<-substr(blast$asv_code,1,10)
taxa <- taxa %>% 
  left_join(blast,by="asv_code") %>%
  replace(is.na(.), 0)

# add biogeo to ASVs
biogeo<-read.csv("../R_ice_camp/data/biogeo_casv_metapr2_noGE.csv") %>% select(-X) %>% select(casv_code,biogeo)
taxa<-left_join(taxa,biogeo, by="casv_code") 
taxa$biogeo <- ifelse(is.na(taxa$biogeo)==TRUE, "Unallocated", taxa$biogeo) 

#add PAH to heterotrophic ASVs
PAH <- read.csv("../R_ice_camp/sorted_asv_hetero.csv") %>% select(-X)

taxa <- left_join(taxa,PAH,by="asv_code")
taxa$PAH <- ifelse(is.na(taxa$PAH)=="TRUE","others","PAH")

taxa <- taxa %>%column_to_rownames("asv_code")

row.names(otus) <- substr(row.names(otus),1,10)
row.names(taxa) <- substr(row.names(taxa),1,10)
taxa$casv_code <- substr(taxa$casv_code,1,10)

otus= phyloseq::otu_table(as.matrix(otus), taxa_are_rows = TRUE)
taxa = phyloseq::tax_table(as.matrix(taxa))
samples = phyloseq::sample_data(samples)
ps <- phyloseq(otus, taxa, samples)
