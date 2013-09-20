#!/usr/bin/Rscript

library('datashieldclient')

credentials <- list(
  sslcert=paste0(Sys.glob('~'),'/.ssh/datashield-publickey.pem'),
  sslkey=paste0(Sys.glob('~'),'/.ssh/datashield-privatekey.pem'),
  ssl.verifyhost=0,
  ssl.verifypeer=0,
  sslversion=3)

# login in opals
ncds <- opal.login(url='https://login55.lamp.le.ac.uk:8443', opts=credentials)
hunt <- opal.login(url='https://opal.medisin.ntnu.no', opts=credentials)
prevend <- opal.login(url='https://molgenis34.target.rug.nl:8443', opts=credentials)
lifelines <- opal.login(url='https://molgenis34.target.rug.nl:8443', opts=credentials)
finrisk <- opal.login(url='https://opal.thl.fi:8443', opts=credentials)
chris <- opal.login(url='https://opal.cbm.eurac.edu:8443', opts=credentials)
micros <- opal.login(url='https://opal.cbm.eurac.edu:8443', opts=credentials)
kora <- opal.login(url='https://146.107.6.14:8443', opts=credentials)
opals<-list(ncds, hunt, prevend, lifelines, finrisk, chris, micros, kora)

# CHRIS
opal.datasources(chris)
opal.table(chris,'opal-data','HOP_CHRIS')
datashield.assign(chris,'HOS','opal-data.HOP_CHRIS:HLTH_OBESE_STRICT')
datashield.aggregate(chris,'length(HOS)')
datashield.aggregate(chris,'summary(HOS)')

# MICROS
opal.datasources(micros)
opal.table(micros,'opal-data','HOP_MICROS')
datashield.assign(micros,'HOS','opal-data.HOP_MICROS:HLTH_OBESE_STRICT')
datashield.aggregate(micros,'length(HOS)')
datashield.aggregate(micros,'summary(HOS)')

# NCDS
opal.datasources(ncds)
opal.table(ncds,'bioshare','HOP')
datashield.assign(ncds,'HOS','bioshare.HOP:HLTH_OBESE_STRICT')
datashield.aggregate(ncds,'length(HOS)')
datashield.assign(ncds,'H','bioshare.HOP', variables=list('HLTH_OBESE_STRICT'))
datashield.aggregate(ncds,'length(H$HLTH_OBESE_STRICT)')
datashield.aggregate(ncds,'summary.ds(H)')
datashield.aggregate(ncds,'summary.ds(H$HLTH_OBESE_STRICT)')

# PREVEND
opal.table(prevend,'hop-prevend','HOP')
datashield.assign(prevend,'HOS','hop-prevend.HOP:HLTH_OBESE_STRICT')
datashield.aggregate(prevend,'length(HOS)')
datashield.aggregate(prevend,'summary.ds(HOS)')

# LIFELINES
opal.table(lifelines,'hop-lifelines','HOP')
datashield.assign(lifelines,'HOS','hop-lifelines.HOP:HLTH_OBESE_STRICT')
datashield.aggregate(lifelines,'length(HOS)')
datashield.aggregate(lifelines,'summary.ds(HOS)')

# KORA
opal.datasources(kora)
opal.table(kora,'bioshare','HOP')
datashield.assign(kora,'HOS','bioshare.HOP:HLTH_OBESE_STRICT')
datashield.aggregate(kora,'length(HOS)')
datashield.aggregate(kora,'summary(HOS)')

# FINRISK
opal.table(finrisk,'HOPcopy','HOP')
datashield.assign(finrisk,'HOS','HOPcopy.HOP:HLTH_OBESE_STRICT')
datashield.aggregate(finrisk,'length(HOS)')
datashield.aggregate(finrisk,'summary(HOS)')

# HUNT
opal.table(hunt,'bioshare','HOP')
datashield.assign(hunt,'HOS','bioshare.HOP:HLTH_OBESE_STRICT')
datashield.aggregate(hunt,'length(HOS)')
datashield.aggregate(hunt,'summary(HOS)')

