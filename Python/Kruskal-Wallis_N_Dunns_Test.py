import pandas as pd
from scipy.stats import kruskal
import scikit_posthocs as sp


df = pd.read_csv("Database/propertyDatabase_apartment_clean.csv")
print(df.head())
print(df.info)


groups = df.groupby("Estate_Agent")["Property_price"].apply(list)
print(groups)

statistics, p_value = kruskal(*groups)
print(f"P Value: {p_value:.4f}")

alpha = 0.05
if p_value < alpha:
    
    dunn_data = []
    for city, prices in groups.items():
        for price in prices:
            dunn_data.append({"agent": city, "price": price})
            
    
    pd.set_option('display.float_format', '{:.10f}'.format)        
    dunn_df = pd.DataFrame(dunn_data)
    
    
    
    dunn_results = sp.posthoc_dunn(
        dunn_df,
        val_col = "price",
        group_col = "agent",
        p_adjust = "bonferroni"
    )
    
    dunn_reset = dunn_results.reset_index()
    dunn_reset.columns.name = None
    
    dunn_long = dunn_reset.melt(
        id_vars='index',
        var_name='Agent_2',
        value_name='p_value'
    )
    
    dunn_long.columns = ["Agent_1", "Agent_2", "p_value"]

    
    dunn_long.to_csv("Dunns_test_agents.csv", index=True)
else:
    print("There is little to no evidence proving a difference")