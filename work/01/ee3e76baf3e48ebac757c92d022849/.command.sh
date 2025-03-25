#!/bin/bash -ue
# Remove caracteres especiais e linhas vazias
grep -oE '[A-Za-z0-9]+' "genes.txt" | sort -u > cleaned_genes.txt
