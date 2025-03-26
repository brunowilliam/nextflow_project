# Evortho - Evolutionary Origin Inference Tool

## 📌 Overview

Evortho é uma ferramenta de bioinformática que infere a origem evolutiva de genes através dos seguintes passos:
- Processamento automatizado de listas de genes
- Enraizamento de genes com o pacote R `geneplast`
- Saída formatada para fácil interpretação e criação de visualizações.

## 🚀 Como Executar

### Entrada
- **Arquivo de input**: Lista de genes em formato `.txt` (um gene por linha). 
- O repositório possui um dado de teste na pasta `data`. Caso o usuário não set sua própria lista de genes na linha de comando, o dado de teste é utilizado automaticamente.

- **Parâmetro**: 
  ```bash
  -genes_file caminho/para/seu/arquivo.txt