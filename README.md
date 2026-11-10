# US Superstore Profitability & Margin Erosion Analysis

SQL analysis using **DuckDB** across 9,994 retail rows (`SampleSuperstore.csv`) to find the causes of profit losses across categories, states, shipping modes, and customer segments.

---

## 1. Summary Metrics

| Metric | Value | Notes |
| :--- | :--- | :--- |
| **Total Sales** | `$2,297,200.86` | 3 categories, 17 sub-categories |
| **Total Net Profit** | `$286,397.02` | Net profit margin: `12.47%` |
| **Total Units Sold** | `37,873` | Across 49 US states |
| **Loss-Making States (10)** | `-$98,246.74` | Led by Texas (`-$25,729.36`) |

---

## 2. Key Findings

### A. Category & Sub-Category Losses
* **Furniture Margin Compression:** Generates `$741,999.80` in sales (32.3% of total) but only `$18,451.27` in profit (`2.49%` margin), compared to `17.40%` in **Technology** (`$145,454.95`) and `17.04%` in **Office Supplies** (`$122,490.80`).
* **Loss-Making Sub-Categories:**
  1. **Tables:** `-$17,725.48` loss on `$206,965.53` sales (`-8.56%` margin, `26.13%` avg. discount).
  2. **Bookcases:** `-$3,472.56` loss on `$114,880.00` sales (`-3.02%` margin, `21.11%` avg. discount).
  3. **Supplies:** `-$1,189.10` loss on `$46,673.54` sales (`-2.55%` margin, `7.68%` avg. discount).
* **High Discount Impact:** **Machines** generates `$189,238.63` in sales with only `$3,384.76` profit (`1.79%` margin) at a `30.61%` average discount.

### B. State-Level Losses
* **10 Unprofitable States:** Texas (`-$25,729.36`), Ohio (`-$16,971.38`), Pennsylvania (`-$15,559.96`), Illinois (`-$12,607.89`), North Carolina (`-$7,490.91`), Colorado (`-$6,527.86`), Tennessee (`-$5,341.69`), Arizona (`-$3,427.92`), Florida (`-$3,399.30`), and Oregon (`-$1,190.47`).
* **Discount Pattern:** All 10 unprofitable states average `28.35%` to `39.00%` in discounts. Top profitable states keep average discounts low: **California** (`+$76,381.39` profit at `7.28%` discount) and **New York** (`+$74,038.55` profit at `5.53%` discount).

### C. Shipping Mode & Segment Breakdown
* **Shipping Mode Check (Texas Tables):** All shipping modes in Texas carry a flat `30.00%` discount. **Standard Class** accounts for the largest loss (`-$1,466.03`), showing that discounting—not expedited shipping—causes the loss.
* **Customer Segments:** **Consumer** generates the most sales (`$1,161,401.34`) and profit (`$134,119.21`) but has the lowest margin (`11.55%`), behind **Corporate** (`13.03%`) and **Home Office** (`14.03%`).
* **Texas Consumer Losses:** Within the Texas Consumer segment, losses are concentrated in **Binders** (`-$12,166.62` on `$7,405.70` sales, `-164.29%` margin), **Appliances** (`-$4,252.27` on `$1,654.18` sales, `-257.06%` margin), and **Tables** (`-$1,741.56` on `$11,882.54` sales, `-14.66%` margin).

---

## 3. Recommendations

1. **Cap Regional Discounts:** Limit discounts to `15%` in Texas, Ohio, Pennsylvania, and Illinois.
2. **Adjust Product Pricing:** Remove `30%+` promotional discounts on **Tables** and **Bookcases** nationwide, and stop discounting **Binders** and **Appliances** in Texas.
3. **Revise Consumer Promotions:** Replace flat percentage discounts in the `Consumer` segment with minimum order quantity thresholds.

---

## 4. Project Files & Local Server

* `00_raw/SampleSuperstore.csv` — Raw dataset (9,994 rows).
* `01_sql/analysis_queries.sql` — DuckDB SQL script (1 view + 6 diagnostic queries).
* `02_outputs/` — Exported CSV results for each query.
* `index.html` — Interactive dashboard (built using AI prompting with SQL query outputs).

```bash
python3 -m http.server 8081
```
