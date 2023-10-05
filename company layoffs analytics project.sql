--update kolom dengan replace tabel empty menjadi 0
UPDATE layoffs 
SET total_laid_off = 0 
WHERE total_laid_off IS NULL;

UPDATE layoffs 
SET percentage_laid_off = 0 
WHERE percentage_laid_off IS NULL;

UPDATE layoffs 
SET fund_raised = 0 
WHERE fund_raised IS NULL;

select
	*
from layoffs
where company = 'Uber'
;

--total layoff by year
select 
	sum(total_laid_off) as total_laid_off,
	(extract(year from date)) as year
from layoffs
group by 2
order by 1 desc;

-- layoff by month
select 
	sum(total_laid_off) as total_laid_off,
	(extract(month from date)) as month
from layoffs
group by 2
order by 1 asc;

--top 5 staff laid off companies
select
	company,
	sum(total_laid_off) as total_laid_off
from layoffs
group by 1
order by 2 desc
limit 5;

--companies with highest fundraiser
select
	company,
	sum(fund_raised)
from layoffs
group by 1
order by 2 desc
limit 5;

--company stage with the highest fundraising and lay off
select 
	stage,
	sum(fund_raised) as fund_raised,
	sum(total_laid_off) as total_laid_off
from layoffs
where stage is not null
group by 1
having sum(fund_raised) > 0
order by 2, 3 desc
limit 5;

--industries with the highest fundraiser
select
	industry,
	sum(fund_raised) as fund_raised
from layoffs
group by 1
order by 2 desc
limit 5;




