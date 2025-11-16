import duckdb
from pathlib import Path

DB_FILE = "subscription.duckdb"

SQL_FILES = [
    "sql/01_bronze.sql",
    "sql/02_silver.sql",
    "sql/03_gold.sql",
    "sql/04_export_gold.sql",
    "sql/05_export_all_gold.sql",
    "sql/06_incremental_gold.sql"

]

def main():
    con = duckdb.connect(DB_FILE)

    for file in SQL_FILES:
        path = Path(file)
        print(f"\n=== Executando {path} ===")

        sql = path.read_text(encoding="utf-8")

        # aqui o DuckDB executa o SCRIPT INTEIRO
        con.execute(sql)

    con.close()
    print("\n✔ Pipeline concluído!")

if __name__ == "__main__":
    main()
