# Global Happiness Solutions (GHS)

## Mission Statement:

Welcome to the Global Happiness Solutions (GHS) project. This repository contains the essential code and data to analyze global happiness metrics and derive insights aimed at improving national happiness scores. It includes scripts and data for importing World Happiness Report information into a MySQL database, featuring various happiness indicators from multiple countries over several years.

Our mission extends to enhancing employee happiness and well-being through data-driven strategies that improve workplace culture, economic stability, social support, health, and personal freedom within companies. By focusing on these areas, we help businesses boost employee happiness and well-being, leading to improved productivity, higher employee retention, and better overall company performance.

## Table of Contents

- [Introduction](#introduction)
- [Data Sources](#sources)
- [Schema](#schema)
- [Installation](#installation)
- [Data Preparation](#preparation)
- [Data Cleaning](#cleaning)
- [Hypotheses](#hypotheses)
- [Results](#results)
- [Conclusion](#conclusion)

## Introduction

The World Happiness Report is a landmark survey of the state of global happiness. This project aims to import this data into a MySQL database for further analysis and visualization.

## Data Sources
World Happiness Report 2021 [https://www.kaggle.com/datasets/joebeachcapital/world-happiness-report-2013-2023/data]

World Happiness Report 2023 [https://www.kaggle.com/datasets/joebeachcapital/world-happiness-report-2013-2023/data]

## Schema

### `countries` Table

| Column | Type | Description |
| ------ | ---- | ----------- |
| id | INT | Primary key, unique identifier for each country |
| name | VARCHAR(50) | Name of the country |

### `happiness_indicators` Table

| Column | Type | Description |
| ------ | ---- | ----------- |
| country_id | INT | Foreign key referencing `countries(id)` |
| logged_gdp_per_capita | DECIMAL(10, 3) | GDP per capita (logged) |
| social_support | DECIMAL(10, 3) | Social support index |
| freedom_to_choose | DECIMAL(10, 3) | Freedom to make life choices |
| ladder_score | DECIMAL(10, 3) | Happiness score (ladder score) |
| year | INT | Year of the data |

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/world-happiness-data-import.git
    ```

2. Navigate to the project directory:
    ```bash
    cd world-happiness-data-import
    ```

3. Install the required Python packages:
    ```bash
    pip install pandas sqlalchemy pymysql
    pip install mysql-connector-python
    ```

4. Prepare your MySQL database and update the connection details in the script.

## Data Preparation

Convert the two csv files into dataframes:

df21 = pd.read_csv("../Raw Data/world_happiness_report_2021.csv")

df23 = pd.read_csv("../Raw Data/world_happiness_report_2023.csv")

## Data Cleaning

This process involves merging datasets from different years, adding necessary columns, removing redundant ones, and creating unique identifiers for countries. This ensures the data is in a consistent and usable format for analysis.

## Hypotheses

### 1. Freedom to Choose and Happiness
- **Hypothesis**: Greater personal freedom and lower levels of corruption are associated with higher happiness scores.
- **Rationale**: Freedom to make life choices and live without oppression or corruption can significantly impact personal satisfaction and happiness.
- **Definition**: Are you satisfied or dissatisfied with your freedom to choose what you do with your life?”

### 2. Social Factors
- **Hypothesis**: Countries with high social support and strong community ties show consistently high happiness scores.
- **Rationale**: Stronger connection with family and community enhance emotional well-being.
- **Definition**: If you were in trouble, do you have relatives or friends you can count on to help you whenever you need them, or not?”

### 3. Economic / GDP Factors
- **Hypothesis**: Countries with higher GDP per capita have higher happiness scores.
- **Rationale**: Economic stability provides better living conditions, education, and healthcare which contribute to overall higher levels of happiness.
- **Definition**: Is in terms of Purchasing Power Parity.


## Results 

### 1. Freedom to Choose and Happiness
In 2021, the correlation between freedom to make life choices and happiness was 0.61, increasing to 0.66 in 2023. The higher correlation in 2023 suggests a stronger association between personal freedom and overall happiness, potentially due to post-pandemic recovery. During 2021, COVID-19 restrictions significantly limited personal freedoms, reflecting the lower correlation. 
![Freedom to Make Life Choices 2021](https://github.com/michelle30303/World_happiness/blob/main/images/freedom_correlation_top_bottom_21.png)
![Freedom to Make Life Choices 2023](https://github.com/michelle30303/World_happiness/blob/main/images/freedom_correlation_top_bottom_23.png)

Top-ranking countries like Finland (7.842 happiness, 0.949 freedom) and Denmark (7.620 happiness, 0.946 freedom) consistently scored high in both years. Conversely, countries like Afghanistan (2.523 happiness, 0.382 freedom) and Zimbabwe (3.145 happiness, 0.677 freedom) remained at the bottom, highlighting the critical role of freedom in influencing happiness.
![Top and Bottom Ranting 2021](https://github.com/michelle30303/World_happiness/blob/main/images/freedom_21.png)
![Top and Bottom Ranting 2023](https://github.com/michelle30303/World_happiness/blob/main/images/freedom_23.png)

### 2. Social Factors
The correlation between social support and happiness increased from 0.76 in 2021 to 0.83 in 2023. This stronger relationship in 2023 underscores the importance of having reliable social networks, especially as countries recover from the pandemic. 
![Social Factors 2021](https://github.com/michelle30303/World_happiness/blob/main/images/social_correlation_top_bottom_21.png)
![Social Factors 2023](https://github.com/michelle30303/World_happiness/blob/main/images/social_correlation_top_bottom_23.png)

Finland (7.842 happiness, 0.954 social support) and Iceland (7.554 happiness, 0.983 social support) exemplify high happiness levels linked to robust social support systems. In contrast, countries like Afghanistan (2.523 happiness, 0.463 social support) and Burundi (3.775 happiness, 0.490 social support) demonstrate lower happiness levels, reflecting weaker social networks.
![Top and Bottom Ranting 2021](https://github.com/michelle30303/World_happiness/blob/main/images/social_21.png)
![Top and Bottom Ranting 2023](https://github.com/michelle30303/World_happiness/blob/main/images/social_23.png)

### 3. Economic / GDP Factors
Economic factors, measured as GDP per capita (PPP), showed a correlation of 0.79 with happiness in 2021 and slightly decreased to 0.78 in 2023. Despite the small decrease, the strong correlation indicates the significant impact of economic stability on happiness. 
![GDP 2021](https://github.com/michelle30303/World_happiness/blob/main/images/gdp_correlation_top_bottom_21.png)
![GDP 2023](https://github.com/michelle30303/World_happiness/blob/main/images/gdp_correlation_top_bottom_23.png)

High-GDP countries like Luxembourg (7.324 happiness, 11.647 GDP) and Switzerland (7.571 happiness, 11.117 GDP) remained among the happiest. Conversely, economically struggling nations such as Afghanistan (2.523 happiness, 7.695 GDP) and Malawi (3.600 happiness, 6.958 GDP) had lower happiness levels, underscoring the crucial role of economic wellbeing in shaping happiness.
![Top and Bottom Ranting 2021](https://github.com/michelle30303/World_happiness/blob/main/images/gdp_21.png)
![Top and Bottom Ranting 2023](https://github.com/michelle30303/World_happiness/blob/main/images/gdp_23.png)

### Services:
- Data Analysis: Analyzing happiness data to identify key factors affecting national happiness.
- Policy Recommendations: Providing governments with actionable recommendations to improve happiness scores.
- Training and Workshops: Offering training programs for policymakers on promoting happiness and well-being.
- Monitoring and Evaluation: Continuous monitoring and evaluation of implemented policies to measure their impact on happiness.

### Target Clients:
- National and local governments
- International organizations
- NGOs focused on social development
- Corporate clients interested in employee well-being programs


## Conclusions

By leveraging the insights and tools provided by the GHS project, nations and businesses alike can identify key factors influencing happiness and implement targeted strategies to foster well-being. This dual approach not only enhances individual quality of life but also contributes to broader societal and economic benefits, creating a more prosperous and content global community.

Link to the presentation https://www.canva.com/design/DAGLVs99CUs/3DM2qWIm7NTGSw2-LNgIXA/view?utm_content=DAGLVs99CUs&utm_campaign=designshare&utm_medium=link&utm_source=editor

