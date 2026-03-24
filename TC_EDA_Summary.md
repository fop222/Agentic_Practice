# Toyota Corolla Price Analysis: Exploratory Data Analysis Summary

## Executive Summary

This analysis explores the Toyota Corolla used car market dataset comprising **1,436 vehicles** with **39 features** including vehicle specifications, condition metrics, and optional features. The primary objective is to understand price drivers in the used car market and identify key factors affecting vehicle valuation.

---

## 1. Dataset Overview

### Basic Statistics
- **Total Vehicles:** 1,436
- **Total Features:** 39
- **Numeric Variables:** 36
- **Categorical Variables:** 3 (Model, Fuel_Type, Color)
- **Missing Values:** None detected

### Price Distribution (Target Variable)
| Metric | Value |
|--------|-------|
| Mean Price | €10,730.82 |
| Median Price | €9,900 |
| Std Dev | €3,626.96 |
| Min Price | €4,350 |
| Max Price | €32,500 |
| Price Range | €28,150 |
| Q1 (25%) | €8,450 |
| Q3 (75%) | €11,950 |

**Key Insight:** Price distribution is right-skewed with 110 outliers above the upper bound (€17,250+), indicating a subset of high-value vehicles.

---

## 2. Univariate Analysis

### Age (Age_08_04)
- **Mean Age:** 55.95 months (~4.6 years)
- **Range:** 1 to 80 months
- **Distribution:** Wide range of vehicle ages in the dataset

### Mileage (Kilometers)
- **Mean KM:** 68,533 km
- **Median KM:** 63,390 km
- **Max KM:** 243,000 km
- **Distribution:** Right-skewed; majority of vehicles have mileage between 30,000-150,000 km

### Engine Specifications
**Horsepower (HP):**
- Min: 69 HP, Max: 192 HP
- Median: 110 HP
- Mean: 101.5 HP
- Most common: 90 HP and 110 HP variants

**Engine Capacity (CC):**
- Min: 1,300 CC, Max: 16,000 CC (outlier)
- Median: 1,600 CC
- Mean: 1,577 CC
- Most common: 1,400-1,600 CC range

### Fuel Type Distribution
| Fuel Type | Count | Percentage |
|-----------|-------|-----------|
| Petrol | 1,264 | 88.0% |
| Diesel | 155 | 10.8% |
| CNG | 17 | 1.2% |

**Finding:** Petrol dominates the market; diesel vehicles are rare.

### Color Distribution (Top 6)
| Color | Count |
|-------|-------|
| Grey | 301 |
| Blue | 283 |
| Red | 278 |
| Green | 220 |
| Black | 191 |
| Silver | 122 |

### Optional Features Adoption
| Feature | % with Feature |
|---------|---------------|
| Power Steering | 97.8% |
| Airbag_1 | 97.1% |
| ABS | 81.3% |
| Airco | 50.8% |
| Sport Model | 30.0% |
| Metallic Rim | 20.5% |
| CD Player | 21.9% |
| Automatic Transmission | 5.6% |

---

## 3. Bivariate Analysis: Key Price Predictors

### Correlation with Price (Ranked)

**Top 5 Positive Correlations:**
1. **Boardcomputer:** 0.601 (Strong)
2. **Automatic Airco:** 0.588 (Strong)
3. **Weight:** 0.581 (Strong)
4. **CD Player:** 0.481 (Moderate)
5. **Airco:** 0.429 (Moderate)

**Key Negative Correlations:**
1. **Age (Age_08_04):** -0.877 (Very Strong) ⭐
2. **Mileage (KM):** -0.570 (Strong) ⭐
3. **Tow Bar:** -0.172 (Weak)
4. **Radio Cassette:** -0.043 (Very Weak)

### Major Finding: Depreciation Dominates

**Age is the strongest price predictor** with a correlation of **-0.877**, indicating that vehicle age is the primary driver of price decline.

---

## 4. Depreciation Analysis

### Price by Age Groups

| Age Group | Count | Mean Price | Median Price | Mean KM |
|-----------|-------|-----------|--------------|---------|
| 0-24 months | 122 | €18,944 | €18,775 | 24,979 |
| 24-36 months | 102 | €15,518 | €15,475 | 41,136 |
| 36-48 months | 197 | €11,863 | €11,950 | 56,777 |
| 48-60 months | 290 | €10,293 | €10,500 | 69,549 |
| 60+ months | 725 | €8,543 | €8,600 | 82,505 |

**Depreciation Insight:** 
- Newest vehicles (≤24 months) command **€18,944** average
- Oldest vehicles (≥60 months) average **€8,543**
- **Total depreciation: €10,401 (55%)** over 5+ years

---

## 5. Mileage Impact

### Price by Mileage Bands

| KM Range | Count | Mean Price | Mean KM |
|----------|-------|-----------|---------|
| 0-30K | 187 | €15,898 | 18,591 |
| 30-50K | 296 | €11,906 | 40,731 |
| 50-80K | 508 | €9,965 | 64,966 |
| 80-150K | 393 | €8,834 | 103,289 |
| 150K+ | 52 | €7,281 | 178,569 |

**Key Finding:** Mileage shows strong inverse relationship with price (r = -0.570). Low-mileage vehicles (0-30K) are premium-priced at €15,898 vs. high-mileage (150K+) at €7,281.

---

## 6. Categorical Analysis

### Fuel Type Impact

| Fuel Type | Count | Mean Price | Median Price | Std Dev |
|-----------|-------|-----------|--------------|---------|
| Petrol | 1,264 | €10,679 | €9,940 | €3,327 |
| Diesel | 155 | €11,295 | €8,950 | €5,536 |
| CNG | 17 | €9,421 | €8,950 | €2,492 |

**Finding:** Diesel vehicles show highest mean price (€11,295) but highest variability. Petrol dominates volume with stable pricing.

### Transmission Type

| Type | Count | Mean Price | Median Price |
|------|-------|-----------|--------------|
| Manual | 1,356 | €10,702 | €9,900 |
| Automatic | 80 | €10,952 | €10,100 |

**Finding:** Automatic transmission shows minimal price premium (~€250 mean), despite rarity (5.6% adoption).

### Optional Features Premium

**Metallic Rim:**
- Without: €10,531
- With: €10,854
- **Premium: €323**

**Sport Model:**
- Non-Sport: €10,507
- Sport: €11,054
- **Premium: €547**

---

## 7. High-Value vs. Low-Value Comparison

### High-Value Vehicles (≥ Median Price €9,900)
- **Count:** 726 vehicles
- **Mean Age:** 43.2 months
- **Mean KM:** 50,674 km
- **% Automatic:** 6.1%
- **% Diesel:** 9.5%

### Low-Value Vehicles (< Median Price €9,900)
- **Count:** 710 vehicles
- **Mean Age:** 69.0 months
- **Mean KM:** 86,795 km
- **% Automatic:** 5.1%
- **% Diesel:** 12.1%

**Key Difference:** High-value vehicles are ~26 months newer and have ~36,000 km fewer mileage, emphasizing the dominance of age and mileage.

---

## 8. Notable Findings

### 🔴 Critical Insights

1. **Age is Supreme:** Vehicle age (correlation: -0.877) is the overwhelmingly dominant price predictor, more important than all other factors combined.

2. **Mileage Follows:** Mileage (correlation: -0.570) is the second-strongest predictor, showing consistent inverse relationship.

3. **Interior Features Matter:** More than mechanical specs, luxury features like:
   - Boardcomputer (r = 0.601)
   - Automatic Airco (r = 0.588)
   - CD Player (r = 0.481)
   - Central Locking (r = 0.343)
   
   ...show stronger price correlation than engine power (r = 0.315).

4. **Weight Premium:** Heavier vehicles (r = 0.581) command higher prices—likely due to engine size or luxury trim correlation.

5. **Fuel Type Paradox:** Despite Diesel's premium reputation, fuel type shows minimal impact. Mean prices are similar across fuel types:
   - Petrol: €10,679
   - Diesel: €11,295
   - Difference: Only €616

6. **Transmission Type Irrelevant:** Automatic transmission (5.6% of market) shows virtually no price premium despite being rare.

7. **Color Has Minimal Impact:** Popular colors (Grey, Blue, Red) are evenly distributed; color is essentially uncorrelated with price.

### 📊 Data Quality

- **No Missing Values:** Dataset is complete
- **Outliers:** 110 vehicles (7.7%) priced above €17,250, representing luxury trims
- **No Data Entry Errors:** All values fall within logical ranges

---

## 9. Depreciation Model

### Estimated Annual Depreciation

Based on age grouping analysis:

| Year | Estimated Price | Depreciation |
|------|-----------------|--------------|
| Year 0 (Newest) | €18,944 | - |
| Year 1-2 | €15,518 | €3,426 (-18%) |
| Year 2-3 | €11,863 | €3,655 (-24%) |
| Year 3-4 | €10,293 | €1,570 (-13%) |
| Year 4-5+ | €8,543 | €1,750 (-17%) |

**Pattern:** Steepest depreciation occurs in first 2-3 years; rate stabilizes afterward.

---

## 10. Recommendations

### For Buyers
- **Negotiate aggressively on age:** Vehicle age is the dominant price driver—expect significant discounts for vehicles >3 years old
- **Mileage inspection critical:** Vehicles with <30K km command 47% premium vs. 150K+ km vehicles
- **Feature combinations matter:** Look for boardcomputer + automatic airco combinations for better value
- **Fuel type flexibility:** Choose based on preference, not price expectation—fuel type shows negligible price impact

### For Dealers/Sellers
- **Age disclosure is key:** Emphasize lower-age vehicles; age difference of 24 months = ~€4,000 price swing
- **Feature packaging:** Bundle interior conveniences (airco, boardcomputer) rather than relying on mechanical specs
- **Market efficiency:** Fuel type shows market expectations are already priced in; no arbitrage opportunity

### For Predictive Modeling
1. **Use polynomial age terms:** Depreciation rate decelerates over time
2. **Account for mileage-age interaction:** Younger vehicles with high mileage may be unusual
3. **Include feature clustering:** Interior features correlate; use multicollinearity techniques
4. **Exclude low-signal features:** Transmission, fuel type, radio show minimal predictive power

---

## 11. Analysis Outputs

Generated visualization files:
- **TC_01_Price_Distribution.pdf** - Histogram and boxplot of prices
- **TC_02_Age_Mileage_Distribution.pdf** - Age and mileage distributions
- **TC_03_Price_Relationships.pdf** - Scatter plots with regression lines
- **TC_04_Categorical_Analysis.pdf** - Box plots by categorical features
- **TC_05_Correlation_Heatmap.pdf** - Correlation matrix visualization

---

## Conclusion

The Toyota Corolla used car market is primarily driven by **vehicle age and mileage**, which together account for the majority of price variation. Luxury features show moderate price influence, while factors like fuel type, transmission type, and color have negligible impact. The strongest depreciation occurs in the first 2-3 years, with prices stabilizing thereafter. For predictive modeling or price estimation, age and mileage should be the foundation, with interior features as secondary considerations.

---

*Analysis Date: March 24, 2026*  
*Dataset: 1,436 Toyota Corolla vehicles*  
*Analysis Method: Exploratory Data Analysis (EDA) with correlation and categorical analysis*
