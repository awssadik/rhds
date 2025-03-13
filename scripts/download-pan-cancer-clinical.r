library(readxl)
library(here)
readRenviron(here("config.env"))
datadir <- Sys.getenv("datadir")
resultsdir <- Sys.getenv("resultsdir")

stopifnot(dir.exists(datadir))
url <- "https://api.gdc.cancer.gov/data/1b5f413e-a8d1-4d10-92eb-7c4ae739ed81"
filename <- "TCGA-CDR-SupplementalTableS1.xlsx"
cat("download-pan-cancer-clinical.r", filename, "\n")
if (!file.exists(file.path(datadir, filename))) {download.file(url,destfile = file.path(datadir, filename))}
dat<-read_xlsx(file.path(datadir, filename), sheet = 1)
dir.create(resultsdir, showWarnings = F, recursive = T)
write.table(dat,file = file.path(resultsdir, sub("xlsx$", "txt", filename)),sep = "\t", row.names = F, col.names = T)