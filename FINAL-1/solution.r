library(mice)
library(corrplot)
library(ggplot2)
library(splines)
library(performance)
library(see)
library(ggpubr)

setwd("~/School/MATH-3109/FINAL-1")
raw_data <- read.csv("raw_dataset.csv")
View(raw_data)
head(raw_data)

summary(raw_data)

# Counting zeroes to confirm missingness
as.matrix(colSums(raw_data == 0))

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
head(final_data)

anyNA(final_data)

png("pregnancies_comparison.png", width = 12, height = 9, units = "in", res = 300)
p1 <- gghistogram(raw_data, x = "Pregnancies",
    title = "Original Pregnancies (Raw)",
    xlab = "Pregnancies", ylab = "Count",
    fill = "#b2182b",        
    color = "#b2182b",
    add = "mean", rug = TRUE, add_density = TRUE,
    ggtheme = theme_pubr()
)

p2 <- gghistogram(final_data, x = "Pregnancies",
    title = "Imputed Pregnancies (Complete)",
    xlab = "Pregnancies", ylab = "Count",
    fill = "#2166ac",       
    color = "#2166ac",
    add = "mean", rug = TRUE, add_density = TRUE,
    ggtheme = theme_pubr()
)

ggarrange(p1, p2, ncol = 2, nrow = 1)
dev.off()

png("glucose_comparison.png", width = 12, height = 9, units = "in", res = 300)
p1 <- gghistogram(raw_data, x = "Glucose",
    title = "Original Glucose (Raw)",
    xlab = "Glucose", ylab = "Count",
    fill = "#b2182b",        
    color = "#b2182b",
    add = "mean", rug = TRUE, add_density = TRUE,
    ggtheme = theme_pubr()
)

p2 <- gghistogram(final_data, x = "Glucose",
    title = "Imputed Glucose (Complete)",
    xlab = "Glucose", ylab = "Count",
    fill = "#2166ac",       
    color = "#2166ac",
    add = "mean", rug = TRUE, add_density = TRUE,
    ggtheme = theme_pubr()
)

ggarrange(p1, p2, ncol = 2, nrow = 1)
dev.off()

png("bloodpressure_comparison.png", width = 12, height = 9, units = "in", res = 300)
p1 <- gghistogram(raw_data, x = "BloodPressure",
    title = "Original BloodPressure (Raw)",
    xlab = "BloodPressurlinear_simple <- lm(Insulin ~ Glucose + BMI + Age, data = final_data)
summary(linear_simple)

linear_spline <- lm (Insulin ~ Glucose + BMI + bs(Age, degree = 3), data = final_data)
summary(linear_spline)

## Compare
anova(linear_simple, linear_spline)e", ylab = "Count",
    fill = "#b2182b",        
    color = "#b2182b",
    add = "mean", rug = TRUE, add_density = TRUE,
    ggtheme = theme_pubr()
)

p2 <- gghistogram(final_data, x = "BloodPressure",
    title = "Imputed BloodPressure (Complete)",
    xlab = "BloodPressure", ylab = "Count",
    fill = "#2166ac",       
    color = "#2166ac",
    add = "mean", rug = TRUE, add_density = TRUE,
    ggtheme = theme_pubr()
)

ggarrange(p1, p2, ncol = 2, nrow = 1)
dev.off()

png("skinthickness_comparison.png", width = 12, height = 9, units = "in", res = 300)
p1 <- gghistogram(raw_data, x = "SkinThickness",
    title = "Original SkinThickness (Raw)",
    xlab = "SkinThickness", ylab = "Count",
    fill = "#b2182b",        
    color = "#b2182b",
    add = "mean", rug = TRUE, add_density = TRUE,
    ggtheme = theme_pubr()
)

p2 <- gghistogram(final_data, x = "SkinThickness",
    title = "Imputed SkinThickness (Complete)",
    xlab = "SkinThickness", ylab = "Count",
    fill = "#2166ac",       
    color = "#2166ac",
    add = "mean", rug = TRUE, add_density = TRUE,
    ggtheme = theme_pubr()
)

ggarrange(p1, p2, ncol = 2, nrow = 1)
dev.off()

png("insulin_comparison.png", width = 12, height = 9, units = "in", res = 300)
p1 <- gghistogram(raw_data, x = "Insulin",
    title = "Original Insulin (Raw)",
    xlab = "Insulin", ylab = "Count",
    fill = "#b2182b",        
    color = "#b2182b",
    add = "mean", rug = TRUE, add_density = TRUE,
    ggtheme = theme_pubr()
)

p2 <- gghistogram(final_data, x = "Insulin",
    title = "Imputed Insulin (Complete)",
    xlab = "Insulin", ylab = "Count",
    fill = "#2166ac",       
    color = "#2166ac",
    add = "mean", rug = TRUE, add_density = TRUE,
    ggtheme = theme_pubr()
)

ggarrange(p1, p2, ncol = 2, nrow = 1)
dev.off()

png("bmi_comparison.png", width = 12, height = 9, units = "in", res = 300)
p1 <- gghistogram(raw_data, x = "BMI",
    title = "Original BMI (Raw)",
    xlab = "BMI", ylab = "Count",
    fill = "#b2182b",        
    color = "#b2182b",
    add = "mean", rug = TRUE, add_density = TRUE,
    ggtheme = theme_pubr()
)

p2 <- gghistogram(final_data, x = "BMI",
    title = "Imputed BMI (Complete)",
    xlab = "BMI", ylab = "Count",
    fill = "#2166ac",       
    color = "#2166ac",
    add = "mean", rug = TRUE, add_density = TRUE,
    ggtheme = theme_pubr()
)

ggarrange(p1, p2, ncol = 2, nrow = 1)
dev.off()

## Correlations

png("correlation.png", width = 12, height = 9, units = "in", res = 300)
cor_matrix <- cor(final_data, use = "complete.obs")
corrplot(cor_matrix, method = "circle", type = "upper", order = "hclust",
        tl.col = "black", tl.srt = 45, title = "Correlations", mar=c(0,0,1,0))
dev.off()

png("linearity.png", width = 12, height = 9, units = "in", res = 300)
ggplot(final_data, aes(x = Age, y = Insulin)) +
  geom_point(color = "#b2182b", alpha = 0.6, size = 2) +
  geom_smooth(method = "lm", 
              formula = y ~ bs(x, degree = 3), 
              color = "#2166ac",   
              fill = "#2166ac",      
              alpha = 0.2,           
              size = 1.5) +          

  labs(title = "B-Spline",
       subtitle = "Non-Linear Relationship between Age and Insulin",
       x = "Age (Years)",
       y = "Insulin Level (mu U/ml)") +
  
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 18),
    plot.subtitle = element_text(hjust = 0.5, color = "gray30", size = 14),
    axis.title = element_text(face = "bold", size = 14),
    axis.text = element_text(size = 12))
dev.off()

## Do B-Spline if relationship is non-linear


### Logistic Regression 
set.seed(123)
sample_index <- sample(1:nrow(final_data), 0.8 * nrow(final_data))
train_data <- final_data[sample_index, ]
test_data <- final_data[-sample_index, ]

log_model <- glm(Outcome ~ Glucose + BMI + Age + Pregnancies + DiabetesPedigreeFunction,
                data = train_data, family= "binomial")

summary(log_model)

## By a unit of increase in var, odds of diabetes increase by X
exp(coef(log_model))


## Linear regression
linear_simple <- lm(Insulin ~ Glucose + BMI + Age, data = final_data)
summary(linear_simple)

linear_spline <- lm (Insulin ~ Glucose + BMI + bs(Age, degree = 3), data = final_data)
summary(linear_spline)

## Compare
anova(linear_simple, linear_spline)

# Check residuals
image_rend <- check_model(linear_spline)
png("splien_model.png", width = 12, height = 9, units = "in", res = 300)
print(image_rend)
dev.off()
