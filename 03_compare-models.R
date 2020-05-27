library(brms)
library(readr)

fit1 <- read_rds("objects/fit1.rds")
fit2 <- read_rds("objects/fit2.rds")
fit3 <- read_rds("objects/fit3.rds")
fit4 <- read_rds("objects/fit4.rds")
fit5 <- read_rds("objects/fit5.rds")

# Model comparison

## No evidence for Site and Population effects
loo_compare(fit1, fit2, fit3, fit4) %>%
  multiply_by(-2) %>% # convert to deviance scale for table
  print(digits = 3)

## No evidence for treatment-specific zi parameters
loo_compare(fit4, fit5) 

# Posterior predictive check
pp_check(fit4, nsamples = 1e2)
