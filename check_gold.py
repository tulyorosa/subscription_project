import duckdb

con = duckdb.connect("subscription.duckdb")

print("Schemas disponíveis:")
print(con.execute("SHOW SCHEMAS").df())

print("\nTabelas no schema gold:")
try:
    print(con.execute("SHOW TABLES IN gold").df())
except Exception as e:
    print("Erro ao listar tabelas no schema gold:")
    print(e)

print("\nPrévia da tabela gold.fact_subscriptions (se existir):")
try:
    df = con.execute("SELECT * FROM gold.fact_subscriptions LIMIT 5").df()
    print(df)
except Exception as e:
    print("Erro ao consultar gold.fact_subscriptions:")
    print(e)

con.close()
