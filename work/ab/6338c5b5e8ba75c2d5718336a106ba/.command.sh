#!/bin/bash -ue
genes_list=tr -d "[]'\n" < "[ACKR3
, AFP
, AGR2
, AKT1
, ALDH1A1
, ANGPTL4
, ANXA1
, ANXA2
, AQP5
, ATF3
, AURKA
, AXL
, B2M
, BMI1
, BMP2
, BRAF
, BSG
, CA9
, CCDC88A
, CCND1
, CCR7
, CD24
, CD274
, CD44
, CDCP1
, CDH17
, CDH2
, CEACAM1
, CEACAM5
, CLIC1
, CRP
, CTGF
, CTNND1
, CTSB
, CTSK
, CTSL
, CTTN
, CXCL12
, CXCL2
, CXCL8
, CXCR2
, CYR61
, DDR2
, EGF
, EGFR
, EGR1
, EPAS1
, EPCAM
, ERBB2
, ERBB3
, ESR1
, ESR2
, EZH2
, EZR
, F2RL1
, FGFR1
, FLOT2
, FLT1
, FLT4
, FN1
, FOXC2
, FOXM1
, GLI1
, HGF
, HIF1A
, HMGA1
, HMGA2
, HPSE
, ID1
, IDO1
, IGF1R
, IGF2BP3
, IL6
, ITGA3
, ITGA5
, ITGA6
, ITGAV
, ITGB1
, ITGB3
, JAG1
, KDR
, KRAS
, KRT19
, L1CAM
, LAMC2
, LASP1
, LGALS3
, LOX
, LOXL2
, MACC1
, MCAM
, MDM2
, MET
, MIF
, MKI67
, MME
, MMP1
, MMP11
, MMP13
, MMP14
, MMP2
, MMP3
, MMP7
, MMP9
, MSN
, MST1R
, MTA1
, MTDH
, MUC1
, MYC
, NEDD9
, NOTCH1
, NTRK2
, PCNA
, PDGFRA
, PDPN
, PIK3CA
, PKM
, PLAU
, PLAUR
, POSTN
, PRKCI
, PROM1
, PSCA
, PTGS2
, PTHLH
, PTK2
, PTP4A3
, PTTG1
, PXN
, RAB25
, RAC1
, RELA
, RHOC
, ROCK1
, S100A4
, SATB1
, SDCBP
, SELE
, SELP
, SLC2A1
, SNAI1
, SNAI2
, SNCG
, SOX4
, SPARC
, SPP1
, SRC
, STAT3
, STMN1
, TERT
, TGFBI
, TGM2
, TIMP1
, TMPRSS4
, TNFSF11
, TYMP
, VCAN
, VEGFA
, VEGFC
, VEGFD
, VIM
, WASF3
, YAP1
, ZEB1
, ZEB2
]" 

    Rscript -e '
#!/usr/bin/env Rscript

library(geneplast)
library(dplyr)
library(RCurl)
library(jsonlite)
library(vroom)
library(janitor)
library(AnnotationHub)
library(purrr)

get_string_ids <- function(ids, species = '9606'){
  ids_colapse <- paste0(ids, collapse = "%0d")
  
  jsonlite::fromJSON(
    RCurl::postForm(
      "https://string-db.org/api/json/get_string_ids",
      identifiers = ids_colapse,
      echo_query = '1',
      species = species
      
    ),
  )
}

#string_id <- get_string_ids(c($genes_list)) %>%
#  janitor::clean_names() %>%
#  tidyr::separate(string_id, into = c("ssp_id", "string_id"), sep = "\.")

#  write.csv(string_id, "string_ids.csv")
'
