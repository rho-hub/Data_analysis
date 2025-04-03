-- DATA CLEANING

SELECT *
FROM layoffs;

-- REMOVE DUPLICATES
-- STANDARDIZE DATA
-- NULL VALUES
-- REMOVE ANY COLUMNS



CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- removing DUPLICATES

SELECT *, 
row_number() OVER(
	PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`
) as row_numb
FROM layoffs_staging;

with duplicate_cte as (
SELECT *, 
row_number() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised
) as row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` double DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` text,
  `row_numb` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *, 
row_number() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised
) as row_numb
FROM layoffs_staging;

SHOW GRANTS FOR CURRENT_USER;

DELETE 
FROM layoffs_staging2
where row_numb > 1;

-- standardizing

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET company = TRIM(company);

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_staging2
set industry = 'crypto'
WHERE industry LIKE 'cripto%';

SELECT distinct industry
FROM layoffs_staging2
order by 1;

SELECT location,
  TRIM(BOTH "'" FROM SUBSTRING_INDEX(SUBSTRING_INDEX(location, ',', 1), '[', -1)) AS new_location
FROM layoffs_staging2
WHERE location LIKE '%Non-u.s%';

update layoffs_staging2
set location = TRIM(BOTH "'" FROM SUBSTRING_INDEX(SUBSTRING_INDEX(location, ',', 1), '[', -1));

SELECT distinct location
FROM layoffs_staging2
order by 1;

select `date`, TRIM(TRAILING 'T00:00:00.000Z' FROM `DATE`) AS new_date 
from layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = TRIM(TRAILING 'T00:00:00.000Z' FROM `DATE`);

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging
ORDER BY 1;

SELECT location,
  TRIM(BOTH "'" FROM SUBSTRING_INDEX(SUBSTRING_INDEX(location, ',', 1), '[', -1)) AS new_location
FROM layoffs_staging
WHERE location LIKE '%Non-u.s%';

update layoffs_staging
set location = new_location;

SELECT *
FROM layoffs_staging2;

-- NULLS

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off IS NULL 
OR percentage_laid_off = ''
;

SELECT * 
FROM layoffs_staging2 
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET percentage_laid_off = NULL 
WHERE percentage_laid_off = ''
;

SELECT * 
FROM layoffs_staging2;

-- REMOVING ROWS
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_numb;




