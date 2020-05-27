library(dplyr)
library(magrittr)
library(readr)
library(stringr)
library(tidyr)

# Contaminated pots (see email from Jerry Koko on 2019-11-30)
contam <- c("4688HK3","4688HK4","4688HK5","4689HK2","4689HK5","5245HK2","5075HK1","5245HK4","4689KP1")

# phykaasubset <- phykaasubset[ ! (paste(phykaasubset$Population,phykaasubset$Site,phykaasubset$Number,sep="") %in% contam &  phykaasubset$Treatment == "END"), ]

phykaainfect <- read.csv('fixed_phykaa_infection_datatable_no_time_zero.csv') %>%
  unite(id, Population, Site, Number, sep = "", remove = FALSE) %>%
  filter(!((id %in% contam) & Treatment == "END"))

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
