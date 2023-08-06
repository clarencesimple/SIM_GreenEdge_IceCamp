
getPalette = colorRampPalette(c(brewer.pal(12, "Paired"), brewer.pal(8, "Set1"), brewer.pal(8, "Pastel2"), brewer.pal(8, "Accent")))

brewer.pal(11, "BrBG")

#read manually created color pallete and arrangement of species
trophic_colors <- read_excel("../R_ice_camp/GE_IC_clarence_colors.xlsx", sheet="trophic")

#manually curated color palette
trophicPalette<-as.vector(trophic_colors$color_code)
names(trophicPalette)<-trophic_colors$trophic_mode

# Load the file that assign trophic mode to every PR2 
#pr2_trophic <- read_excel("../R_ice_camp/pr2_trophic.xlsx",sheet="with trophic") 
#speciesList = c(unique(pr2_trophic$species),".Others")
#speciesPalette = getPalette(length(speciesList))
#names(speciesPalette) = speciesList


genusList = rbind(unique(tax_table(ps)[,"genus"]),".Others")
genusPalette = getPalette(length(genusList)) 
names(genusPalette) = genusList

speciesList = rbind(unique(tax_table(ps)[,"species"]),".Others")
speciesPalette = getPalette(length(speciesList)) 
names(speciesPalette) = speciesList

treeColors <- read_excel("../R_ice_camp/GE_IC_clarence_colors.xlsx", sheet = "division") %>% select(division,color_hex)
treePalette<-as.vector(treeColors$color_hex)
names(treePalette)<-treeColors$division

classColors <- read_excel("../R_ice_camp/catherine_colors_modified.xlsx", sheet = "classes") %>% select(class,color_hex)
classPalette<-as.vector(classColors$color_hex)
names(classPalette)<-classColors$class

biogeoColors <- read_excel("../R_ice_camp/GE_IC_clarence_colors.xlsx", sheet = "biogeo") %>% select(biogeo,color_hex)
biogeoPalette<-as.vector(biogeoColors$color_hex)
names(biogeoPalette)<-biogeoColors$biogeo

diatomPalette <- c("#CB181D","#08519C")
names(diatomPalette) <- c("Centric","Pennate")

