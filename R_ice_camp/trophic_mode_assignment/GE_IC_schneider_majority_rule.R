#Set working directory using relative file path
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load schenider 2020
schneider2020 <- read.csv("./schneider2020.csv", sep=";",header=TRUE)
names(schneider2020) <- tolower(names(schneider2020))

majorityrules<-data.frame()
taxon_levels <- c("genus","family","order","class")

for (taxon_level in taxon_levels) {
  
counts <- schneider2020 %>% group_by_(taxon_level) %>% count(trophy)
counts <-pivot_wider(counts,names_from=trophy,values_from=n)
counts$max <- apply(counts[,c("protozooplankton","mixoplankton","phytoplankton")], 1, max, na.rm=T)
counts$total <- apply(counts[,c("protozooplankton","mixoplankton","phytoplankton")], 1, sum, na.rm=T)
counts <- counts %>% filter(total>=5) %>% filter(taxon_level!="NA") #if the level does not have at least 5 taxa, don't consider
counts$percent <- counts$max / counts$total

# taxon group with low majority (Threshold = 50%) will not be considered
counts$dominantTrophy <- colnames(counts[,c("protozooplankton","mixoplankton","phytoplankton")])[apply(counts[,c("protozooplankton","mixoplankton","phytoplankton")],1,which.max)]
counts$dominantTrophy <- ifelse(counts$percent<=0.5,NA, counts$dominantTrophy)

# remove groups without dominant trophic mode
counts <- counts[!is.na(counts$dominantTrophy),]
counts$taxon_level <- taxon_level
# renaming the header to taxon_name
names(counts)[names(counts) == taxon_level] <- "taxon_name"

# create overall majority rules dataset based of schneider2020
majorityrules <- rbind(majorityrules,counts)
majorityrules <- majorityrules[!is.na(majorityrules$taxon_name),]

} 

write.csv(majorityrules,"./SchneiderMajorityRules.csv")
