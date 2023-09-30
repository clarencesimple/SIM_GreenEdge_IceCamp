# Trophic Mode Palette
trophic_colors <- read_excel("../R_ice_camp/GE_IC_clarence_colors.xlsx", sheet="trophic")
trophicPalette<-as.vector(trophic_colors$color_code)
names(trophicPalette)<-trophic_colors$trophic_mode

# Division Palette
treeColors <- read_excel("../R_ice_camp/GE_IC_clarence_colors.xlsx", sheet = "division") %>% select(division,color_hex)
treePalette<-as.vector(treeColors$color_hex)
names(treePalette)<-treeColors$division

# Class Palette
classColors <- read_excel("../R_ice_camp/GE_IC_clarence_colors.xlsx", sheet = "classes") %>% select(class,color_hex)
classPalette<-as.vector(classColors$color_hex)
names(classPalette)<-classColors$class

# Biogeography Palette
biogeoColors <- read_excel("../R_ice_camp/GE_IC_clarence_colors.xlsx", sheet = "biogeo") %>% select(biogeo,color_hex)
biogeoPalette<-as.vector(biogeoColors$color_hex)
names(biogeoPalette)<-biogeoColors$biogeo

# NMDS Palette
nmds_colors <- read_excel("../R_ice_camp/GE_IC_clarence_colors.xlsx", sheet="nmds")
#manually curated color palette
nmdsPalette<-as.vector(nmds_colors$color_code)
names(nmdsPalette)<-nmds_colors$cluster

# Species Palette
phyto_colors <- read_excel("../R_ice_camp/GE_IC_clarence_colors.xlsx", sheet="phyto")
phytoPalette<-as.vector(phyto_colors$color_code)
names(phytoPalette)<-phyto_colors$species

