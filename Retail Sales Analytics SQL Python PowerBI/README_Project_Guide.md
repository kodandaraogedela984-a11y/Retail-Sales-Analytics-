# Retail Sales Analytics – End-to-End Data Analyst Project

## Business problem
A retail business wants to understand sales performance across months, cities, product categories and customers. The dataset is synthetic and created for learning.

## Tools
- Python (Pandas): inspect data, check missing/duplicate rows, join tables, calculate net sales, export clean data.
- MySQL: store normalized tables and answer business questions with JOIN, GROUP BY, aggregate functions, subqueries and sorting.
- Power BI: build an interactive dashboard from `clean_sales_for_powerbi.csv` or from MySQL.

## Files
- customers.csv, products.csv, orders.csv, order_items.csv: source data
- analysis_queries.sql: MySQL schema and business analysis queries
- clean_and_analyze.py: Python data cleaning and analysis script

## How to complete
1. Install Python and pandas (`pip install pandas`).
2. Keep all CSV files and `clean_and_analyze.py` in one folder. Run `python clean_and_analyze.py`.
3. In MySQL Workbench, run `analysis_queries.sql`, then import the four CSV files into their matching tables using the Table Data Import Wizard. Run the analysis queries.
4. In Power BI Desktop, Get Data > Text/CSV > select `clean_sales_for_powerbi.csv`.
5. Create KPI cards: Net Sales, Orders, Units Sold, Average Order Value.
6. Create visuals: monthly net sales line chart, city-wise sales bar chart, category sales donut/bar chart, top products table.
7. Add slicers for city, category, segment and sales month.
8. Validate Power BI totals against SQL query results.

## Suggested Power BI measures
```DAX
Net Sales = SUM(clean_sales_for_powerbi[net_sales])
Units Sold = SUM(clean_sales_for_powerbi[quantity])
Order Count = DISTINCTCOUNT(clean_sales_for_powerbi[order_id])
Average Order Value = DIVIDE([Net Sales], [Order Count])
```

## Business questions to answer
- Which month generated the highest sales?
- Which city contributed the most revenue?
- Which product/category sold the most?
- Who are the top 10 customers?
- What percentage of orders were returned or cancelled?

## Resume entry (use after you complete and verify it)
**Retail Sales Analysis | Python, MySQL, Power BI**
- Cleaned and transformed multi-table retail sales data using Python (Pandas), handling duplicate records and creating net-sales metrics.
- Designed and queried a relational MySQL database using joins, aggregations, subqueries and GROUP BY to answer business questions.
- Built an interactive Power BI dashboard with KPI cards, monthly trends, product/category and city-level analysis, and slicers.
- Reconciled dashboard KPIs with SQL outputs to validate reporting accuracy.

Note: All records are synthetic sample data, not real company/client data. Do not claim business impact or real client experience.