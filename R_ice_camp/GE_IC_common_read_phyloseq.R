library(stringr)
library(ggplot2)
library(dplyr)
library(tidyr)
library(tibble)
library(readr)
library(maps)
library(glue)
library(RColorBrewer)
library(phyloseq)
library(forcats)
library(rio)
library(here)
library(purrr)
library(directlabels)
library(lubridate)
library(patchwork)
library(readxl)
library(ggcharts)
library(scales)
library(indicspecies)
library(ggrepel)
library(ggpubr)
library(tidyverse)
library(ggmap)

# load PS file and removing non-protist
ps_unsorted <- readRDS("../metabarcoding/metapr2_phyloseq_asv_set_21_22_23_Eukaryota_2021-11-11.rds") %>% 
  subset_samples(dataset_id=="21") %>%
  subset_taxa(!(division %in% c("Metazoa", "Fungi","Rhodophyta")) & 
                !(class %in% c("Phaeophyceae","Embryophyceae","Opisthokonta_XX")) &
                !(order %in% c("Bryopsidales","Ulotrichales","Dasycladales","Trentepohliales","Cladophorales"))) 

ps_sorted <- readRDS("../metabarcoding/metapr2_phyloseq_asv_set_21_22_23_Eukaryota_2021-11-11.rds") %>% subset_samples(dataset_id=="22") %>%
  subset_taxa(!(division %in% c("Metazoa", "Fungi","Rhodophyta")) & !(class %in% c("Phaeophyceae","Embryophyceae","Opisthokonta_XX"))) %>%
  subset_samples(year %in% "2016")

ps_sorted_2015 <- readRDS("../metabarcoding/metapr2_phyloseq_asv_set_21_22_23_Eukaryota_2021-11-11.rds") %>% subset_samples(dataset_id=="22") %>%
  subset_taxa(!(division %in% c("Metazoa", "Fungi","Rhodophyta")) & !(class %in% c("Phaeophyceae","Embryophyceae","Opisthokonta_XX"))) %>%
  subset_samples(year %in% "2015")

ps_amundsen <- readRDS("../metabarcoding/metapr2_phyloseq_asv_set_21_22_23_Eukaryota_2021-11-11.rds") %>% subset_samples(dataset_id=="23") %>%
  subset_taxa(!(division %in% c("Metazoa", "Fungi","Rhodophyta")) & !(class %in% c("Phaeophyceae","Embryophyceae","Opisthokonta_XX"))) %>%
  subset_samples(year %in% "2016")