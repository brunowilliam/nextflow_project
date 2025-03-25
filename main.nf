#!/usr/bin/env nextflow
 
params.genes_file = 'data/data_test.txt'


process CONVERTOPROTEIN { 
        
publishDir "result", mode: 'copy'

input: 
path genes_file

output: 
path "string_ids.csv"

script: 
"""
#!/usr/bin/env Rscript

library(geneplast)
library(dplyr)
library(RCurl)
library(jsonlite)
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
genes_list <- readLines("$genes_file")

string_id <- get_string_ids(genes_list) %>%
  janitor::clean_names() %>%
  tidyr::separate(string_id, into = c("ssp_id", "string_id"), sep = "\\\\.")

  write.csv(string_id, "string_ids.csv")
"""
} 

process ROOTINGGENES {

  publishDir "result", mode: 'copy'

    input:
    path dados

    output:
    path "rooted_genes.csv"

    script:
    """
#!/usr/bin/env Rscript

library(geneplast)
library(dplyr)
library(AnnotationHub)
library(vroom)

ah <- AnnotationHub()

meta <- query(ah, "geneplast")

load(meta[["AH83116"]])

dados <- read.csv("$dados")

#filtrando os cogs de interesse
table_cogs <- cogdata %>%
  filter(ssp_id %in% dados\$ssp_id) %>%
  filter(protein_id %in% dados\$string_id) %>%
  select(-ssp_id) %>%
  left_join(dados, by = c("protein_id" = "string_id"))
  gc()

#geneplast
ogr <- groot.preprocess(cogdata= cogdata, phyloTree= phyloTree, cogids = table_cogs\$cog_id, spid="9606")

ogr <- groot(ogr, nPermutations=1000, verbose=FALSE)

res <- groot.get(ogr, what="results")

# naming the rooted clades
CLADE_NAMES <- "https://raw.githubusercontent.com/dalmolingroup/neurotransmissionevolution/ctenophora_before_porifera/analysis/geneplast_clade_names.tsv"

lca_names <- vroom(CLADE_NAMES)

rooted_genes <- res %>%
  tibble::rownames_to_column("cog_id") %>%
  dplyr::select(cog_id, root = Root) %>%
  left_join(lca_names) %>%
  left_join(table_cogs)

write.csv(rooted_genes, "rooted_genes.csv") 
"""
}

workflow { 
    gene_list_ch = Channel.fromPath(params.genes_file)
    dados_ch = CONVERTOPROTEIN(gene_list_ch)
    ROOTINGGENES(dados_ch)
}