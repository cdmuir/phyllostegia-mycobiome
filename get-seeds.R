# This script generates random seeds to initiate Stan runs. It should not be re-run, or else results will change.

library(random)
library(readr)

# seeds <- randomNumbers(n = 100, min = 1, max = 1e9, col = 1)
write_rds(seeds[, 1], "seeds.rds")
