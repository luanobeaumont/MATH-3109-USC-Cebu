library(mice) 

setwd("~/School/MATH-3109/PROBSET-4")

raw_data = read.csv("income.csv")
print(raw_data)
View(raw_data)

raw_data$Gender <- factor(raw_data$Gender, levels=c("Male", "Female"))
raw_data$Education <- factor(raw_data$Education, levels=c("PhD", "Master", "Bachelor", "Highschool"))

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
par(mfrow = c(1, 2))
hist(raw_data$Age, main = "Before Imp: Age", xlab = "Age", col = "blue", border = "black")
hist(complete_data$Age, main = "After Imp: Age", xlab = "Age", col = "red", border = "black")

# Income
par(mfrow = c(1, 2))
hist(raw_data$Income, main = "Before Imp: Income", xlab = "Income", col = "blue", border = "black")
hist(complete_data$Income, main = "After Imp: Income", xlab = "Income", col = "red", border = "black")

# PurchaseAmount
par(mfrow = c(1, 2))
hist(raw_data$PurchaseAmount, main = "Before Imp: PurchaseAmount", xlab = "Purchase Amt", col = "blue", border = "black")
hist(complete_data$PurchaseAmount, main = "After Imp: Purchase Amt", xlab = "Purchase Amt", col = "red", border = "black")

# Satisfaction
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

### Bar Plots
par(mfrow = c(1, 2))
barplot(table(raw_data$Gender), main = "Before Imp: Gender", col = "blue")
barplot(table(complete_data$Gender), main = "After Imp: Gender", col = "red")

par(mfrow = c(1, 2))
barplot(table(raw_data$Education), main = "Before Imp: Education", col = "blue")
barplot(table(complete_data$Education), main = "After Imp: Education", col = "red")

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