library(brms)
library(dplyr)
library(magrittr)
library(readr)
library(stringr)
library(tidyr)

seeds <- read_rds("seeds.rds")

phykaainfect <- read_csv(
  "processed-data.csv", 
  col_types = 
    cols(
      DiseaseSeverity = col_double(),
      AMF = col_logical(),
      M_aphidis = col_logical(),
      Population = col_character(),
      Site = col_character()
    )
)

fit1 <- brm(bf(DiseaseSeverity ~ Population + Site + AMF * M_aphidis, zi ~ 1),
            data = phykaainfect, 
            family = zero_inflated_beta(link = "logit"),
            chains = 1, iter = 4e3, thin = 1e0, seed = seeds[1]) %>%
  add_criterion("loo", reloo = TRUE)

write_rds(fit1, "objects/fit1.rds")

fit2 <- brm(bf(DiseaseSeverity ~ Population + AMF * M_aphidis, zi ~ 1),
            data = phykaainfect, 
            family = zero_inflated_beta(link = "logit"),
            chains = 1, iter = 4e3, thin = 1e0, seed = seeds[2]) %>%
  add_criterion("loo", reloo = TRUE)

write_rds(fit2, "objects/fit2.rds")

fit3 <- brm(bf(DiseaseSeverity ~ Site + AMF * M_aphidis, zi ~ 1),
            data = phykaainfect, 
            family = zero_inflated_beta(link = "logit"),
            chains = 1, iter = 4e3, thin = 1e0, seed = seeds[3]) %>%
  add_criterion("loo", reloo = TRUE)

write_rds(fit3, "objects/fit3.rds")

fit4 <- brm(bf(DiseaseSeverity ~ AMF * M_aphidis, zi ~ 1),
           data = phykaainfect, 
           family = zero_inflated_beta(link = "logit"),
           chains = 1, iter = 4e3, thin = 1e0, seed = seeds[4]) %>%
  add_criterion("loo", reloo = TRUE)

write_rds(fit4, "objects/fit4.rds")

# For plotting, modify model 4 to include separate zi term in each treatment
fit5 <- brm(bf(DiseaseSeverity ~ AMF * M_aphidis, 
               zi ~ AMF * M_aphidis),
            data = phykaainfect, 
            family = zero_inflated_beta(link = "logit"),
            chains = 1, iter = 4e3, thin = 1e0, seed = seeds[5]) %>%
  add_criterion("loo", reloo = TRUE)

write_rds(fit5, "objects/fit5.rds")

