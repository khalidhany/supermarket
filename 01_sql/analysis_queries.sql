-- =============================================================================
-- Project: US Superstore Profitability & Margin Erosion Analysis
-- Engine:  DuckDB
-- Purpose: Top-down diagnostic SQL pipeline to isolate financial leakage across
--          product divisions, geographic states, shipping modes, and segments.
-- =============================================================================

-- 0. DATA STANDARDIZATION LAYER (Silver View)
CREATE OR REPLACE VIEW clean_raw AS
SELECT
    "Ship Mode"    AS ship_mode,
    "Segment"      AS segment,
    "Country"      AS country,
    "City"         AS city,
    "State"        AS state,
    "Postal Code"  AS postal_code,
    "Region"       AS region,
    "Category"     AS category,
    "Sub-Category" AS sub_category,
    "Sales"        AS sales,
    "Quantity"     AS quantity,
    "Discount"     AS discount,
    "Profit"       AS profit
FROM raw_data;


-- 1. EXECUTIVE MACRO OVERVIEW: Division Performance
-- Evaluates revenue, net profit, and margin efficiency across core categories.
SELECT 
    category,
    SUM(quantity) AS total_units,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin_pct,
    ROUND(AVG(discount) * 100.0, 2) AS avg_discount_pct
FROM clean_raw
GROUP BY category
ORDER BY total_profit DESC;


-- 2. PRODUCT P&L DRILL-DOWN: Sub-Category Profitability
-- Identifies loss-making product lines and quantifies discount correlation.
SELECT 
    category,
    sub_category,
    SUM(quantity) AS total_units,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin_pct,
    ROUND(AVG(discount) * 100.0, 2) AS avg_discount_pct
FROM clean_raw
GROUP BY category, sub_category
ORDER BY total_profit ASC;


-- 3. GEOGRAPHIC LEAKAGE AUDIT: State-Level Performance
-- Ranks all 49 states by net profit to isolate regional margin erosion.
SELECT 
    region,
    state,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin_pct,
    ROUND(AVG(discount) * 100.0, 2) AS avg_discount_pct
FROM clean_raw
GROUP BY region, state
ORDER BY total_profit ASC;


-- 4. OPERATIONAL HYPOTHESIS TEST: Shipping Mode Impact (Texas - Tables)
-- Tests whether expedited shipping drives losses in the worst-performing category/state.
SELECT 
    ship_mode,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount) * 100.0, 2) AS avg_discount_pct
FROM clean_raw
WHERE sub_category = 'Tables' 
  AND state = 'Texas'
GROUP BY ship_mode
ORDER BY total_profit ASC;


-- 5. CUSTOMER SEGMENT ECONOMICS: Volume vs. Margin Efficiency
-- Compares revenue contribution and profit margin across customer segments.
SELECT 
    segment,
    SUM(quantity) AS total_units,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin_pct,
    ROUND(AVG(discount) * 100.0, 2) AS avg_discount_pct
FROM clean_raw
GROUP BY segment
ORDER BY total_profit DESC;


-- 6. ROOT-CAUSE ISOLATION: Texas Consumer Sub-Category Breakdown
-- Isolates SKU-level losses within the largest customer segment in the worst-performing state.
SELECT 
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin_pct
FROM clean_raw
WHERE segment = 'Consumer' 
  AND state = 'Texas'
GROUP BY sub_category
ORDER BY total_profit ASC;
