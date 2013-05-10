#!/usr/bin/Rscript

library('datashieldclient')

credentials <- list(
  sslcert=paste0(Sys.glob('~'),'/keys/publickey.pem'),
  sslkey=paste0(Sys.glob('~'),'/keys/privatekey.pem'),
  ssl.verifyhost=0,
  ssl.verifypeer=0,
  sslversion=3)

# login in opals
ncds <- opal.login(url='https://lamp-api-32.rcs.le.ac.uk:8443', opts=credentials)
hunt <- opal.login(url='https://opal.medisin.ntnu.no', opts=credentials)
prevend <- opal.login(url='https://molgenis34.target.rug.nl:8443', opts=credentials)
finrisk <- opal.login(url='https://opal.thl.fi:8443/', opts=credentials)
opals<-list(ncds, hunt, prevend, finrisk)

# NCDS
opal.table(ncds,'hop','HOP')
#opal.variable(ncds,'hop','HOP','HLTH_OBESE_STRICT')
datashield.assign(ncds,'HOS','hop.HOP:HLTH_OBESE_STRICT')
datashield.symbols(ncds)
datashield.aggregate(ncds,'length(HOS)')
datashield.aggregate(ncds,'summary(HOS)')

# HUNT
opal.table(hunt,'test','HOP')
datashield.assign(hunt,'HOS','test.HOP:HLTH_OBESE_STRICT')

# PREVEND
opal.table(prevend,'opal-data','HOP')

# FINRISK
opal.table(finrisk,'opal-mysql','HOP')
