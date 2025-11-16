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

### Silver

### Gold

### Incremental MERGE

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
