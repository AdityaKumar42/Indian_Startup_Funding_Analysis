-- Create database (if not exists)
create database startup_analysis;

use startup_analysis;

-- Create table for cleaned data
create table startup_funding (
    id int auto_increment primary key,
    date date not null,
    Startup_Name varchar(255),
    City_Location varchar(100),
    Investors_Name text,
    Industry_Vertical varchar(255),
    SubVertical varchar(255),
    Investment_Type varchar(100),
    Amount_in_USD bigint,
    Remarks text,
    Year int
);

# Level-1 (Basic Analysis — 6 Queries)
# 1. Total Funding Amount

select sum(Amount_in_USD) as Total_Funding
from startup;

# 2. Number of Startups Funded

select count(distinct Startup_Name) as Total_Startups
from startup;

# 3. Total Funding By City

select City_Location,
	   sum(Amount_in_USD) as Total_Funding
from startup
group by City_Location
order by total_funding desc;

# 4. Total Funding By Industry

select Industry_Vertical, sum(Amount_in_USD) as Total_Funding
from startup
group by Industry_Vertical
order by Total_Funding desc;

# 5. Funding Count By Year

select year, count(*) as Funding_Deals
from startup
group by year
order by year asc;

# 6. Top Sub-Verticals

select SubVertical, sum(Amount_in_USD) as Total_Funding
from startup
group by SubVertical
order by Total_Funding desc
limit 10;

# Level-2 (Intermediate — 6 Queries)
# 7. Top 10 Investors by Investment Amount

select Investors_Name, sum(Amount_in_USD) as Total_Invested
from startup
group by Investors_Name
order by Total_Invested desc
limit 10;

# 8. Year-over-Year Growth in Funding

select year,
       sum(Amount_in_USD) as Total_Funding,
       lag(sum(Amount_in_USD)) over (order by year) as Prev_Year_Funding,
       round(
            (sum(Amount_in_USD) - lag(sum(Amount_in_USD)) over (order by year)) 
            / lag(sum(Amount_in_USD)) over (order by year) * 100, 2
            ) as YoY_Growth_Percentage
from startup
group by year;
		
# 9. Funding By Investment Type

select InvestmentnType, sum(Amount_in_USD) as Total_Funding
from startup
group by InvestmentnType
order by Total_Funding desc;

# 10. Top 5 Startups With Maximum Funding

select startup_name, sum(Amount_in_USD) as Total_Raised
from startup
group by Startup_Name
order by Total_Raised desc
limit 5;

# 11. Cities with Most Funded Startups

select City_Location, count(distinct Startup_Name) as Startup_Count
from startup
group by City_Location
order by Startup_Count desc;

# 12. Number of Funding Deals By Sector Per Year

select year, Industry_Vertical,
       count(*) as Deals
from startup
group by year, Industry_Vertical
order by year, Deals desc;

# Level-3 (Advanced Queries — 7 Queries)
# 13. Identify Unicorn Makers (Investors who created unicorns)
# (Assuming startups > $1B funding total = unicorn)

with startup_total as (
    select Startup_Name, sum(Amount_in_USD) as Total
    from startup
    group by Startup_Name
    having Total > 1000000000
)
select distinct Investors_Name
from startup
where Startup_Name in (select Startup_Name from startup_total);

# 14. Which Industry Receives Most Early-Stage Funding?

select Industry_Vertical, sum(Amount_in_USD) as Seed_SeriesA_Funding
from startup
where InvestmentnType in ('Seed', 'Series A')
group by Industry_Vertical
order by Seed_SeriesA_Funding desc;

# 15. Trend of Funding Cycles (Stage progression)

select 
    InvestmentnType,
    count(*) as Deals,
    sum(Amount_in_USD) as Total_Funding
from startup
group by InvestmentnType
order by Total_Funding desc;

# 16. Most Consistent Investors (invest every year)

SELECT Investors_Name, count(distinct Year) as Active_Years
from startup
group by Investors_Name
having Active_Years >= 5
order by Active_Years desc;

# 17. Year with Maximum Funding Spike

select year, SUM(Amount_in_USD) AS Total_Funding
from startup
group by year
order by Total_Funding desc
limit 1;

# 18. Biggest Funding Deals

select *
from startup
order by Amount_in_USD desc
limit 10;

# 19. Number of Startups Funded Per Investor

select Investors_Name, count(distinct Startup_Name) as Unique_Startups
from startup
group by Investors_Name
order by Unique_Startups desc;