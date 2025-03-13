

# Prediction of cancer progression from imputed proteomics


## Setup

Create a `config.env` file based on `config-template.env` that will have the following variables:

```
datadir=/path/to/data
resultsdir=/path/to/results
```

The data directory is for raw downloaded data that ideally you won't modify.

The results directory is for intermediate steps and final results. All files in the results directory should be reproducible.


## Installation

To run the analysis you need R packages installed:

```R
renv::restore()
```

## Pipeline

Individual steps are described below.

### Downloading and preparing the dataset

Available TCGA data collection on HNSC is well summarized here:
https://gdac.broadinstitute.org/runs/stddata__2016_01_28/samples_report/HNSC.html

Compiled a list of files to download from the GDAC website:
http://gdac.broadinstitute.org/runs/stddata__2016_01_28/data/HNSC/20160128
See `files.csv` in this directory.

Data files will be downloaded to the `data` directory by using the 
below command:

```
bash scripts/download-data.sh
```

### Downloading PanCancer Atlas clinical info

Clinical outcome data has been cleaned up as part of the
PanCancer Atlas project
(https://gdc.cancer.gov/about-data/publications/pancanatlas).

> Liu J, Lichtenberg T, Hoadley KA, et al. An Integrated TCGA Pan-Cancer
> Clinical Data Resource to Drive High-Quality Survival Outcome
> Analytics. Cell. 2018;173(2):400-416.e11. doi:10.1016/j.cell.2018.02.052

This publication cautions against using overall survival as an outcome
because the follow-up isn't long enough.
Recommends progression-free interval (PFI) or
disease-free interval (DFI).
PFI and DFI are available in Supplementary Table 1
(https://api.gdc.cancer.gov/data/1b5f413e-a8d1-4d10-92eb-7c4ae739ed81).
The table is downloaded to the `data` directory
using the following script.

```
Rscript scripts/download-pan-cancer-clinical.r
```

### Extract tcga data and clean clinical phenotypes

The datasets will be generated
from the downloaded files to the `data` directory
using the following script.

```
Rscript scripts/01-extract-data.r
```

Final clinical phenotype cleaning is also performed

```
Rscript scripts/02-clean-clinical.r
```

### DNA methylation predicted protein abundances

Estimate 109 predicted protein levels using DNA methylation data
using the prediction models developed by Gadd et al. 2022 and 
implemented in meffonym R package (https://github.com/perishky/meffonym):

> Gadd et al., ‘Epigenetic Scores for the Circulating Proteome as Tools for 
> Disease Prediction’. Elife. 2022. doi: 10.7554/ELIFE.71802

```
Rscript scripts/03-predict-proteins.r
```

These results are combine with clincal phenotyping data into
a final analysis ready dataset

```
Rscript scripts/04-combine.r
```

### Example analysis 

There are two example analyses performed in `05-analysis.qmd` and 
summarized in the `docs/05-analysis.html` report.

```
quarto render 05-analysis.qmd --output-dir docs
```

1. The methylation dataset has observations performed on both tumor and 
adjacent normal tissues. The first analysis looks at the association between
DNA methylation predicted protein abundances and tissue type (tumor vs. normal)

2. Progression free interval (PFI) is a measure of cancer progression. This
analysis restricts to DNA methylation predicted protein abundances from tumor
cells and looks at association with PFI.