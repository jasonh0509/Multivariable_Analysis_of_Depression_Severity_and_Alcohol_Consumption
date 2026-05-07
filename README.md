# NHIS Depression Severity and Alcohol Consumption Analysis

## Project Overview
This project investigates the association between depression severity and alcohol consumption frequency among U.S. adults using nationally representative National Health Interview Survey (NHIS) data (2010–2019) accessed through the IPUMS Health Surveys platform. Using survey-informed epidemiologic methods, this study evaluates how alcohol consumption patterns relate to depression severity after adjusting for demographic, behavioral, socioeconomic, and structural determinants.

## Research Objective
To assess the relationship between depression severity and alcohol consumption frequency among U.S. adults aged 18–85 while accounting for a broad causal framework of potential confounders, including:
- Age  
- Sex  
- Race/Ethnicity  
- Hours of sleep  
- Socioeconomic status (SES)  
- Employment status  
- Health insurance status  

## Study Design
- Cross-sectional observational study  
- NHIS (2010–2019) survey data via IPUMS  
- Nationally representative U.S. adult sample  
- Binary logistic regression  
- Directed Acyclic Graph (DAG)-informed confounder selection  
- Sensitivity analyses for SES, employment status, and missingness structure  
- R-based visualization of odds ratio trends across alcohol consumption categories  

## Causal Framework
A Directed Acyclic Graph (DAG) was used to guide confounder identification and model specification by explicitly mapping hypothesized relationships among:
- Alcohol consumption frequency (exposure)  
- Depression severity (outcome)  
- SES  
- Employment  
- Insurance  
- Sleep  
- Demographic variables  

This framework strengthened analytical transparency and supported more defensible variable adjustment strategies.

## Methods
This project used:
### SAS for:
- Cohort construction  
- NHIS multi-year harmonization  
- Variable derivation and recoding  
- Logistic regression modeling  
- Sensitivity analyses  

### R for:
- Odds ratio trend visualization  
- Comparative model interpretation  
- Graphical presentation of association patterns  

## Key Findings
- A checkmark-shaped association was observed between alcohol consumption frequency and depression severity after multivariable adjustment.  
- Moderate alcohol consumption frequency was associated with lower odds of severe depression relative to several other drinking categories.  
- Frequent and daily alcohol consumption were associated with elevated odds of severe depression.  
- Inclusion of SES and employment status altered observed association patterns, suggesting meaningful confounding influence.  
- Sensitivity analyses demonstrated that missingness related to SES and employment had limited impact on broader trend direction but affected magnitude and interpretability.  

## Interpretation
Findings suggest that the relationship between alcohol use and depression severity may be non-linear and shaped by broader social determinants of health. DAG-guided adjustment and sensitivity analyses highlighted the importance of structural and socioeconomic variables when interpreting behavioral health associations.

## Limitations
- Cross-sectional design limits causal inference  
- Depression severity derived from available NHIS measures rather than standardized PHQ-9 across all years  
- Variable recoding may reduce information granularity  
- Observational findings should not be interpreted causally  
- Residual confounding remains possible  

## Tools
- SAS (DATA Step, PROC SQL, Logistic Regression)
- R (ggplot2)
- DAG-based causal reasoning
- NHIS / IPUMS Health Surveys
- Survey Data Harmonization
- Sensitivity Analysis
- Git/GitHub

## Key Deliverables
- Full Technical Report (`report/Alzheimers-Disease-Predictive Modeling Report.pdf`)
- Raw SAS Code (`scripts/Multivariable_Analysis_of_Depression_Severity_and_Alcohol_Consumption.sas`)
- DAG Framework Documentation
- R Visualization Scripts

## Notes
This project originated from graduate biostatistical training and has been organized into a reproducible portfolio project emphasizing survey data analysis, causal reasoning, public health interpretation, and multivariable epidemiologic methods.