import duckdb

result = duckdb.query("SELECT 42 AS resposta").to_df()
print(result)
