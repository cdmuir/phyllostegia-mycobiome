# phyllostegia-mycobiome
Restoration of the mycobiome of the endangered Hawaiian mint *Phyllostegia kaalaensis* increases its pathogen resistance. Accepted at *Fungal Ecology*.

## Downloading repository 

1. Download or clone this repository to your machine.
2. Open `phyllostegia-mycobiome.Rproj` in [RStudio](https://www.rstudio.com/)
3. Install R packages if necessary.

## Fit model and plot Figure 1

```
source("01_fit-models.R") # fit models using brms
source("04_plot-results.R") # plot results (figure 1)
```

Other scripts:

- `get-seeds.R` downloads random seeds saved in `seeds.rds`. If you overwrite, your results will differ.
- `01_process-data.R` processes raw data (not included in this repo) to generate `processed-data.csv` file.
- `03_compare-models.R` performs model comparison using LOOIC.
