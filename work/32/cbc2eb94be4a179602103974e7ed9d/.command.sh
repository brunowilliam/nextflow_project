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

genelist <- AGR2
.

print(genelist)

#string_id <- get_string_ids(AGR2
) %>%
#  janitor::clean_names() %>%
#  tidyr::separate(string_id, into = c("ssp_id", "string_id"), sep = "\.")

#  write.csv(string_id, "string_ids.csv")
