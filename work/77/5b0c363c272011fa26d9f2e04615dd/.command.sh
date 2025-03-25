#!/usr/bin/env Rscript
    library(jsonlite)
    library(RCurl)
    library(dplyr)
    library(tidyr)

    # Lê os genes limpos
    genes <- readLines("cleaned_genes.txt")
    
    # Função para consultar a API
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
string_id <- get_string_ids(genes) %>%
  janitor::clean_names() %>%
  tidyr::separate(string_id, into = c("ssp_id", "string_id"), sep = "\.")

    write.csv(string_id, "string_results.csv")
