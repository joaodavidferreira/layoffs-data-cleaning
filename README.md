# Layoffs Data Cleaning | MySQL

## Project Overview

This project focuses on cleaning and preparing a dataset of company layoffs using MySQL.

The objective was to identify duplicate records, standardize inconsistent values, handle missing information, and prepare the dataset for future analysis.

This project was completed as part of Alex The Analyst's Data Analyst Bootcamp, with additional practice in troubleshooting and validating the results.

## Tools & Technologies

**Tools:**
- MySQL
- MySQL Workbench

**SQL Techniques:**
- **Data manipulation:** `INSERT INTO`, `UPDATE`, `DELETE`
- **Table management:** `CREATE TABLE`, `ALTER TABLE`
- **Duplicate detection:** `ROW_NUMBER()`, `PARTITION BY`, CTEs
- **Text standardization:** `TRIM()`, `TRIM(TRAILING ...)`, `LIKE`
- **Date conversion:** `STR_TO_DATE()`
- **Missing data handling:** `JOIN`, `IS NULL`
- **Data validation:** `SELECT`, `COUNT()`, `WHERE`

## Data Cleaning Process

The cleaning process involved the following steps:

1. **Creating staging tables:** Created copies of the original dataset to preserve the source data.
2. **Removing duplicates:** Used `ROW_NUMBER()` and `PARTITION BY` to identify duplicate records and remove them.
3. **Standardizing values:** Removed unnecessary spaces, standardized industry and country names, and converted dates to the appropriate format.
4. **Handling missing values:** Used a self-join to populate missing industry information where possible.
5. **Removing unusable records:** Excluded records where both `total_laid_off` and `percentage_laid_off` were missing.
6. **Final cleanup:** Removed the temporary row-number column.

## Results & Validation

| Metric | Result |
|---|---:|
| Original records | 2,361 |
| Final records | 1,995 |
| Records removed | 366 |

The final dataset was checked to confirm that:

- No exact duplicate records remained.
- No records remained with both layoff metrics missing.
- The SQL script executed successfully in MySQL Workbench.

The reduction in records reflects the cleaning criteria applied, rather than being a measure of improvement by itself.

## Challenges & Lessons Learned

During the initial cleaning process, I accidentally inserted data twice into a staging table, creating additional duplicate records.

I investigated the issue by comparing record counts and using `ROW_NUMBER()` to identify duplicates. I then created an additional staging table to correct the data.

This experience reinforced the importance of checking data after transformations, understanding how SQL statements affect tables, and validating the final results.

## Project Files

- `layoffs_data_cleaning.sql` — SQL script containing the data cleaning process.

## How to Run the Project

1. Import `layoffs.csv` into MySQL as a table named `layoffs`.
2. Execute `layoffs_data_cleaning.sql` in MySQL Workbench.
3. Review the cleaned dataset in the `layoffs_staging2` table.

**Note:** Run the script only once in a schema containing the original `layoffs` table, as it creates additional staging tables.

## Acknowledgements

This project was developed by following the SQL Data Cleaning tutorial from **Alex The Analyst's Data Analyst Bootcamp**.

The project provided practical experience with MySQL data cleaning techniques, troubleshooting, and data validation.

[Alex The Analyst — Data Analyst Bootcamp](https://www.youtube.com/watch?v=cnjhHZNJEDk)
