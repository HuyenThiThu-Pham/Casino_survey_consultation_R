# Public Sentiment Analysis on a Proposed Casino in Toronto

This project analyzes public sentiment toward a proposed casino in Toronto using survey data collected by the City of Toronto. The goal is to predict overall attitudes and uncover the key factors driving public opinion, using statistical and machine learning techniques.


## Problem Statement
### Situation

The City of Toronto is considering the development of a new casino and conducted a comprehensive public survey to understand residents' views. With over 17,000 responses and 92 variables, the city aims to use this data to support evidence-based urban planning and policy decisions.


### 🎯 Task  
This project addresses the following objectives:
- Predict respondents’ **general feeling toward the proposed casino** (variable `Q1_A`) based on their concerns (variables `Q3_A` to `Q3_P`).
- Apply **multinomial logistic regression** and **Principal Component Analysis (PCA)** to assess model performance and improve interpretability.
- Conduct **Exploratory Factor Analysis (EFA)** to identify latent factors behind public attitudes.
- Analyze whether **gender and age** influence these opinions.

### 🛠️ Why This Matters  
Public projects like casinos generate polarized views due to potential social, economic, and environmental impacts. Accurately interpreting public sentiment:
- Guides policymakers in **balancing economic development with public concerns**.
- Helps develop **targeted communication strategies** addressing major issues (e.g., safety, addiction, urban aesthetics).
- Provides a **reusable analytics framework** for other community consultations or market research.

---

## 📊 Data Source

- **Dataset**: `casino_survey_results20130325.csv`  
- **Documentation**: `casino_survey_readme.xlsx` (survey question metadata)

### 🎯 Target Variable
**Q1_A** – *How do you feel about having a new casino in Toronto?*  
Responses (5-point scale):
1. Strongly in Favour  
2. Somewhat in Favour  
3. Neutral or Mixed Feelings  
4. Somewhat Opposed  
5. Strongly Opposed

### 🎯 Predictor Variables
**Q3_A to Q3_P** – Importance of 16 factors related to the casino (4-point scale):  
1. Very Important  
2. Somewhat Important  
3. Not Important At All  
4. Unsure  

Factors include:  
- Design of the facility (`Q3_A`)  
- Employment opportunities (`Q3_B`)  
- Entertainment & cultural activities (`Q3_C`)  
- Convention facilities (`Q3_D`)  
- Integration with surrounding areas (`Q3_E`)  
- Hotel accommodations (`Q3_F`)  
- Problem gambling & health concerns (`Q3_G`)  
- Public safety & social concerns (`Q3_H`)  
- Public space (`Q3_I`), Restaurants (`Q3_J`), Retail (`Q3_K`)  
- Revenue for the city (`Q3_L`)  
- Support for local businesses (`Q3_M`)  
- Tourist attraction (`Q3_N`)  
- Traffic concerns (`Q3_O`)  
- Training & career development (`Q3_P`)

### 👤 Covariates
- Gender  
- Age (binned; missing values replaced with “Prefer not to disclose”)

### 🧹 Data Cleaning & Imputation
- Missing values for `Q1_A` were imputed with the most frequent response: **Strongly Opposed**
- Missing values in Q3 responses were replaced with **"Unsure"**
- Removed free-text and irrelevant demographic fields:  
  `Q1_B1` to `Q1_B3`, `Q2_A/B`, `Q3_Comments`, `Q4_A` to `Q10`, `PostalCode`, `GroupName`, `DateCreated`

---
## 🔍 Methodology

### 1. Data Preparation
- Selected relevant columns (Q1_A, Q3_A–Q3_P, Gender, Age)
- Re-coded categorical variables as factors
- Handled missing values and ensured appropriate factor levels

### 2. Data Exploration
- Visualized Q1_A to understand sentiment distribution
- Explored Q3 responses to identify most cited concerns
- Disaggregated responses by gender to examine differences

### 3. Predictive Modeling
- Used **Multinomial Logistic Regression** to predict Q1_A based on Q3 concerns
- Encoded ordinal target as a factor
- Evaluated performance by accuracy and class-wise prediction quality

### 4. Dimensionality Reduction with PCA
- Applied PCA to Q3_A to Q3_P responses
- Selected optimal number of components (e.g., via scree plot)
- Re-ran logistic regression using PCA components as inputs

### 5. Exploratory Factor Analysis (EFA)
- Tried multiple factor extraction methods (e.g., principal axis, maximum likelihood)
- Chose the best model based on interpretability and fit indices
- Interpreted two key latent factors:
  - **Economic Development & Infrastructure**
  - **Social Concerns & Public Safety**

- Investigated how these factors varied by Gender and Age

---

## ✅ Results (STAR Summary)

**Situation**: Toronto sought to gauge public opinion on building a casino, a decision with economic and social implications.  
**Task**: Predict overall sentiment toward the casino and discover key driving factors behind public attitudes.  
**Actions**:  
- Cleaned and recoded survey data  
- Built predictive models using multinomial logistic regression and PCA  
- Conducted EFA to interpret latent opinion factors  
- Analyzed demographic variations in perception  

**Results**:  
- A majority of respondents were **strongly opposed** (66.2%) to the casino  
- PCA-based model showed similar performance but better interpretability  
- EFA revealed that:
  - **Males prioritized economic opportunities**
  - **Females focused on social and safety concerns**  
- These insights inform policy communication and highlight trade-offs needing careful management

---

### Tools & Libraries

- R

- tidyverse for data manipulation and visualization

- nnet for multinomial logistic regression

- psych for EFA

- FactoMineR and factoextra for PCA analysis

### Author

Huyen

### License

This project is for academic purposes only.
