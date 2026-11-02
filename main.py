# import duckdb
# from dotenv import load_dotenv

# load_dotenv()

# con = duckdb.connect("md:")

# # Show all databases
# print("DATABASES:")
# print(con.execute("SHOW DATABASES").fetchdf())

# # Show tables in data_jobs
# print("\nTABLES:")
# print(con.execute("SHOW ALL TABLES").fetchdf())

# con.close()


# import duckdb
# from dotenv import load_dotenv

# load_dotenv()

# con = duckdb.connect("md:")

# # Get all tables
# tables = con.execute("SHOW ALL TABLES").fetchdf()

# # Filter only data_jobs database
# jobs_tables = tables[
#     tables["database"] == "data_jobs"
# ]

# print("\nTABLES IN DATA_JOBS:")
# print(jobs_tables[["database", "schema", "name"]].to_string(index=False))

# con.close()

# import duckdb
# from dotenv import load_dotenv

# load_dotenv()

# con = duckdb.connect("md:")

# with open("queries/01_exploration.sql", "r") as file:
#     queries = file.read().split(";")

# for i, query in enumerate(queries, 1):
#     query = query.strip()

#     if not query:
#         continue

#     print(f"\n--- Query {i} ---")

#     try:
#         result = con.execute(query)

#         if result is not None:
#             df = result.fetchdf()
#             print(df.to_string(index=False))
#         else:
#             print("Query executed successfully.")

#     except Exception as e:
#         print("Error:", e)

# con.close()

import duckdb
from dotenv import load_dotenv
import sys

load_dotenv()

# MotherDuck connection
con = duckdb.connect("md:")

# SQL file name from terminal
if len(sys.argv) < 2:
    print("Usage: python main.py <sql_file>")
    sys.exit(1)

file_path = sys.argv[1]

try:
    with open(file_path, "r") as file:
        queries = file.read().split(";")

    for i, query in enumerate(queries, 1):
        query = query.strip()

        if not query:
            continue

        print(f"\n--- Query {i} ---")

        result = con.execute(query)

        if result is not None:
            print(result.fetchdf().to_string(index=False))

except Exception as e:
    print("Error:", e)

finally:
    con.close()