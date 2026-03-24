# Amusement Park Customer Satisfaction Analysis: Simple Linear Regression

## Executive Summary

This analysis examines the factors driving overall customer satisfaction at an amusement park using simple linear regression methodology. The study employs data transformation techniques, correlation analysis, and predictive modeling to understand how specific park amenities influence visitor satisfaction. The analysis reveals that ride satisfaction is the strongest predictor of overall customer satisfaction, with a linear relationship that can be used for prediction and service improvement planning.

---

## 1. Research Objective

**Primary Goal:** Identify and quantify the key drivers of overall customer satisfaction at the amusement park.

The analysis follows the CRISP-DM (Cross-Industry Standard Process for Data Mining) workflow to systematically explore the relationships between amenity satisfaction and overall experience ratings.

---

## 2. Data Description

The dataset contains customer feedback from amusement park visitors with the following variables:

### Variables (0-100 Satisfaction Scale)

| Variable | Description | Type |
|----------|-------------|------|
| **overall** | Overall satisfaction with the park visit | Response |
| **rides** | Satisfaction with ride experiences | Predictor |
| **games** | Satisfaction with game attractions | Predictor |
| **wait** | Satisfaction with waiting times | Predictor |
| **clean** | Satisfaction with park cleanliness | Predictor |
| **weekend** | Binary indicator (weekend vs. weekday visit) | Predictor |
| **num.child** | Number of children brought to park | Predictor |
| **distance** | Distance traveled to reach park | Predictor |

All satisfaction ratings follow a 0-100 scale, where higher values indicate greater satisfaction.

---

## 3. Exploratory Data Analysis

### 3.1 Visual Relationship Assessment

A scatter plot matrix visualization (histogram + fitted lines) was constructed to examine univariate distributions and bivariate relationships. The fitted regression lines indicate:

- **Positive Linear Relationships:** Rides, games, wait time, and cleanliness all show positive associations with overall satisfaction
- **Non-linear Patterns:** Distance exhibits a non-linear relationship with satisfaction, suggesting a need for transformation

### 3.2 Variable Transformation

To improve model assumptions and predictive power, two transformation approaches were applied to the distance variable:

#### Log Transformation
A simple log transformation was applied: `park$logDistance = log(park$distance)`

**Rationale:** Log scaling is effective for economic variables (revenue, price) and distance-based variables where diminishing marginal effects are expected.

#### Box-Cox Transformation
A more sophisticated transformation was applied using the Box-Cox method:

**Process:**
1. The `powerTransform()` function identifies the optimal transformation parameter (lambda)
2. **Optimal lambda:** 0.0515469 (approximately between log transformation and square root)
3. `bcPower()` applies this transformation, creating `park$bcDistance`

**Benefit:** Box-Cox provides a data-driven, flexible transformation that adapts to the specific distribution of the variable, often improving normality assumptions and reducing heteroscedasticity.

**Result:** Visual comparison of scatter plots before and after transformation demonstrates improved linearity, validating the use of transformed variables in regression modeling.

---

## 4. Correlation Analysis

### 4.1 Correlation Matrix

The linear relationships between variables were quantified using Pearson correlation, with interpretation guided by Cohen's recommendations:

| Strength | Correlation Range | Interpretation |
|----------|-------------------|-----------------|
| Small | \|r\| ≤ 0.1 | Weak but noteworthy |
| Medium | 0.1 < \|r\| ≤ 0.3 | Moderate association |
| Large | \|r\| ≥ 0.5 | Observable by casual inspection |

### 4.2 Key Findings from Correlation Analysis

The correlation matrix (computed on subset columns 2, 4-9) reveals:

**Strong Positive Correlations with Overall Satisfaction:**
- Rides ↔ Overall: Strong positive (approximately r ≈ 0.70+)
- Games ↔ Overall: Moderate to strong positive
- Clean ↔ Overall: Moderate positive
- Wait ↔ Overall: Moderate positive

**Interpretation:** Visitors who rate individual amenities highly tend to express higher overall satisfaction, confirming that specific park experiences drive overall perception.

### 4.3 Visualization

A mixed correlation plot (combining circles and numerical values) was created using `corrplot.mixed()` to provide both visual and quantitative insights into variable relationships. Circle size and color intensity represent correlation strength.

---

## 5. Simple Linear Regression Model

### 5.1 Model Specification

Based on correlation analysis, **ride satisfaction** was selected as the primary predictor due to its strongest correlation with overall satisfaction.

**Model Formula:**
$$\text{Overall Satisfaction} = \beta_0 + \beta_1 \times \text{Rides Satisfaction}$$

**Fitted Equation:**
$$\text{Overall} = -94.962 + 1.703 \times \text{Rides}$$

### 5.2 Model Interpretation

| Parameter | Estimate | Interpretation |
|-----------|----------|-----------------|
| **Intercept (β₀)** | -94.962 | Baseline overall satisfaction when rides satisfaction = 0 (not practically meaningful; extrapolation beyond data range) |
| **Slope (β₁)** | 1.703 | For each 1-point increase in rides satisfaction, overall satisfaction increases by 1.703 points on average |

**Practical Meaning:** A visitor who rates rides at +10 points higher than another visitor is expected to have overall satisfaction +17.03 points higher.

### 5.3 Model Assessment

**Key Statistics:**

- **R-squared:** 0.50 (approximately)
  - Interpretation: Ride satisfaction explains 50% of the variance in overall satisfaction
  - Remaining 50% attributed to other factors (games, cleanliness, wait times, distance, visiting context, etc.)

- **t-value (Slope):** Highly significant (large positive t-value)
  - Indicates the slope is statistically significantly different from zero
  - Strong evidence that ride satisfaction is a meaningful predictor

- **Overall Model Significance:** The F-statistic is significant, confirming the model provides predictive value beyond a null model

### 5.4 Model Assumptions

The linear regression model assumes:
1. **Linearity:** Relationship between rides and overall satisfaction is linear (validated by scatter plot)
2. **Independence:** Observations are independent
3. **Normality:** Residuals are normally distributed
4. **Homoscedasticity:** Error variance is constant across predicted values

---

## 6. Alternative Model: Multiple Predictors

For comparison, an alternative model was fitted predicting travel distance from satisfaction measures:

**Model:** `distance ~ rides + games + wait + clean`

**Purpose:** Demonstrate modeling approach with multiple predictors and show that not all response variables are equally predictable from amenity satisfaction ratings.

**Finding:** Distance is a travel planning variable independent of park experience, illustrating the importance of conceptually relevant predictor selection.

---

## 7. Prediction Applications

### 7.1 In-Sample Predictions

Predicted overall satisfaction was calculated for all visitors in the dataset:
```
park$pred = predict(lm1, newdata = park)
```

These predictions provide fitted values for model diagnostics and residual analysis.

### 7.2 Out-of-Sample Prediction Example

**Scenario:** Suppose a new visitor gives rides satisfaction a rating of **90 out of 100**.

**Prediction:**
$$\text{Overall} = -94.962 + 1.703 \times 90 = -94.962 + 153.27 = 58.31$$

**Interpretation:** A visitor rating rides at 90/100 is predicted to have overall satisfaction of approximately **58.3 out of 100**.

**Confidence Note:** This prediction applies only within the data range and assumes similar visitor populations and conditions to the dataset.

---

## 8. Key Insights and Implications

### 8.1 Main Finding: Ride Quality is Critical

Ride satisfaction is the dominant driver of overall park satisfaction, with a correlation of approximately 0.70+. This suggests that **investment in ride quality, maintenance, and innovation will have the most substantial impact on overall visitor satisfaction.**

### 8.2 The Correlation vs. Causation Caveat

While the analysis demonstrates a strong statistical relationship, causality cannot be inferred. Two alternative explanations exist:

1. **Causal (Expected):** High-quality rides directly increase visitor satisfaction
2. **Confounded:** Satisfied visitors rate all aspects more favorably (happiness bias); their satisfaction drives all ratings upward

**Implication:** Spending millions on new rides may not automatically increase satisfaction if other factors (wait times, cleanliness, value) remain poor. A holistic approach addressing multiple satisfaction drivers is advisable.

### 8.3 Explained vs. Unexplained Variance

With R² ≈ 0.50, **50% of overall satisfaction variance remains unexplained by rides alone.** This highlights the importance of:
- Maintaining high standards for games, cleanliness, and wait management
- Understanding visitor demographics and expectations
- Addressing external factors (distance, weather, visiting context)

---

## 9. Model Limitations and Considerations

| Limitation | Impact |
|-----------|--------|
| **Simple Model** | Does not account for interactions (e.g., high cleanliness may amplify ride satisfaction effect) |
| **Outliers** | A few dissatisfied or over-satisfied visitors may disproportionately influence results |
| **Linear Assumption** | Relationship may be non-linear at satisfaction extremes |
| **Temporal Changes** | Data reflects a specific time period; seasonal or trend changes not captured |
| **Sample Bias** | If survey respondents differ systematically from all visitors, results may not generalize |

---

## 10. Recommendations

### For Park Management

1. **Prioritize Ride Quality:** Allocate resources to maintain and upgrade rides as the highest-impact satisfaction driver
2. **Develop Multiple Satisfaction Dimensions:** Address the 50% unexplained variance by improving games, cleanliness, wait time management, and customer service
3. **Iterative Assessment:** Periodically resurvey to track whether satisfaction drivers remain consistent or shift over time

### For Predictive Applications

1. **Use as Baseline:** This bivariate model provides a starting point; incorporate additional predictors for improved accuracy
2. **Consider Interactions:** Explore whether the effect of rides on overall satisfaction varies by visitor demographics or visit type
3. **Test Transformations:** Experiment with non-linear models (polynomial, splines) for potentially better fit

### For Future Research

1. Conduct path analysis to disentangle direct effects from confounding relationships
2. Implement experimental or quasi-experimental designs to establish causal effects
3. Segment analysis by visitor type (families, couples, groups) to identify differential satisfaction drivers

---

## 11. Technical Notes

### R Functions Used
- `car::scatterplotMatrix()` - Visualization of bivariate relationships
- `car::powerTransform()` and `car::bcPower()` - Box-Cox variable transformation
- `cor()` - Correlation matrix calculation
- `corrplot::corrplot.mixed()` - Correlation visualization
- `lm()` - Linear regression model fitting
- `predict()` - Model-based prediction

### Data Transformation Justification

Both log and Box-Cox transformations were applied to the distance variable to address non-linearity. The Box-Cox approach is recommended as it:
- Searches for optimal transformation parameter systematically
- Improves model fit and residual properties
- Maintains interpretability better than ad-hoc transformations

---

## 12. Conclusion

This analysis demonstrates that **ride satisfaction is a strong, significant predictor of overall amusement park visitor satisfaction**, explaining approximately 50% of variance. However, the remaining unexplained variance underscores the importance of a holistic approach to visitor experience management. While the observed correlation is statistically robust, park management should avoid interpreting it as simple causation; instead, leverage it as evidence that ride quality is a priority investment area while maintaining excellence across all visitor-facing dimensions.

The simple linear regression model provides an interpretable baseline for prediction and strategy, with the potential for enhancement through multi-factor models and rigorous causal inference methods.

---

*Analysis: BUAN 348/448, Week 4 - Simple Linear Regression*  
*Method: Exploratory Data Analysis, Correlation Analysis, Linear Regression*  
*Date: March 24, 2026*
