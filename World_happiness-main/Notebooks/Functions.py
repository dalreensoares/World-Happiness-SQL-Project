import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sqlalchemy import create_engine

def load_data(file_path_2021, file_path_2023):
    df21 = pd.read_csv(file_path_2021)
    df23 = pd.read_csv(file_path_2023)

    df21['Year'] = 2021
    df23['Year'] = 2023

    df21.drop(columns=['Regional indicator'], inplace=True)
    
    merged_df = pd.concat([df21, df23])
    
    list_of_columns = ["Country name", "Ladder score", "Logged GDP per capita", "Social support", "Freedom to make life choices", "Year"]
    filtered_columns_df = merged_df[list_of_columns]
    
    return filtered_columns_df

def create_country_id_map(filtered_columns_df):
    unique_countries = filtered_columns_df['Country name'].unique()
    country_ids = {country: idx for idx, country in enumerate(unique_countries, start=1)}
    return country_ids

def map_country_ids(filtered_columns_df, country_ids):
    country_df = pd.DataFrame(list(country_ids.items()), columns=['Country', 'ID'])
    filtered_columns_df['Country_ID'] = filtered_columns_df['Country name'].map(country_ids) 
    filtered_columns_df.drop('Country name', axis=1, inplace=True)
    return filtered_columns_df, country_df

def save_cleaned_data(filtered_columns_df, country_df, file_path_happiness, file_path_countries):
    filtered_columns_df.to_csv(file_path_happiness, index=False)
    country_df.to_csv(file_path_countries, index=False)

def execute_query(engine, query):
    return pd.read_sql(query, con=engine)

def plot_top_bottom_10(df, title, color_top, color_bottom):
    top_10 = df[df['category'] == 'Top 10']
    bottom_10 = df[df['category'] == 'Bottom 10']

    plt.figure(figsize=(10, 6))
    plt.bar(top_10['country_name'], top_10['ladder_score'], color=color_top, label='Top 10')
    plt.bar(bottom_10['country_name'], bottom_10['ladder_score'], color=color_bottom, label='Bottom 10')
    plt.xlabel('Country')
    plt.ylabel('Ladder Score')
    plt.title(title)
    plt.xticks(rotation=90)
    plt.legend()
    plt.tight_layout()
    plt.show()

def main():
    file_path_2021 = "../Raw Data/world_happiness_report_2021.csv"
    file_path_2023 = "../Raw Data/world_happiness_report_2023.csv"
    file_path_happiness = "../cleaned data/happiness_indicators.csv"
    file_path_countries = "../cleaned data/countries.csv"

    filtered_columns_df = load_data(file_path_2021, file_path_2023)
    country_ids = create_country_id_map(filtered_columns_df)
    filtered_columns_df, country_df = map_country_ids(filtered_columns_df, country_ids)
    
    save_cleaned_data(filtered_columns_df, country_df, file_path_happiness, file_path_countries)

    engine = create_engine('sqlite:///happiness.db')  # Adjust the engine creation based on your database

    freedom_to_choose_correlation_21_query = """
    WITH stats AS (
        SELECT 
            COUNT(*) AS n,
            SUM(freedom_to_choose) AS sum_x,
            SUM(ladder_score) AS sum_y,
            SUM(freedom_to_choose * ladder_score) AS sum_xy,
            SUM(freedom_to_choose * freedom_to_choose) AS sum_x2,
            SUM(ladder_score * ladder_score) AS sum_y2
        FROM 
            happiness_indicators
        WHERE 
            year = 2021
    )
    SELECT 
        (n * sum_xy - sum_x * sum_y) / 
        SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y)) AS correlation
    FROM 
        stats;
    """
    freedom_to_choose_correlation_21 = execute_query(engine, freedom_to_choose_correlation_21_query)
    print(freedom_to_choose_correlation_21)

    freedom_to_choose_correlation_23_query = """
    WITH stats AS (
        SELECT 
            COUNT(*) AS n,
            SUM(freedom_to_choose) AS sum_x,
            SUM(ladder_score) AS sum_y,
            SUM(freedom_to_choose * ladder_score) AS sum_xy,
            SUM(freedom_to_choose * freedom_to_choose) AS sum_x2,
            SUM(ladder_score * ladder_score) AS sum_y2
        FROM 
            happiness_indicators
        WHERE 
            year = 2023
    )
    SELECT 
        (n * sum_xy - sum_x * sum_y) / 
        SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y)) AS correlation
    FROM 
        stats;
    """
    freedom_to_choose_correlation_23 = execute_query(engine, freedom_to_choose_correlation_23_query)
    print(freedom_to_choose_correlation_23)

    freedom_to_choose_top_bottom_10_21_query = """
    (SELECT 
        'Top 10' AS category, 
        c.name AS country_name, 
        hi.ladder_score, 
        hi.freedom_to_choose
    FROM 
        happiness_indicators hi
    JOIN 
        countries c ON hi.country_id = c.id
    WHERE 
        hi.year = 2021
    ORDER BY 
        hi.ladder_score DESC
    LIMIT 10)
    UNION ALL
    (SELECT 
        'Bottom 10' AS category, 
        c.name AS country_name, 
        hi.ladder_score, 
        hi.freedom_to_choose
    FROM 
        happiness_indicators hi
    JOIN 
        countries c ON hi.country_id = c.id
    WHERE 
        hi.year = 2021
    ORDER BY 
        hi.ladder_score ASC
    LIMIT 10);
    """
    freedom_to_choose_top_bottom_10_21 = execute_query(engine, freedom_to_choose_top_bottom_10_21_query)
    plot_top_bottom_10(freedom_to_choose_top_bottom_10_21, 'Top and Bottom 10 Countries by Ladder Score in 2021', 'darkgrey', 'coral')

    freedom_to_choose_top_bottom_10_23_query = """
    (SELECT 
        'Top 10' AS category, 
        c.name AS country_name, 
        hi.ladder_score,  
        hi.freedom_to_choose
    FROM 
        happiness_indicators hi
    JOIN 
        countries c ON hi.country_id = c.id
    WHERE 
        hi.year = 2023
    ORDER BY 
        hi.ladder_score DESC
    LIMIT 10)
    UNION ALL
    (SELECT 
        'Bottom 10' AS category, 
        c.name AS country_name, 
        hi.ladder_score, 
        hi.freedom_to_choose
    FROM 
        happiness_indicators hi
    JOIN 
        countries c ON hi.country_id = c.id
    WHERE 
        hi.year = 2023
    ORDER BY 
        hi.ladder_score ASC
    LIMIT 10);
    """
    freedom_to_choose_top_bottom_10_23 = execute_query(engine, freedom_to_choose_top_bottom_10_23_query)
    plot_top_bottom_10(freedom_to_choose_top_bottom_10_23, 'Top and Bottom 10 Countries by Ladder Score in 2023', 'darkgrey', 'coral')

    social_support_correlation_21_query = """
    WITH stats AS (
        SELECT 
            COUNT(*) AS n,
            SUM(social_support) AS sum_x,
            SUM(ladder_score) AS sum_y,
            SUM(social_support * ladder_score) AS sum_xy,
            SUM(social_support * social_support) AS sum_x2,
            SUM(ladder_score * ladder_score) AS sum_y2
        FROM 
            happiness_indicators
        WHERE 
            year = 2021
    )
    SELECT 
        (n * sum_xy - sum_x * sum_y) / 
        SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y)) AS correlation
    FROM 
        stats;
    """
    social_support_correlation_21 = execute_query(engine, social_support_correlation_21_query)
    print(social_support_correlation_21)

    social_support_correlation_23_query = """
    WITH stats AS (
        SELECT 
            COUNT(*) AS n,
            SUM(social_support) AS sum_x,
            SUM(ladder_score) AS sum_y,
            SUM(social_support * ladder_score) AS sum_xy,
            SUM(social_support * social_support) AS sum_x2,
            SUM(ladder_score * ladder_score) AS sum_y2
        FROM 
            happiness_indicators
        WHERE 
            year = 2023
    )
    SELECT 
        (n * sum_xy - sum_x * sum_y) / 
        SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y)) AS correlation
    FROM 
        stats;
    """
    social_support_correlation_23 = execute_query(engine, social_support_correlation_23_query)
    print(social_support_correlation_23)

    social_support_top_bottom_10_21_query = """
    (SELECT 
        'Top 10' AS category, 
        c.name AS country_name, 
        hi.ladder_score, 
        hi.social_support
    FROM 
        happiness_indicators hi
    JOIN 
        countries c ON hi.country_id = c.id
    WHERE 
        hi.year = 2021
    ORDER BY 
        hi.ladder_score DESC
    LIMIT 10)
    UNION ALL
    (SELECT 
        'Bottom 10' AS category, 
        c.name AS country_name, 
        hi.ladder_score, 
        hi.social_support
    FROM 
        happiness_indicators hi
    JOIN 
        countries c ON hi.country_id = c.id
    WHERE 
        hi.year = 2021
    ORDER BY 
        hi.ladder_score ASC
    LIMIT 10);
    """
    social_support_top_bottom_10_21 = execute_query(engine, social_support_top_bottom_10_21_query)
    plot_top_bottom_10(social_support_top_bottom_10_21, 'Top and Bottom 10 Countries by Ladder Score in 2021', 'darkgrey', 'coral')

    social_support_top_bottom_10_23_query = """
    (SELECT 
        'Top 10' AS category, 
        c.name AS country_name, 
        hi.ladder_score,  
        hi.social_support
    FROM 
        happiness_indicators hi
    JOIN 
        countries c ON hi.country_id = c.id
    WHERE 
        hi.year = 2023
    ORDER BY 
        hi.ladder_score DESC
    LIMIT 10)
    UNION ALL
    (SELECT 
        'Bottom 10' AS category, 
        c.name AS country_name, 
        hi.ladder_score, 
        hi.social_support
    FROM 
        happiness_indicators hi
    JOIN 
        countries c ON hi.country_id = c.id
    WHERE 
        hi.year = 2023
    ORDER BY 
        hi.ladder_score ASC
    LIMIT 10);
    """
    social_support_top_bottom_10_23 = execute_query(engine, social_support_top_bottom_10_23_query)
    plot_top_bottom_10(social_support_top_bottom_10_23, 'Top and Bottom 10 Countries by Ladder Score in 2023', 'darkgrey', 'coral')

if __name__ == "__main__":
    main()

