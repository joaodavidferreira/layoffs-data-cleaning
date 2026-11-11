-- SQL DATA CLEANING | LAYOFFS
-- MySQL 8+
-- Project completed following Alex The Analyst's SQL Data Cleaning tutorial.
-- Source table: layoffs (original imported dataset)
-- Final cleaned table: layoffs_staging2
-- Run once in a schema containing only the original layoffs table.
-- The original layoffs table is not modified.

-- 1. CREATE A COPY OF THE ORIGINAL DATA
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

-- 2. IDENTIFY AND REMOVE DUPLICATES
-- ROW_NUMBER() assigns a number to rows with identical values across all columns.
WITH duplicate_cte AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off,
                         percentage_laid_off, `date`, stage, country,
                         funds_raised_millions
        ) AS row_num
    FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Store the row numbers in a second staging table so duplicates can be deleted.
CREATE TABLE layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT DEFAULT NULL,
    percentage_laid_off TEXT,
    `date` TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT DEFAULT NULL,
    row_num INT
);

INSERT INTO layoffs_staging2
SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off,
                     percentage_laid_off, `date`, stage, country,
                     funds_raised_millions
    ) AS row_num
FROM layoffs_staging;

DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- 3. STANDARDIZE DATA
-- Remove extra spaces from company names.
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Standardize different Crypto industry labels.
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Remove the trailing period from United States country labels.
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Convert dates from text to MySQL DATE values.
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 4. HANDLE MISSING INDUSTRY VALUES
-- Treat empty industry strings as NULL.
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Fill missing industries only when a company has one known industry.
UPDATE layoffs_staging2 t1
JOIN (
    SELECT company, MAX(industry) AS industry
    FROM layoffs_staging2
    WHERE industry IS NOT NULL
    GROUP BY company
    HAVING COUNT(DISTINCT industry) = 1
) t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL;

-- 5. REMOVE ROWS WITHOUT LAYOFF INFORMATION
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- 6. REMOVE THE HELPER COLUMN
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- 7. REVIEW THE CLEANED DATA
SELECT *
FROM layoffs_staging2;
