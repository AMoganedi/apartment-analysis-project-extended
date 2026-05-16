# apartment-analysis-project-extended
## Project Overview
This project focuses on apartment price variation across four cities in
Gauteng: Pretoria, Sandton, Johannesburg, and Midrand. We explore
attributes such as the location of apartments; the number of bedrooms,
bathrooms and parking spaces each apartment has; the floor size of the
apartment; and the estate agent each apartment complex belongs to. The
aim is to understand how each feature influences price differences across
apartments.

## Data Source
Property24.com

## Tools
 - Python Pandas
 - MySQL
 - Tableau
 - PowerPoint
 - Microsoft

## Data Cleaning
Used MySQL to perform all of the data cleaning:
- Removed duplicates, listings that do not have estate agents, categories with a low sample size, & outliers
- Edited the apartment type names
- TRIMMED categorical data
- Converted datapoints to appropriate data types

## Understanding the data
The exploratory data analysis phase included the following:

- Calculating range, mean, mode and median for measure
- Studied the distribution of each measure using the mean, mode, median method and a histogram
- Studied the correlation of measures to see how they relate with each other
- Calculated the interquartile range and Kurtosis to look for statistical outliers

## Data Analysis
> The correlation relationship between the internal features and price
```sql
-- Pearson Correlation
SELECT
	ROUND((SUM((parking_space - bd_mean) * (property_price - price_mean)))/
    (STDDEV(parking_space) * STDDEV(property_price) * (COUNT(*) - 1)), 2) AS correlation
FROM propertydatabase_staging2
CROSS JOIN (
	SELECT 
		AVG(parking_space) AS bd_mean,
        AVG(Property_price) AS price_mean
	FROM propertydatabase_staging2) AS means;
```

> The simple linear regression equation's slope
```sql
-- Simple Linear Regression slope
SELECT ROUND(SUM((floor_size - 75.57)*(property_price - 13212.8330))/
		SUM(POW(floor_size - 75.57, 2)),2) AS Slope
FROM propertydatabase_staging2;
```
> The Kruskall-Wallis Test and posthoc Dunn's Test to substantiate the difference between categories
```python
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
```

## Key Findings

- Combined, all six observed attributes in this dataset account for about 59.8% of monthly price variation across apartment listings. Unobserved features, such as amenities, apartment furnishings, and extras, could account for the remaining 40.2%.
- There is a very inconsistent relationship (0.23) between bedrooms and monthly price. This indicates that bedrooms only account for about 5.29% of price variation between listings. When price responds to bedrooms, it usually drives up by R3 481.47.
- There is a moderately consistent relationship (0.48) between bathrooms and monthly price. This indicates that bathrooms account for about 23% of price variation between listings. When price does respond to bathrooms, it usually drives up by R8 211.95 in this dataset.
- There is very low correlation (0.22) between parking spaces and monthly prices, which indicates that the number of parking spaces only accounts for around 4.84% of price variation between listings. Each additional parking space drives prices up by R408.71.
- There is a fragile correlation (0.13) between the floor size and monthly prices, which indicates that the floor size only accounts for around 1.69% of price variation between listings. When price does respond to floor size, it usually drives up by R53.52.
- After running the Kruskal-Wallis Test on the cities in the database, we can conclude that location influences price variation across apartment listings. Furthermore, Sandton tends to have higher-priced apartments than the other three cities (Midrand, Pretoria and Johannesburg). The points are similar for estate agents.

## Final thoughts

Monthly prices always consider intrinsic properties such as bedrooms, bathrooms, and floor size, so it was fascinating to learn how much they influence the price variation and in what ways they do. Furthermore, we were able to substantiate our claim that price is dependent on location, indicating that cities such as Sandton tend to have higher-priced apartments than cities such as Pretoria. We have also observed a systematic difference between estate agents.

## Limitations

We couldn't include more cities in Gauteng because of their naturally low sample size that could introduce sample bias.

## References

- https://www.geeksforgeeks.org/python/how-to-perform-a-kruskal-wallis-test-in-python/
- https://www.geeksforgeeks.org/machine-learning/how-to-perform-dunns-test-in-python/
