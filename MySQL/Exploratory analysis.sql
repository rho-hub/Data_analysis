-- EXPLORATORY

SELECT * 
FROM layoffs_staging2;

SELECT MAX(total_laid_off), max(percentage_laid_off), SUM(total_laid_off)
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN funds_raised;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MAX(`date`), MIN(`date`)
FROM layoffs_staging2;

SELECT INDUSTRY, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `MONTH`
ORDER BY 1 ASC
;


WITH rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS tf
FROM layoffs_staging2
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, SUM(tf) OVER(ORDER BY `MONTH`) AS STF, tf
FROM rolling_total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC ;

WITH Company_Year(company, years, total_laid_off) AS(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC 
), Company_Year_Rank AS(
SELECT * , dense_rank() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
wHERE years IS NOT NULL)
SELECT *
FROM Company_Year_Rank
WHERE ranking <=5;






SELECT *
FROM layoffs_staging2;
