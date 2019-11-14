# phyllostegia-mycobiome
Restoration of the mycobiome of the endangered Hawaiian mint *Phyllostegia kaalaensis* increases its pathogen resistance

## Downloading repository 

1. Download or clone this repository to your machine.
2. Open `phyllostegia-mycobiome.Rproj` in [RStudio](https://www.rstudio.com/)
3. Install R packages if necessary.

## Fit model and plot Figure 1

```
source("fit-models.R") # fit models using brms
source("plot-results.R") # plot results (figure 1)
```

Other scripts:

- `get-seeds.R` downloads random seeds saved in `seeds.rds`. If you overwrite, your results will differ.
- `process-data.R` processes raw data (not included in this repo) to generate `processed-data.csv` file.
- `compare-models.R` performs model comparison using LOOIC.
