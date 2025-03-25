#!/bin/bash -ue
library(geneplast)
library(dplyr)
library(AnnotationHub)

ah <- AnnotationHub()

meta <- query(ah, "geneplast")

load(meta[["AH83116"]])

string_id <- string_ids.csv

#filtrando os cogs de interesse
table_cogs <- cogdata %>%
  filter(ssp_id %in% string_id$ssp_id) %>%
  filter(protein_id %in% string_id$string_id) %>%
  select(-ssp_id) %>%
  left_join(string_id, by = c("protein_id" = "string_id"))
  gc()

write.csv(table_cogs, "table_cogs.csv")
