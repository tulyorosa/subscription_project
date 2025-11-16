import duckdb

con = duckdb.connect("subscription.duckdb")

query = """
SELECT *
FROM gold.staging_fact
"""

df = con.execute(query).df()
print(df)

con.close()
