#!/usr/bin/env Rscript

library(geneplast)
library(dplyr)
library(AnnotationHub)
library(vroom)

ah <- AnnotationHub()

meta <- query(ah, "geneplast")

load(meta[["AH83116"]])

dados <- read.csv("string_ids.csv")

#filtrando os cogs de interesse
table_cogs <- cogdata %>%
  filter(ssp_id %in% dados$ssp_id) %>%
  filter(protein_id %in% dados$string_id) %>%
  select(-ssp_id) %>%
  left_join(dados, by = c("protein_id" = "string_id"))
  gc()

#geneplast
ogr <- groot.preprocess(cogdata= cogdata, phyloTree= phyloTree, cogids = table_cogs$cog_id, spid="9606")

ogr <- groot(ogr, nPermutations=1000, verbose=FALSE)

res <- groot.get(ogr, what="results")

write.csv(res, "res.csv")
