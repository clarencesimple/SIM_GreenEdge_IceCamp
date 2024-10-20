# GreenEdge Ice Camp Autotrophs

Scripts and data for:  
  
Sim C.W.H., Ribeiro C.G., Le Gall F., Probert I., Gourvil P., Lovejoy C., Vaulot D. & Lopes dos Santos, A. (2024). Temporal dynamics and biogeography of sympagic and planktonic autotrophic microbial eukaryotes during the under-ice Arctic bloom (submitted).
  
List of packages used across all R files are listed in  [GE_IC_read_phyloseq.R](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/GE_IC_read_phyloseq.R). Please make sure to install packages before running. Scripts are written using relative file paths, no changes any file paths are required upon cloning this repository.

## R_ice_camp
All files involved in generating figures and data used in this study.

* Main script for figures - [GE_IC_main.Rmd](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/GE_IC_main.Rmd)
     * [GE_IC_read_phyloseq.R](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/GE_IC_read_phyloseq.R) Sub-script for loading libraries and reading phyloseq file
     * [GE_IC_data_organisation.R](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/GE_IC_data_organisation.R) - Sub-script for organising data structures and assigning various properties to taxa
     * [GE_IC_functions.R](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/GE_IC_functions.R) - Sub-script for creating functions 
     * [GE_IC_color.R](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/GE_IC_color.R) - Sub-script for creating color palettes for plots
     * [GE_IC_clarence_colors.xlsx](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/GE_IC_clarence_colors.xlsx) Color palettes for plots
     
### [Metabarcoding](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/tree/main/R_ice_camp/metabarcoding) 
Metabarcoding data generated from Green Edge Ice Camp Campaign (datasets 21, 22 downloaded from metaPR2 with PR2 5.0 annotation)
This study only involves dataset 21 - the filtered DNA samples, excluding light stress experiments.
* [bootstrap_cleaning.R](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/metabarcoding/bootstrap_cleaning.R) - Code to process ASV table with dada2 assignTaxonomy boostrap values. This ensures taxa are only confidently assigned at taxonomic levels with >= 80% boostrap values. 
* [phyloseq.rds](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/metabarcoding/phyloseq.rds) - Phyloseq file for the GE_IC campaign
* [samples.xlsx](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/metabarcoding/samples.xlsx) - Sample metadata table that reflects all samples in GE_IC
* [asv.xlsx](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/metabarcoding/asv.xlsx) - ASV occurrence across all GE_IC samples
* [asv_cleaned.xlsx](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/metabarcoding/asv_cleaned.xlsx) - ASV occurrence across all GE_IC samples after bootstrap cleaning.
 
### [Metadata](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/tree/main/R_ice_camp/metadata) 
Environmental parameters corresponding to this study's metabarcoding samples
* [PAR](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/metadata/metadata_PAR.csv.gz)
* [Chlorophyll pigments](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/metadata/metadata_chla_pigments.csv)
* [Pico-nano flow cytometry](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/metadata/metadata_cytometry.xlsx)
* [Snow and ice thickness](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/metadata/metadata_icesnow.xlsx)
 
### [Trophic mode assignment](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/tree/main/R_ice_camp/trophic_mode_assignment)
Data and scripts used to assign all PR2 taxa with a trophic mode
* [schneider2020.csv](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/trophic_mode_assignment/SchneiderMajorityRules.csv) - databse of trophic mode assigned to taxa. Retrieved from Schneider et al. (2020) doi: 10.3897/bdj.8.e56648
* [GE_IC_schneider_majority_rule.R](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/trophic_mode_assignment/GE_IC_schneider_majority_rule.R) - script to generate SchneiderMajorityRules.csv
* [trophic_mode_updated.xlsx](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/trophic_mode_assignment/trophic_mode_updated.xlsx) - Manually curated trophic mode assignment, including data from SchneiderMajorityRules.csv

### [Biogeography assignment](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/tree/main/R_ice_camp/biogeoraphy_assignment_metaPR2)
Files and script used to assign biogeographical distribution to cASVs.
* [GE_IC_biogeo.Rmd](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/biogeoraphy_assignment_metaPR2/GE_IC_biogeo.Rmd) Main script for reading metaPR2 samples and calculating biogeograph of cASVs 
* [biogeo_casv.csv](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/biogeoraphy_assignment_metaPR2/biogeo_casv.csv) List of cASVs and their global distribution generated by the script
* [metapr2 clusters_asv_set_ge2_2022-11-28.xlsx](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/biogeoraphy_assignment_metaPR2/metapr2%20clusters_asv_set_ge2_2022-11-28.xlsx) Clustering of GE IC ASVs with metaPR2 cASVs
* [metapr2_usearch_all_cultures.tsv.gz](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/biogeoraphy_assignment_metaPR2/metapr2_usearch_all_cultures.tsv.gz) - ASV Percentage similarity to culture-only sequences
* metaPR2 metabarcodes. Retrieved from Vaulot et al. (2022). doi: 10.1111/1755-0998.13674
    * [metapr2_datasets_Eukaryota_2022-11-28_coastal_oceanic - Folder](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/tree/main/R_ice_camp/biogeoraphy_assignment_metaPR2/metapr2_datasets_Eukaryota_2022-11-28_coastal_oceanic) containing sample and taxon lists of all downloaded metaPR2 samples
    * [metapr2_phyloseq_Eukaryota_2022-11-28_coastal.rds](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/biogeoraphy_assignment_metaPR2/metapr2_phyloseq_Eukaryota_2022-11-28_coastal.rds) - Phyloseq file of metaPR2 coastal samples
    * [metapr2_phyloseq_Eukaryota_2022-11-28_oceanic.rds](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/R_ice_camp/biogeoraphy_assignment_metaPR2/metapr2_phyloseq_Eukaryota_2022-11-28_oceanic.rds) - Phyloseq file of metaPR2 oceanic samples
 
## Main Figures
* [All main figures](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/tree/main/main_figures) generated from main script (GE_IC_main.Rmd) and biogeography script (GE_IC_biogeo.Rmd)

## Supplementary Figures
* [All supplementary figures](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/tree/main/supplementary_figures) generated from main script (GE_IC_main.Rmd) and biogeography script (GE_IC_biogeo.Rmd)

## Supplementary Tables
* [Tables of information](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/tree/main/supplementary_tables) of only the 504 Ice Camp photosynthetic (phototrophs + mixotrophs) ASVs used in this paper
    * [GE_IC_indicspecies.xlsx](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/supplementary_tables/GE_IC_indicspecies.xlsx) - IndicSpecies values of ASVs (tabs show the various statistical analysis done for comparing groups)
    * [photosynthetic_ASVs_BIOGEOtable.csv](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/supplementary_tables/photosynthetic_ASVs_BIOGEOtable.csv) - Successful biogeographical assignment of 141 ASVs based on metaPR2 samples
    * [photosynthetic_ASVs_OTUtable.csv](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/supplementary_tables/photosynthetic_ASVs_OTUtable.csv) - ASV occurrence across 137 samples
    * [photosynthetic_ASVs_SAMPLEtable.csv](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/supplementary_tables/photosynthetic_ASVs_SAMPLEtable.csv) - Sample metadata table that reflects 137 samples of this study
    * [photosynthetic_ASVs_TAXONtable.csv](https://github.com/clarencesimple/SIM_GreenEdge_IceCamp/blob/main/supplementary_tables/photosynthetic_ASVs_TAXONtable.csv)- Taxonomic table for the 465 ASVs used in this study


