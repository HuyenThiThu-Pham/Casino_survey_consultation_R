# Project 1

# Load library
library(psych)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(tidyr)

# Load the data 
survey.data <- read.csv("casino_survey_results20130325.csv")
#-----------------------------------------------------
# Inspect the data
head(survey.data)
dim(survey.data)

#### Data Preparation

# Subsetting the data for  Q1_A, Q3_A to Q3_P, Gender 
survey.data_subset <- survey.data %>% dplyr::select(Q1_A, Q3_A:Q3_P, Gender)

# check for missing values
sum(is.na(survey.data_subset))

# Count empty strings and spaces in each column
empty_string_counts <- sapply(survey.data_subset, function(x) sum(x == "" | x == " "| is.na(x)))
empty_string_counts
sum(empty_string_counts)



# Replace missing data (empty strings, spaces, NA) in Q1_A  with "Unsure"
survey.data_subset <- survey.data_subset %>%
  mutate(across(Q1_A, ~ replace(.x, .x == "" | .x == " " | is.na(.x), "Strongly Opposed")))

# Replace missing data (empty strings, spaces, NA) in Gender with "Unsure"
survey.data_subset <- survey.data_subset %>%
  mutate(across(Gender, ~ replace(.x, .x == "" | .x == " " | is.na(.x), "Prefer not to disclose")))


# Replace missing data (empty strings, spaces, NA) in Q3_A to Q3_P with "Unsure"
survey.data_subset <- survey.data_subset %>%
  mutate(across(Q3_A:Q3_P, ~ replace(.x, .x == "" | .x == " " | is.na(.x), "Unsure")))



# Count empty strings and spaces in each column
empty_string_counts <- sapply(survey.data_subset, function(x) sum(x == "" | x == " "| is.na(x)))
empty_string_counts
sum(empty_string_counts)


#-----------------------------------------------------

## factor categorical variables
# Q1_A (general feeling towards casino) 
survey.data_subset$Q1_A <- factor(survey.data_subset$Q1_A, levels = c("Strongly Opposed", "Somewhat Opposed", "Neutral or Mixed Feelings", "Somewhat in Favour", "Strongly in Favour"))

# Q3_A to Q3_P 
ordinal_levels <- c("Not Important At All", "Unsure", "Somewhat Important", "Very Important")
survey.data_subset <- survey.data_subset %>%
  mutate(
    Q3_A = factor(Q3_A, levels = ordinal_levels, ordered = TRUE),
    Q3_B = factor(Q3_B, levels = ordinal_levels, ordered = TRUE),
    Q3_C = factor(Q3_C, levels = ordinal_levels, ordered = TRUE),
    Q3_D = factor(Q3_D, levels = ordinal_levels, ordered = TRUE),
    Q3_E = factor(Q3_E, levels = ordinal_levels, ordered = TRUE),
    Q3_F = factor(Q3_F, levels = ordinal_levels, ordered = TRUE),
    Q3_G = factor(Q3_G, levels = ordinal_levels, ordered = TRUE),
    Q3_H = factor(Q3_H, levels = ordinal_levels, ordered = TRUE),
    Q3_I = factor(Q3_I, levels = ordinal_levels, ordered = TRUE),
    Q3_J = factor(Q3_J, levels = ordinal_levels, ordered = TRUE),
    Q3_K = factor(Q3_K, levels = ordinal_levels, ordered = TRUE),
    Q3_L = factor(Q3_L, levels = ordinal_levels, ordered = TRUE),
    Q3_M = factor(Q3_M, levels = ordinal_levels, ordered = TRUE),
    Q3_N = factor(Q3_N, levels = ordinal_levels, ordered = TRUE),
    Q3_O = factor(Q3_O, levels = ordinal_levels, ordered = TRUE),
    Q3_P = factor(Q3_P, levels = ordinal_levels, ordered = TRUE)
  )


# Gender

survey.data_subset$Gender <- factor(survey.data_subset$Gender, levels = c("Male", "Female", "Prefer not to disclose", "Transgendered"))

describe(survey.data_subset)

#-----------------------------------------------------

# Exploratory Data Analysis (EDA)
summary(survey.data_subset)

# Visualizations:

##### Distribution of the general feeling towards a casino
# calculate percentages
q1_percent <- survey.data_subset %>%
  count(Q1_A) %>%
  mutate(percentages = n/sum(n)*100)

ggplot(q1_percent, aes(x = Q1_A, y = percentages)) + 
  geom_bar(stat = "identity", fill = "skyblue") + 
  geom_text(aes(label = paste(round(percentages, 1), "%")), 
            vjust = -0.5, color = "black") + 
  theme_minimal() + 
  labs(title = "Q1. How you feel about having a new casino in Toronto? (n = 17766)", x = "Feeling", y = "% of Respondents") +
  scale_y_continuous(labels = scales::percent_format(scale = 1))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#-----------------------------------------------------------------------

######  Issue of "Very Important" for each question
q3_data <- survey.data_subset %>%
  select(starts_with("Q3_"))

# Summarize the percentage of "Very Important" for each question
very_important_percent <- q3_data %>%
  summarise(across(everything(), ~ mean(. == "Very Important", na.rm = TRUE) * 100)) %>%
  pivot_longer(cols = everything(), names_to = "Question", values_to = "Percent")

# Mapping the question codes to detailed descriptions
detailed_labels <- c(
  "Q3_A" = "Design of the facility",
  "Q3_B" = "Employment opportunities",
  "Q3_C" = "Entertainment and cultural activities",
  "Q3_D" = "Expanded convention facilities",
  "Q3_E" = "Integration with surrounding areas",
  "Q3_F" = "New hotel accommodations",
  "Q3_G" = "Problem gambling & health concerns",
  "Q3_H" = "Public safety and social concerns",
  "Q3_I" = "Public space",
  "Q3_J" = "Restaurants",
  "Q3_K" = "Retail",
  "Q3_L" = "Revenue for the City",
  "Q3_M" = "Support for local businesses",
  "Q3_N" = "Tourist attraction",
  "Q3_O" = "Traffic concerns",
  "Q3_P" = "Training and career development"
)

# Add detailed descriptions to the data
very_important_percent <- very_important_percent %>%
  mutate(Detailed_Description = recode(Question, !!!detailed_labels)) %>%
  arrange(desc(Percent))  # Sort by percentage

# Plot the percentages of "Very Important" responses using geom_point
ggplot(very_important_percent, aes(y = reorder(Detailed_Description, Percent), x = Percent)) +
  geom_point(size = 2, color = "blue") + 
  labs(
    title = "Issue of 'Very Important' surrounding the New Casino",
    y = "Questions",
    x = "Percentage of 'Very Important' Responses"
  ) +
  theme_minimal() +
  scale_x_continuous(labels = scales::percent_format(scale = 1))



#----------------------------------------------------------------------
#### Prediction: 
library(nnet)
survey.data_select <- survey.data_subset %>%
  select(-Gender)
# survey.data_select
# Fit multinomial logistic regression model
multinom_model <- nnet::multinom(Q1_A ~ Q3_A + Q3_B + Q3_C + Q3_D + Q3_E + Q3_F + 
                             Q3_G + Q3_H + Q3_I + Q3_J + Q3_K + Q3_L + Q3_M + 
                             Q3_N + Q3_O + Q3_P, data = survey.data_select)

summary(multinom_model)


# Predicted probabilities
predicted_probs <- predict(multinom_model, type = "probs")
head(predicted_probs)

# Predicted classes
predicted_classes <- predict(multinom_model, type = "class")
# Confusion Matrix
table(Predicted = predicted_classes, Actual = survey.data_select$Q1_A)

# Visualization : Coefficient heatmap
library(reshape2)    # For reshaping data
# Extract coefficients from the multinomial logistic regression model
coef_data <- summary(multinom_model)$coefficients

# Convert the coefficients to a data frame for plotting
coef_df <- as.data.frame(coef_data)
coef_df$Predictor <- rownames(coef_df)
coef_df_melt <- melt(coef_df, id.vars = "Predictor", variable.name = "Outcome", value.name = "Coefficient")

# Create the heatmap
ggplot(coef_df_melt, aes(x = Predictor, y = Outcome, fill = Coefficient)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0, name = "Coefficient") +
  labs(title = "Heatmap of Multinomial Logistic Regression Coefficients",
       x = "Predictor Variables", y = "Outcome Categories") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


#----------------------------------------------------------------------
#### Apply PCA -reduce the dimensionality
# Load library
library(dplyr)
library(factoextra)


# Convert factors to numeric for all columns
data_numeric <- survey.data_select %>%
  mutate(across(where(is.factor), ~ as.numeric(as.factor(.)))) %>%
  mutate(across(where(is.ordered), ~ as.numeric(as.factor(.))))
head(data_numeric)


df_pca <- data_numeric
head(df_pca)
#### calculate principal components
## Run PCA on the data
survey.pca <- prcomp(data_numeric, scale = TRUE)

# Summarize PCA results
summary(survey.pca)

#### eigen values
survey.pca$sdev^2
 
get_eigenvalue(survey.pca)
#----------------------------------------------------------
### Determine the number of principal components to retain
# Visual test: scree plot to visualize the proportion of variance
screeplot(survey.pca, type = "l", pch = 19, col ='blue', main = "Scree Plot")
# Eigenvalue criterion
# Kaiser’s Criterion
sum(survey.pca$sdev^2 > 1)

# Jolliffe’s Criterion
sum(survey.pca$sdev^2 > 0.7)

## 2
fviz_eig(survey.pca)
# principal component loadings
survey.pca$rotation[, 1:2]

### Choose proceed with 2 components
num_components <- 2

# Extract the first 2 PCA scores from the data
pca_scores <- survey.pca$x[, 1:num_components]

# Create a new dataset combining the variable "Q1_A" and the first two PCA components 
df_pca <- cbind(df_pca[, "Q1_A", drop = FALSE], as.data.frame(pca_scores))

# Display the first few rows of the combined dataset
head(df_pca)


# Fit a linear regression model using selected principal components
fit.pca <- lm(Q1_A ~ PC1 + PC2, data = df_pca) 
# Summary of the regression model
summary(fit.pca)


## run regression analysis on the original data for a comparison
fit.raw <- lm(Q1_A~., data = df_pca)
# get R-squared
summary(fit.raw)$adj.r.squared

#  get AIC for both models 
library(purrr)
list(fit.pca, fit.raw) %>% map_dbl(AIC)


#------------------------------------------------------------------

#### Exploratory Factor Analysis (EFA)
# Load required libraries
library(psych)  # for EFA functions
library(dplyr)  # for data manipulation
library(GPArotation)  # for different rotation methods
library(corrplot)  # for visualizing correlations

# Select columns Q3_A to Q3_P for EFA analysis
efa_data <- data_numeric %>%
  select(starts_with("Q3_"))

# Check the structure to ensure numeric variables
str(efa_data)
dim(efa_data)

#--------------------------
# Cronbach’s alpha
alpha.test <- psych::alpha(efa_data, check.keys=TRUE)

# result is a special class object of list type
names(alpha.test)

# check the results
alpha.test$total
# Value of raw_alpha is 0.906 is desirable. Our data look good.

alpha.test$item.stats$r.cor
# All variables have r.cor greater than 0.3


#-------------------------------------------------------
# Calculate the correlation matrix
survey.cor <- cor(efa_data, use = "pairwise.complete.obs")

corrplot::corrplot(survey.cor, order = "hclust")

### Determinant test
# list of correlations that are greater than 0.8
caret::findCorrelation(survey.cor, cutoff = 0.9, verbose = TRUE, names = TRUE)
# Determinant test. It should be above 0.00001 to pass
det(survey.cor)
# 2.762592e-5 =0.00002762 pass

# Bartlett's Test of Sphericity
bartlett_test <- cortest.bartlett(survey.cor, n=100)
print(bartlett_test)
# P-value is extremely small, the test is statistically significant and we can proceed with EFA as our data are OK.

# KMO Test
kmo_test <- KMO(survey.cor)
print(kmo_test)
# Overall MSA =  0.92
# Each KMO is greater than 0.75, hence everything looks good for EFA
#------------------------------------------------------------------------------

# Make decision on the number of factors - 2 factors

# Run EFA
# number of factors
nf <- 2

# Best method
survey.ml.var <- fa(efa_data, nfactors =nf, rotate = "varimax", fm = "ml")  #  2 factors
print.psych(survey.ml.var, cut = 0.4, sort = TRUE)

# To make a decision, we have to check correlations between factors.
round(survey.ml.var$r.scores, 2)

# ----–----– ----– ----– ----– ----– ----– ----– 
# Examine reliability of factors
#### Reliability check
survey.ml.var$communality  # very high - good

#### Reproduce correlation -  good results
# factors loadings
l <- loadings(survey.ml.var) 
# uniqueness
u2 <- 1 - survey.ml.var$communality
# reproduced correlation
survey.cor.rep <- l %*% t(l) + diag(u2)

# compare original correlation to reproduced
cor.diff <- survey.cor.rep - survey.cor

# proportion of "too large" deviations
sum(abs(cor.diff) > 0.05) / (prod(dim(cor.diff)) - nrow(cor.diff))

#  0.291

#-------------------------------------------------------------------------------
#### Further analysis: 
# Visualisation 

# Distribution of the gender participated
# calculate percentages
gender_percent <- survey.data_subset %>%
  count(Gender) %>%
  mutate(percentages = n/sum(n)*100)


ggplot(gender_percent, aes(x = Gender,y = percentages)) +
  geom_text(aes(label = paste(round(percentages, 1), "%")),
            vjust = -0.5, color = "black") +
  geom_bar(stat = "identity", fill = "skyblue") +
  theme_minimal() +
  labs(title = "Responses by Gender", x = "Gender", y = "% of Respondents")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))





#-------------------------------------------------------------------------------------
# Combine these factors with Gender information from the original data
survey.df <- as.data.frame(survey.ml.var$scores)

names(survey.df) <- c("Economic_And_Development_Opportunities", "Social_And_Public_Concern")
survey.df$Gender <- survey.data_subset$Gender

head(survey.df)
str(survey.df)
unique(survey.df$Gender)

survey.df_filtered <- survey.df[survey.df$Gender %in% c("Male", "Female"), ]

# t-test for Economic_And_Development_Opportunities
t_test_Economic <- t.test(Economic_And_Development_Opportunities ~ Gender, data = survey.df_filtered)
print(t_test_Economic)


# t-test for Social_And_Public_Concern
t_test_Social <- t.test(Social_And_Public_Concern ~ Gender, data = survey.df_filtered)
print(t_test_Social)


