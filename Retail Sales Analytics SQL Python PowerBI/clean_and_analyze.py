import pandas as pd

# Load the source CSV files
customers = pd.read_csv("customers.csv")
products = pd.read_csv("products.csv")
orders = pd.read_csv("orders.csv", parse_dates=["order_date"])
items = pd.read_csv("order_items.csv")

# Basic data-quality checks
for name, df in {"customers": customers, "products": products,
                 "orders": orders, "order_items": items}.items():
    print(name, "shape:", df.shape)
    print("Duplicate rows:", df.duplicated().sum())
    print("Missing values:\n", df.isna().sum(), "\n")

# Remove exact duplicate rows
customers = customers.drop_duplicates()
products = products.drop_duplicates()
orders = orders.drop_duplicates()
items = items.drop_duplicates()

# Join tables to create an analysis-ready dataset
sales = (items.merge(orders, on="order_id", how="left")
              .merge(products, on="product_id", how="left")
              .merge(customers, on="customer_id", how="left"))

# Keep completed orders and calculate net sales after discount
sales = sales[sales["order_status"].eq("Completed")].copy()
sales["net_sales"] = (sales["quantity"] * sales["unit_price"]
                      * (1 - sales["discount_pct"])).round(2)
sales["sales_month"] = sales["order_date"].dt.to_period("M").astype(str)

# Export clean data for Power BI
sales.to_csv("clean_sales_for_powerbi.csv", index=False)

# Quick summary checks
print("Net sales:", round(sales["net_sales"].sum(), 2))
print("Units sold:", sales["quantity"].sum())
print(sales.groupby("city")["net_sales"].sum().sort_values(ascending=False))
print(sales.groupby("category")["net_sales"].sum().sort_values(ascending=False))