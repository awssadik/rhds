# rhds

Welcome to the project

## Setup

To setup this project, copy the config template to a config file and update the paths in `config.env`
Code to copy template: 
```
cp config-template.env config.env
```
## Installation

Use `renv` to install relevant packages

```
install.pacakges("renv")
renv.restore()
```


## How to run

### 1. Download the data

```
bash scripts/download-data.sh
Rscript scripts/download-pan-cancer-clinical.r
```

