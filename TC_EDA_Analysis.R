# Comprehensive Exploratory Data Analysis: Toyota Corolla Dataset
# BUAN 348 - Vehicle Price Analysis

# Load data and required packages
corolla <- read.csv("ToyotaCorolla.csv")

# Install and load necessary packages
if (!require("dplyr")) install.packages("dplyr")
if (!require("corrplot")) install.packages("corrplot")
if (!require("car")) install.packages("car")

library(dplyr)
library(corrplot)
library(car)

# ============================================================================
# PART 1: DATA OVERVIEW
# ============================================================================

cat("\n=== DATA STRUCTURE ===\n")
str(corolla)

cat("\n=== DATASET DIMENSIONS ===\n")
cat("Rows:", nrow(corolla), "\nColumns:", ncol(corolla), "\n")

cat("\n=== FIRST FEW ROWS ===\n")
print(head(corolla, 3))

cat("\n=== COLUMN NAMES ===\n")
print(colnames(corolla))

cat("\n=== DATA TYPES SUMMARY ===\n")
cat("Numeric columns:", length(which(sapply(corolla, is.numeric))), "\n")
cat("Character columns:", length(which(sapply(corolla, is.character))), "\n")

# ============================================================================
# PART 2: UNIVARIATE ANALYSIS - KEY NUMERIC VARIABLES
# ============================================================================

cat("\n=== PRICE ANALYSIS (TARGET VARIABLE) ===\n")
cat("Mean Price:", round(mean(corolla$Price, na.rm = TRUE), 2), "\n")
cat("Median Price:", round(median(corolla$Price, na.rm = TRUE), 2), "\n")
cat("Std Dev Price:", round(sd(corolla$Price, na.rm = TRUE), 2), "\n")
cat("Min Price:", min(corolla$Price, na.rm = TRUE), "\n")
cat("Max Price:", max(corolla$Price, na.rm = TRUE), "\n")
cat("Price Range:", max(corolla$Price, na.rm = TRUE) - min(corolla$Price, na.rm = TRUE), "\n")
cat("Quartiles:\n")
print(quantile(corolla$Price, probs = c(0.25, 0.5, 0.75)))

cat("\n=== AGE (Age_08_04) ANALYSIS ===\n")
cat("Mean Age:", round(mean(corolla$Age_08_04, na.rm = TRUE), 2), "months\n")
cat("Range Age:", min(corolla$Age_08_04, na.rm = TRUE), "-", max(corolla$Age_08_04, na.rm = TRUE), "months\n")

cat("\n=== MILEAGE (KM) ANALYSIS ===\n")
cat("Mean Mileage:", round(mean(corolla$KM, na.rm = TRUE), 0), "km\n")
cat("Median Mileage:", round(median(corolla$KM, na.rm = TRUE), 0), "km\n")
cat("Max Mileage:", max(corolla$KM, na.rm = TRUE), "km\n")

cat("\n=== ENGINE SPECIFICATIONS ===\n")
cat("Summary of HP:\n")
print(summary(corolla$HP))
cat("\nSummary of CC:\n")
print(summary(corolla$CC))

cat("\n=== FUEL TYPE DISTRIBUTION ===\n")
fuel_table <- table(corolla$Fuel_Type)
print(fuel_table)
cat("Fuel Type Percentages:\n")
print(prop.table(fuel_table) * 100)

cat("\n=== COLOR DISTRIBUTION ===\n")
print(sort(table(corolla$Color), decreasing = TRUE))

cat("\n=== KEY FEATURE DISTRIBUTIONS ===\n")
features <- c("Automatic", "ABS", "Airbag_1", "Airco", "CD_Player", "Power_Steering", 
              "Metallic_Rim", "Sport_Model")
for (feature in features) {
  if (feature %in% colnames(corolla)) {
    pct <- round(mean(corolla[[feature]], na.rm = TRUE) * 100, 1)
    cat(feature, "- Percentage with feature:", pct, "%\n")
  }
}

# ============================================================================
# PART 3: BIVARIATE ANALYSIS - PRICE RELATIONSHIPS
# ============================================================================

cat("\n=== CORRELATION WITH PRICE ===\n")

# Select numeric columns excluding ID and Model
numeric_cols <- names(corolla)[sapply(corolla, is.numeric)]
numeric_cols <- numeric_cols[!numeric_cols %in% c("Id", "Mfg_Month", "Mfg_Year")]

# Calculate correlations with Price
correlations <- sapply(numeric_cols, function(col) {
  if (col != "Price") {
    cor(corolla$Price, corolla[[col]], use = "complete.obs")
  } else {
    NA
  }
})

# Sort correlations by absolute value
correlations_sorted <- sort(correlations[!is.na(correlations)], decreasing = TRUE)
print(correlations_sorted)

cat("\n=== TOP 5 PRICE PREDICTORS (BY CORRELATION) ===\n")
print(head(correlations_sorted, 5))

cat("\n=== NEGATIVE CORRELATIONS WITH PRICE ===\n")
negative_cors <- correlations_sorted[correlations_sorted < 0]
print(negative_cors)

# ============================================================================
# PART 4: CATEGORICAL ANALYSIS
# ============================================================================

cat("\n=== PRICE BY FUEL TYPE ===\n")
fuel_analysis <- corolla %>% group_by(Fuel_Type) %>%
  summarise(
    Count = n(),
    Mean_Price = round(mean(Price, na.rm = TRUE), 2),
    Median_Price = round(median(Price, na.rm = TRUE), 2),
    Std_Dev = round(sd(Price, na.rm = TRUE), 2),
    Min_Price = min(Price, na.rm = TRUE),
    Max_Price = max(Price, na.rm = TRUE)
  )
print(fuel_analysis)

cat("\n=== PRICE BY TRANSMISSION TYPE (Automatic) ===\n")
auto_analysis <- corolla %>% group_by(Automatic) %>%
  summarise(
    Transmission = ifelse(Automatic == 0, "Manual", "Automatic"),
    Count = n(),
    Mean_Price = round(mean(Price, na.rm = TRUE), 2),
    Median_Price = round(median(Price, na.rm = TRUE), 2)
  )
print(auto_analysis)

cat("\n=== PRICE BY METALLIC RIM ===\n")
rim_analysis <- corolla %>% group_by(Metallic_Rim) %>%
  summarise(
    Metallic_Rim_Present = ifelse(Metallic_Rim == 0, "No", "Yes"),
    Count = n(),
    Mean_Price = round(mean(Price, na.rm = TRUE), 2),
    Median_Price = round(median(Price, na.rm = TRUE), 2)
  )
print(rim_analysis)

# ============================================================================
# PART 5: AGE AND DEPRECIATION ANALYSIS
# ============================================================================

cat("\n=== DEPRECIATION ANALYSIS BY AGE ===\n")
age_bins <- cut(corolla$Age_08_04, breaks = c(0, 24, 36, 48, 60, 100), 
                labels = c("0-24mo", "24-36mo", "36-48mo", "48-60mo", "60+mo"))
age_analysis <- corolla %>% mutate(Age_Group = age_bins) %>%
  group_by(Age_Group) %>%
  summarise(
    Count = n(),
    Mean_Price = round(mean(Price, na.rm = TRUE), 2),
    Median_Price = round(median(Price, na.rm = TRUE), 2),
    Mean_Age = round(mean(Age_08_04, na.rm = TRUE), 1),
    Mean_KM = round(mean(KM, na.rm = TRUE), 0)
  )
print(age_analysis)

# ============================================================================
# PART 6: MILEAGE ANALYSIS
# ============================================================================

cat("\n=== MILEAGE AND PRICE ANALYSIS ===\n")
km_bins <- cut(corolla$KM, breaks = c(0, 30000, 50000, 80000, 150000, 300000), 
               labels = c("0-30K", "30-50K", "50-80K", "80-150K", "150K+"))
km_analysis <- corolla %>% mutate(KM_Group = km_bins) %>%
  group_by(KM_Group) %>%
  summarise(
    Count = n(),
    Mean_Price = round(mean(Price, na.rm = TRUE), 2),
    Median_Price = round(median(Price, na.rm = TRUE), 2),
    Mean_KM = round(mean(KM, na.rm = TRUE), 0)
  )
print(km_analysis)

# ============================================================================
# PART 7: MISSING VALUES AND DATA QUALITY
# ============================================================================

cat("\n=== MISSING VALUES CHECK ===\n")
missing_counts <- colSums(is.na(corolla))
if (sum(missing_counts) > 0) {
  print(missing_counts[missing_counts > 0])
} else {
  cat("No missing values detected\n")
}

cat("\n=== OUTLIER DETECTION (PRICE) ===\n")
Q1 <- quantile(corolla$Price, 0.25)
Q3 <- quantile(corolla$Price, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR
outliers <- which(corolla$Price < lower_bound | corolla$Price > upper_bound)
cat("Number of price outliers:", length(outliers), "\n")
if (length(outliers) > 0) {
  cat("Outlier prices range:", min(corolla$Price[outliers]), "-", max(corolla$Price[outliers]), "\n")
}

# ============================================================================
# PART 8: ADVANCED INSIGHTS
# ============================================================================

cat("\n=== HIGH-VALUE VS LOW-VALUE VEHICLES ===\n")
price_median <- median(corolla$Price)
high_value <- corolla %>% filter(Price >= price_median)
low_value <- corolla %>% filter(Price < price_median)

cat("High-Value Vehicles (>= Median):\n")
cat("  Count:", nrow(high_value), "\n")
cat("  Mean Age:", round(mean(high_value$Age_08_04), 1), "months\n")
cat("  Mean KM:", round(mean(high_value$KM), 0), "\n")
cat("  % Automatic:", round(mean(high_value$Automatic) * 100, 1), "%\n")
cat("  % Diesel:", round(sum(high_value$Fuel_Type == "Diesel") / nrow(high_value) * 100, 1), "%\n")

cat("\nLow-Value Vehicles (< Median):\n")
cat("  Count:", nrow(low_value), "\n")
cat("  Mean Age:", round(mean(low_value$Age_08_04), 1), "months\n")
cat("  Mean KM:", round(mean(low_value$KM), 0), "\n")
cat("  % Automatic:", round(mean(low_value$Automatic) * 100, 1), "%\n")
cat("  % Diesel:", round(sum(low_value$Fuel_Type == "Diesel") / nrow(low_value) * 100, 1), "%\n")

# ============================================================================
# PART 9: CREATE VISUALIZATIONS
# ============================================================================

cat("\n=== GENERATING VISUALIZATIONS ===\n")

# Price distribution
pdf("TC_01_Price_Distribution.pdf", width = 10, height = 6)
par(mfrow = c(1, 2))
hist(corolla$Price, main = "Distribution of Vehicle Prices", xlab = "Price (€)", 
     col = "steelblue", border = "white", breaks = 30)
boxplot(corolla$Price, main = "Box Plot of Prices", ylab = "Price (€)", col = "lightblue")
dev.off()

# Age and Mileage distributions
pdf("TC_02_Age_Mileage_Distribution.pdf", width = 10, height = 6)
par(mfrow = c(1, 2))
hist(corolla$Age_08_04, main = "Distribution of Vehicle Age", xlab = "Age (months)", 
     col = "lightcoral", border = "white", breaks = 30)
hist(corolla$KM, main = "Distribution of Vehicle Mileage", xlab = "Kilometers", 
     col = "lightgreen", border = "white", breaks = 30)
dev.off()

# Key relationships with Price
pdf("TC_03_Price_Relationships.pdf", width = 12, height = 10)
par(mfrow = c(2, 2))

plot(corolla$Age_08_04, corolla$Price, main = "Price vs. Age",
     xlab = "Age (months)", ylab = "Price (€)", col = "steelblue", pch = 19, cex = 0.8)
abline(lm(Price ~ Age_08_04, data = corolla), col = "red", lwd = 2)

plot(corolla$KM, corolla$Price, main = "Price vs. Mileage",
     xlab = "Kilometers", ylab = "Price (€)", col = "darkgreen", pch = 19, cex = 0.8)
abline(lm(Price ~ KM, data = corolla), col = "red", lwd = 2)

plot(corolla$HP, corolla$Price, main = "Price vs. Horsepower",
     xlab = "HP", ylab = "Price (€)", col = "darkorange", pch = 19, cex = 0.8)
abline(lm(Price ~ HP, data = corolla), col = "red", lwd = 2)

plot(corolla$Weight, corolla$Price, main = "Price vs. Weight",
     xlab = "Weight (kg)", ylab = "Price (€)", col = "purple", pch = 19, cex = 0.8)
abline(lm(Price ~ Weight, data = corolla), col = "red", lwd = 2)

dev.off()

# Categorical comparisons
pdf("TC_04_Categorical_Analysis.pdf", width = 12, height = 8)
par(mfrow = c(2, 2))

boxplot(Price ~ Fuel_Type, data = corolla, main = "Price by Fuel Type",
        xlab = "Fuel Type", ylab = "Price (€)", col = c("lightblue", "lightcoral"))

boxplot(Price ~ Automatic, data = corolla, main = "Price by Transmission",
        xlab = "Transmission Type", ylab = "Price (€)", 
        names = c("Manual", "Automatic"), col = c("lightgreen", "lightyellow"))

boxplot(Price ~ Metallic_Rim, data = corolla, main = "Price by Metallic Rim",
        xlab = "Metallic Rim", ylab = "Price (€)",
        names = c("No", "Yes"), col = c("lightcyan", "lightpink"))

boxplot(Price ~ Sport_Model, data = corolla, main = "Price by Sport Model",
        xlab = "Sport Model", ylab = "Price (€)",
        names = c("No", "Yes"), col = c("lightyellow", "lightcoral"))

dev.off()

# Correlation plot - exclude constant columns
pdf("TC_05_Correlation_Heatmap.pdf", width = 10, height = 8)
numeric_data <- corolla[, numeric_cols]
# Remove columns with zero variance
numeric_data <- numeric_data[, sapply(numeric_data, sd, na.rm = TRUE) > 0, drop = FALSE]
cor_matrix <- cor(numeric_data, use = "complete.obs")
corrplot.mixed(cor_matrix, upper = "circle", lower = "number", diag = "u", 
               order = "hclust", tl.cex = 0.7, number.cex = 0.6)
dev.off()

# Engine specifications
pdf("TC_06_Engine_Specifications.pdf", width = 10, height = 6)
par(mfrow = c(1, 2))
hist(corolla$CC, main = "Distribution of Engine Size (CC)", xlab = "CC", 
     col = "steelblue", border = "white", breaks = 20)
hist(corolla$HP, main = "Distribution of Horsepower", xlab = "HP", 
     col = "darkred", border = "white", breaks = 20)
dev.off()

cat("PDF visualizations created successfully!\n")

# ============================================================================
# PART 10: SUMMARY OF KEY FINDINGS
# ============================================================================

cat("\n=== KEY FINDINGS SUMMARY ===\n")

cat("\n1. DATASET SIZE AND COMPOSITION:\n")
cat("   - Total vehicles:", nrow(corolla), "\n")
cat("   - Total features:", ncol(corolla), "\n")

cat("\n2. PRICE CHARACTERISTICS:\n")
cat("   - Mean price: €", round(mean(corolla$Price), 2), "\n")
cat("   - Median price: €", round(median(corolla$Price), 2), "\n")
cat("   - Price range: €", min(corolla$Price), " - €", max(corolla$Price), "\n")
cat("   - Coefficient of variation:", round(sd(corolla$Price) / mean(corolla$Price) * 100, 1), "%\n")

cat("\n3. TOP PRICE PREDICTORS:\n")
for (i in 1:5) {
  cat("   ", names(correlations_sorted)[i], ":", 
      round(correlations_sorted[i], 3), "\n")
}

cat("\n4. FUEL TYPE IMPACT:\n")
diesel_price <- mean(corolla$Price[corolla$Fuel_Type == "Diesel"], na.rm = TRUE)
petrol_price <- mean(corolla$Price[corolla$Fuel_Type == "Petrol"], na.rm = TRUE)
cat("   - Diesel mean price: €", round(diesel_price, 2), "\n")
cat("   - Petrol mean price: €", round(petrol_price, 2), "\n")
cat("   - Price difference: €", round(abs(diesel_price - petrol_price), 2), "\n")

cat("\n5. AGE IMPACT (Depreciation):\n")
newest <- corolla %>% filter(Age_08_04 <= 24) %>% summarise(mean(Price))
oldest <- corolla %>% filter(Age_08_04 >= 60) %>% summarise(mean(Price))
cat("   - Newest vehicles (≤24 months): €", round(as.numeric(newest[1]), 2), "\n")
cat("   - Oldest vehicles (≥60 months): €", round(as.numeric(oldest[1]), 2), "\n")
cat("   - Depreciation: €", round(as.numeric(newest[1]) - as.numeric(oldest[1]), 2), "\n")

cat("\n6. OPTIONAL FEATURES PREMIUM:\n")
no_metallic <- mean(corolla$Price[corolla$Metallic_Rim == 0], na.rm = TRUE)
yes_metallic <- mean(corolla$Price[corolla$Metallic_Rim == 1], na.rm = TRUE)
cat("   - Price without metallic rim: €", round(no_metallic, 2), "\n")
cat("   - Price with metallic rim: €", round(yes_metallic, 2), "\n")
cat("   - Premium: €", round(yes_metallic - no_metallic, 2), "\n")

cat("\n=== ANALYSIS COMPLETE ===\n")
