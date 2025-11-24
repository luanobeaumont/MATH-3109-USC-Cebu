library(mice) 

setwd("~/School/MATH-3109/PROBSET-4")

raw_data = read.csv("income.csv")
print(raw_data)
View(raw_data)


na_indices <- which(is.na(raw_data), arr.ind = TRUE)

missing_locations <- data.frame(
    Row_Number = na_indices[, 1],
    Column_Name = colnames(raw_data)[na_indices[, 2]]
)

missing_locations <- missing_locations[order(missing_locations$Row_Number), ]

print("Detailed Missing Value Locations:")
formatted_list <- paste("Row", missing_locations$Row_Number, "-", missing_locations$Column_Name)
print(formatted_list)

print(missing_locations)
View(missing_locations)

raw_data$Gender <- factor(raw_data$Gender, levels=c("Male", "Female"))
raw_data$Education <- factor(raw_data$Education, levels=c("PhD", "Master", "Bachelor", "Highschool"))

vars_with_missing <- colnames(raw_data)[colSums(is.na(raw_data)) > 0]

cat("Variables containing missing values:\n")
cat(vars_with_missing, sep = "\n")

init <- mice(raw_data, maxit=0)

methods <- init$method
methods["Gender"] <- "logreg"
methods["Education"] <- "polyreg"
methods["Age"] <- "pmm"
methods["Income"] <- "pmm"
methods["Satisfaction"] <- "pmm"
methods["PurchaseAmount"] <- "pmm"

imputed_data <- mice(raw_data, method = methods, m = 5, seed = 123, printFlag=FALSE)

complete_data <- complete(imputed_data, 1)
print(complete_data)

print(summary(raw_data))
print(summary(complete_data))

# Age
png("Age_comparison.png", width = 800, height = 600)
par(mfrow = c(1, 2))
hist(raw_data$Age, main = "Before Imp: Age", xlab = "Age", col = "blue", border = "black")
hist(complete_data$Age, main = "After Imp: Age", xlab = "Age", col = "red", border = "black")
dev.off()

# Income
png("Income_comparison.png", width = 800, height = 600)
par(mfrow = c(1, 2))
hist(raw_data$Income, main = "Before Imp: Income", xlab = "Income", col = "blue", border = "black")
hist(complete_data$Income, main = "After Imp: Income", xlab = "Income", col = "red", border = "black")
dev.off()

# PurchaseAmount
png("Purchaseamount_comparison.png", width = 800, height = 600)
par(mfrow = c(1, 2))
hist(raw_data$PurchaseAmount, main = "Before Imp: PurchaseAmount", xlab = "Purchase Amt", col = "blue", border = "black")
hist(complete_data$PurchaseAmount, main = "After Imp: Purchase Amt", xlab = "Purchase Amt", col = "red", border = "black")
dev.off()

# Satisfaction
png("Satisfaction_comparison.png", width = 800, height = 600)
par(mfrow = c(1, 2))
hist(raw_data$Satisfaction,
    main = "Before Imp: Satisfaction",
    xlab = "Satisfaction",
    col = "blue",
    border = "black"
)
hist(complete_data$Satisfaction,
    main = "After Imp: Satisfaction",
    xlab = "Satisfaction",
    col = "red",
    border = "black"
)
dev.off()

### Bar Plots
png("Gender_comparison.png", width = 800, height = 600)
par(mfrow = c(1, 2))
barplot(table(raw_data$Gender), main = "Before Imp: Gender", col = "blue")
barplot(table(complete_data$Gender), main = "After Imp: Gender", col = "red")
dev.off()

png("Education_comparison.png", width = 800, height = 600)
par(mfrow = c(1, 2))
barplot(table(raw_data$Education), main = "Before Imp: Education", col = "blue")
barplot(table(complete_data$Education), main = "After Imp: Education", col = "red")
dev.off()

# --- SYNTHETIC DATA FUNCTION ---
make_syndata <- function(complete_data, method_vec, n_syn = 100){
    na_data <- raw_data[rep(NA, n_syn), ] 
    combined <- rbind(complete_data, na_data)
    imp_syn_data <- mice(combined, method = method_vec, m = 1, maxit = 1, seed = 123, printFlag = FALSE)
    syn_data <- complete(imp_syn_data, 1)
    syn_data[(nrow(complete_data) + 1):nrow(syn_data), ]
}

synthetic_data <- make_syndata(complete_data, methods, n_syn = 100)
print(tail(synthetic_data, 10))

print(summary(raw_data))
print(summary(synthetic_data))

# --- REGRESSION MODELS ---

# 1. Single Imputation Regression (Original)
complete_regression <- lm(PurchaseAmount ~ Age + Income + Satisfaction + Gender + Education, data = complete_data)
print(summary(complete_regression))

# 2. Pooled Regression (The correct "mice" way for analysis)
pooled_model <- with(imputed_data, lm(PurchaseAmount ~ Age + Income + Satisfaction + Gender + Education))
pooled_results <- pool(pooled_model)
print(summary(pooled_results))

# 3. Synthetic Data Regression (100 samples)
synthetic_regression <- lm(PurchaseAmount ~ Age + Income + Satisfaction + Gender + Education, data = synthetic_data)
print(summary(synthetic_regression))

# 4. Large Synthetic Data Regression (1000 samples)
synthetic1000_data <- make_syndata(complete_data, methods, n_syn = 1000)
synthetic1000_regression <- lm(PurchaseAmount ~ Age + Income + Satisfaction + Gender + Education, data = synthetic1000_data)
print(summary(synthetic1000_regression))

