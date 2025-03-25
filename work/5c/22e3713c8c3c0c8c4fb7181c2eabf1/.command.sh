#!/usr/bin/env Rscript
    library(jsonlite)
    library(RCurl)
    library(dplyr)
    library(tidyr)

    # Leitura segura do arquivo
    genes <- readLines("cleaned_genes.txt", warn=FALSE)
    genes <- genes[genes != ""]  # Remove linhas vazias
    
    # Conversão explícita para string R
    genes_string <- paste0('c("', paste(genes, collapse='", "'), '")')
    
    # Avaliação segura da string como código R
    genes_list <- eval(parse(text=genes_string))
    
    # Função com tratamento de erros melhorado
    get_string_ids <- function(ids) {
      ids_collapsed <- paste0(ids, collapse="%0d")
      response <- tryCatch({
        fromJSON(postForm(
          "https://string-db.org/api/json/get_string_ids",
          identifiers = ids_collapsed,
          species = 9606,  # Humanos
          echo_query = 1
        ))
      }, error = function(e) {
        message("Erro na consulta para genes: ", paste(ids, collapse=", "))
        return(NULL)
      })
      return(response)
    }

    # Processamento em lotes com progresso
    results <- list()
    batch_size <- 50  # Número seguro para a API
    
    for(i in seq(1, length(genes_list), batch_size)) {
      batch <- genes_list[i:min(i+batch_size-1, length(genes_list))]
      cat("Processando batch", ceiling(i/batch_size), "de", ceiling(length(genes_list)/batch_size), "
")
      
      batch_result <- get_string_ids(batch)
      if(!is.null(batch_result)) {
        results[[length(results)+1]] <- batch_result
      }
      Sys.sleep(0.5)  # Pausa entre requisições
    }

    # Consolidação dos resultados
    if(length(results) > 0) {
      final <- bind_rows(results) %>%
        janitor::clean_names() %>%
        separate(string_id, into=c("ensembl_id", "string_id"), sep="\.") %>%
        distinct()  # Remove duplicatas
      
      write.csv(final, "string_results.csv", row.names=FALSE)
    } else {
      stop("Nenhum resultado válido obtido da API")
    }
