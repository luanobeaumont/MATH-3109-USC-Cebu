library(mice)
library(corrplot)
library(ggplot2)
library(splines)

setwd("~/School/MATH-3109/FINAL-1")
raw_data <- read.csv("raw_dataset.csv")
View(raw_data)
raw_data

summary(raw_data)

# Counting zeroes to confirm missingness
colSums(raw_data == 0)


# Converting Zeroes to NA
col_w_zeroes <- c("Pregnancies", "Glucose", "BloodPressure", "SkinThickness", "Insulin", "BMI")
raw_data[col_w_zeroes] <- lapply(raw_data[col_w_zeroes], function(x) ifelse(x == 0, NA, x))

# Verify showing NA to said zero-valued cells
summary(raw_data)

# Imputation Process
init <- mice(raw_data, maxit = 0)
methods <- init$method

methods[col_w_zeroes] <- "pmm"

imputed_data <- mice(raw_data, method = methods, m = 5, maxit = 5, seed = 123)

final_data <- complete(imputed_data, 1)

anyNA(final_data)

par(mfrow = c(1, 2))
hist(raw_data$Pregnancies, main="Original Pregnancies", col="blue", xlab="Pregnancies")
hist(final_data$Pregnancies, main="Imputed Pregnancies", col="red", xlab="Pregnancies")

par(mfrow = c(1, 2))
hist(raw_data$Glucose, main="Original Glucose", col="blue", xlab="Glucose")
hist(final_data$Glucose, main="Imputed Glucose", col="red", xlab="Glucose")

par(mfrow = c(1, 2))
hist(raw_data$BloodPressure, main="Original BloodPressure", col="blue", xlab="BloodPressure")
hist(final_data$BloodPressure, main="Imputed BloodPressure", col="red", xlab="BloodPressure")

par(mfrow = c(1, 2))
hist(raw_data$SkinThickness, main="Original SkinThickness", col="blue", xlab="SkinThickness")
hist(final_data$SkinThickness, main="Imputed SkinThickness", col="red", xlab="SkinThickness")

par(mfrow = c(1, 2))
hist(raw_data$Insulin, main="Original Insulin", col="blue", xlab="Insulin")
hist(final_data$Insulin, main="Imputed Insulin", col="red", xlab="Insulin")

par(mfrow = c(1, 2))
hist(raw_data$BMI, main="Original BMI", col="blue", xlab="BMI")
hist(final_data$BMI, main="Imputed BMI", col="red", xlab="BMI")


### Correlations

cor_matrix <- cor(final_data, use = "complete.obs")
corrplot(cor_matrix, method = "circle", type = "upper", order = "hclust",
        tl.col = "black", tl.srt = 45, title = "Correlations", mar=c(0,0,1,0))

ggplot(final_data, aes(x=Age, y=Insulin)) + 
    geom_point(alpha=0.5) + 
    geom_smooth(method="loess", col="red") + 
    labs(title="Relationship between Age and Insulin", substitle="Check non-linearity")


### Do B-Spline if relationship is non-linear

### Logistic Regression 
set.seed(123)
sample_index <- sample(1:nrow(final_data), 0.8 * nrow(final_data))
train_data <- final_data[sample_index, ]
test_data <- final_data[-sample_index, ]

log_model <- glm(Outcome ~ Glucose + BMI + Age + Pregnancies + DiabetesPedigreeFunction,
                data = train_data, family= "binomial")

summary(log_model)

### By a unit of increase in var, odds of diabetes increase by X
exp(coef(log_model))


### Linear regression
linear_simple <- lm(Insulin ~ Glucose + BMI + Age, data = final_data)

linear_spline <- lm (Insulin ~ Glucose + BMI + bs(Age, degree = 3), data = final_data)

## Compare
anova(linear_simple, linear_spline)

## Check residuals
par(mfrow=c(2, 2))
plot(linear_spline)