import pandas as pd
import numpy as np
from scipy.stats import rankdata

df = pd.read_csv("Database/propertyDatabase_apartment_clean.csv",
                 index_col=0)
print(df.head())
print(df.info)


df["rank"] = rankdata(df["Property_price"], method = "average")

mean_ranks = df.groupby("Estate_Agent")["rank"].mean().sort_values(ascending=False)

for city, mean_rank in mean_ranks.items():
    print(f"{city}: {mean_rank:.2f}")