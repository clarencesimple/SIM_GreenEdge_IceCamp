# Objective
* Create a list of species with trophic mode

# Trophic modes
* phytoplankton
* mixoplankton
* protozooplankton
* plants
* metazoan

# Input

* Original pr2 taxonomy file
  * pr2_taxonomy_4.12.0.xlsx - Do not change

* File with trophic mode
  * trophic_mode_updated.xlsx
  * This file contained the original data of Schneider plus the assignement done by Clarence. Update by adding lines at the end (see yellow lines).  Indicate taxo_name, taxo_level, trophic mode and eventually reference and type of data in the same format than Scheider.  Each time this file is updated, the script near to be run again to regenerate the pr2_trophic.xlsx file.
  * The column tax_level indicate at which taxonomic level the emrgeing has been done.
  * The order does not matter (see below)


# Output
* PR2 taxonomy file with trophic mode
  * pr2_trophic.xlsx with 2 sheets
    * with_trophic
    * without trophic

* Join the first sheet of this file with the ASV table using the species field [left_join (x,y, by = "species")]

# Script
* The script reads the two input files.  
* It then goes from species -> supergroup. 
* It filters the trophic mode file by the taxo level considered
* It merges the pr2_taxonomy using the correct column
* It removes from pr2_taxonomy the lines for which the trophic mode has been updated
* Once the last level has been reached, all subsets are merged together (bind_rows)
* Both the taxa with trophic and without trophic modes are saved in an XLSX file

