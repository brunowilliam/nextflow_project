#!/bin/bash -ue
# Limpeza mais robusta - mantém apenas nomes de genes válidos
grep -oE '[A-Za-z0-9_-]+' "genes.txt" | sort -u > cleaned_genes.txt
