#################################################
########### RUN ALL #############################
#################################################

source("scripts/01-extract-data.r")
source("scripts/02-clean-clinical.r")
source("scripts/03-predict-proteins.r")
source("scripts/04-combine.r")
source("scripts/05-analysis.r")