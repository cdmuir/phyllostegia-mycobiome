library(dplyr)
library(magrittr)
library(readr)
library(stringr)

phykaainfect <- read.csv('fixed_phykaa_infection_datatable_no_time_zero.csv')
phykaainfect$Population <- as.factor(phykaainfect$Population)
phykaainfect$Treatment <- factor(
  phykaainfect$Treatment,
  levels = c("CON","AMF","END","ANE"),
  labels = c("Control","AMF","M. aphidis","AMF + M. aphidis")
)

phykaainfect %<>% 
  dplyr::mutate(
    AMF = str_detect(Treatment, "AMF"), 
    M_aphidis = str_detect(Treatment, "M. aphidis")
  ) %>%
  dplyr::filter(DaySinceInfec == "78") %>%
  dplyr::select(DiseaseSeverity, AMF, M_aphidis, Site, Population, Treatment)

write_csv(phykaainfect, "processed-data.csv")
