#!/usr/bin/Rscript

library('datashieldclient')

# Login in opal of each study
credentials <- list(
  sslcert=paste0(Sys.glob('~'),'/.ssh/publickey.pem'),
  sslkey=paste0(Sys.glob('~'),'/.ssh/privatekey.pem'),
  ssl.verifyhost=0,
  ssl.verifypeer=0,
  sslversion=3)

ncds <- opal.login(url='https://lamp-api-32.rcs.le.ac.uk:8443', opts=credentials)
hunt <- opal.login(url='https://opal.medisin.ntnu.no', opts=credentials)
prevend <- opal.login(url='https://molgenis34.target.rug.nl:8443', opts=credentials)
finrisk <- opal.login(url='https://opal.thl.fi:8443', opts=credentials)
opals<-list(ncds, hunt, prevend, finrisk)

# NCDS
opal.table(ncds,'hop','HOP')
datashield.assign(ncds,'HOS','hop.HOP:HLTH_OBESE_STRICT')
datashield.aggregate(ncds,'length(HOS)')

# PREVEND
opal.table(prevend,'hop-prevend','HOP')
datashield.assign(prevend,'HOS','hop-prevend.HOP:HLTH_OBESE_STRICT')
datashield.aggregate(prevend,'length(HOS)')

# FINRISK
opal.table(finrisk,'HOPcopy','HOP')
datashield.assign(finrisk,'HOS','HOPcopy.HOP:HLTH_OBESE_STRICT')
datashield.aggregate(finrisk,'length(HOS)')

# HUNT
opal.table(hunt,'bioshare','HOP')
datashield.assign(hunt,'HOS','bioshare.HOP:HLTH_OBESE_STRICT')
datashield.aggregate(hunt,'length(HOS)')

# Summary of HOS for all studies
datashield.aggregate(opals,'summary(HOS)')

