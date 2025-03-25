#!/usr/bin/env Rscript

library(geneplast)
library(dplyr)
library(AnnotationHub)

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

write.csv(table_cogs, "table_cogs.csv")
