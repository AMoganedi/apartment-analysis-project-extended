import pandas as pd
import statsmodels.formula.api as smf

df = pd.read_csv("Database/propertyDatabase_apartment_clean.csv")
print(df.head())
print(df.shape)

#Check what estate agents exist in the column
print(df["Estate_Agent"].value_counts())

model = smf.ols("Property_price ~ Bedrooms + Bathrooms + Parking_space + Floor_size + Estate_Agent + Property_location"              
                , data=df).fit()
print(model.summary())