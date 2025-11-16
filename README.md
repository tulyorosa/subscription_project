# Subscription Analytics Pipeline (DuckDB + Python + Power BI)

Este projeto demonstra a construção completa de um pipeline de dados
moderno usando **DuckDB**, **Python**, **SQL** e **Power BI**, aplicando
um modelo de arquitetura **Medallion (Bronze → Silver → Gold)** para
processar dados simulados de assinaturas (subscription business).

O objetivo é criar um pipeline robusto e profissional --- incluindo
**tratamento, agregações, camada gold, MERGE incremental** e
**exportações** --- e disponibilizar tudo pronto para análises no Power
BI.

------------------------------------------------------------------------

## **Arquitetura do Projeto**

    subscription_project/
    │
    ├── data/
    │   ├── raw/                      
    │   ├── gold/                     
    │
    ├── sql/
    │   ├── 01_bronze.sql             
    │   ├── 02_silver.sql             
    │   ├── 03_gold.sql               
    │   ├── 04_export_gold.sql        
    │   ├── 05_export_all_gold.sql    
    │   ├── 06_incremental_gold.sql   
    │
    ├── subscription.duckdb           
    │
    ├── run_pipeline.py               
    ├── check_gold.py                 
    └── query.py                      

------------------------------------------------------------------------

## **Arquitetura Medallion**

### Bronze
Armazena os dados brutos exatamente como chegam da fonte, com mínima transformação e foco em preservação histórica.

### Silver
Padroniza, limpa e enriquece os dados da camada Bronze, aplicando regras de qualidade e preparando-os para modelagem.
### Gold
Modela os dados em estruturas analíticas (fatos e dimensões), criando métricas e tabelas prontas para consumo em dashboards e análises de negócio.

------------------------------------------------------------------------

## Como Rodar

``` bash
python run_pipeline.py
```

------------------------------------------------------------------------

## Power BI

-   Importação
-   Transformações
-   Medidas DAX
-   Visuais
-   Insights

------------------------------------------------------------------------

## Tecnologias

DuckDB, Python, SQL, Power BI.

------------------------------------------------------------------------

## Autor

Tulyo Rosa
