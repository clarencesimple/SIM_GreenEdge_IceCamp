otus <- data.frame(otu_table(ps))
taxa <- data.frame(tax_table(ps)) 
samples <- data.frame(sample_data(ps))

library("readxl")

# Load the file that assign trophic mode to every PR2 
pr2_trophic <- read_excel("../R_ice_camp/data/pr2_trophic.xlsx",sheet="with trophic") 
pr2_trophic <- subset(pr2_trophic,select=c("species","taxon_level","trophic_mode")) %>% distinct(species,.keep_all = TRUE)


#preserve ASV before merging
taxa$asv_code <-rownames(taxa)

#Add trophic_mode and the level at which it was assigned (taxon_level) into the taxa table
taxa<-left_join(taxa,pr2_trophic,by="species")

#Separating Dinos as the 4th trophic mode
#taxa$trophic_mode<-ifelse(taxa$division=="Dinoflagellata","dinoflagellata",taxa$trophic_mode)

# only assign those confident at species level, the rest are "unassigend dinos"
taxa$trophic_mode<-ifelse(taxa$class=="Dinophyceae" & taxa$taxon_level!="species","dinoflagellata",taxa$trophic_mode)


#Renaming trophic modes
taxa$trophic_mode<-ifelse(taxa$trophic_mode=="phytoplankton","photosynthetic",
                          ifelse(taxa$trophic_mode=="mixoplankton","mixotrophic",
                                 ifelse(taxa$trophic_mode=="protozooplankton","heterotrophic",
                                        taxa$trophic_mode)))

division<-c("Sagenista","Choanoflagellida","Dinoflagellata","Ciliophora","Telonemia",
            "Opalozoa","Stramenopiles_X","Cercozoa","Pseudofungi","Radiolaria",
            "Centroheliozoa","Ochrophyta","Picozoa","Katablepharidophyta","Perkinsea",
            "Mesomycetozoa","Apicomplexa","Chrompodellids","Apusomonadidae")
functional_trait<-c("Saprophyte","Bactivore","Dinophyceae","Eukaryvore","Omnivore",
                    "Eukaryvore","Unknown","Eukaryvore","Saprophyte","Eukaryvore",
                    "Unknown","Bactivore","Unknown","Omnivore","Invertebrate_parasite",
                    "Invertebrate_parasite","Invertebrate_parasite","Eukaryvore","Bactivore")
het_func <- data.frame(division,functional_trait)
taxa <- left_join(taxa,het_func,by="division")
taxa$functional_trait <- ifelse(taxa$class=="Syndiniales","Protist_parasite", taxa$functional_trait)
taxa$functional_trait <- ifelse(taxa$trophic_mode=="photosynthetic","Phototroph", taxa$functional_trait)
taxa$functional_trait <- ifelse(taxa$trophic_mode=="mixotrophic","Mixotroph", taxa$functional_trait)


#put ASV back as taxa's rowname
row.names(taxa)<-taxa$asv_code

#remove asv column since it's already rowname
taxa$asv_code<-NULL

otus= phyloseq::otu_table(as.matrix(otus), taxa_are_rows = TRUE)
taxa = phyloseq::tax_table(as.matrix(taxa))
samples = phyloseq::sample_data(samples)
ps <- phyloseq(otus, taxa, samples)
