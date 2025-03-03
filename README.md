# Netflix Movies And TV Shows Data Analysis
![Netflix logo](https://github.com/Nithish-712/Netflix_SQL_Project/blob/main/logo.jpeg)

## Overview

This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives


-  Analyze the distribution of content types (TV shows and Movies).
- Identify the most common ratings for movies and TV shows.
- list and analyze content based on release year, countries and durations.
- Explore and catagorize the content based on specific criteria and keywords.


## Dataset
The data for this project is sourced from the kaggle dataset:

- **Dataset Link:** [Movie Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```  Sql
drop table if exists netflix_table;
create table netflix_table(
	show_id varchar(6),
	type    varchar(10),
	title    varchar(150),
	director  varchar(250),
	casts      varchar(1000),
	country    varchar(150),
	date_added  varchar(50),
	release_year Int,
	rating	   varchar(10),
	duration varchar(15),
	listed_in        varchar(100),
	description  varchar(250)

);
```

## Business Problems and solutions
### 1.Count the Number of Movies vs TV Shows
```sql
select type , count(*) as total_content from netflix_table group by type;
```
**objective:** Determine the distribution of content types of Netflix.

### 2.Find the most common Ratings for Movies and TV Shows
```sql

 select type, rating from  
 (select type, rating, count(*) ,rank()over(partition by type order by count(*) desc) as ranking from netflix_table group by 1,2) as c
 where ranking=1;
```
**objective:** Identify the most frequently occurring rating for each type of content.
### 3.List All Movies Released in a Specific Year (e.g., 2020)
```sql
select  * from netflix_table where type='Movie' and release_year=2020 ;
```
**objective:** Retrieve all movies released in a specific year.
### 4.Find the Top 5 Countries with the Most Content on Netflix
```sql
select country from netflix_table;

 select unnest(string_to_array(country, ',')) as new_country, count(show_id) from netflix_table group by 1  order by 2 desc limit 5;
```
**objective:** Identify the top 5 countries with the highest number of content items.
### 5.Identify the Longest Movie
```sql
select * from 
 (select distinct title as movie,
  split_part(duration,' ',1):: numeric as duration 
  from netflix_table
  where type ='Movie') as subquery
where duration = (select max(split_part(duration,' ',1):: numeric ) from netflix_table)
```
**objective:** Find the movie with the longest duration.
### 6. Find Content Added in the Last 5 Years
```sql
select *   from  netflix_table  where To_date(date_added, 'Month, DD, YYYY') >= current_date - interval '5 year';
```
**objective:** Retrieve content added to Netflix in the last 5 years.
### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
select * from netflix_table where  director like '%Rajiv Chilaka%';
```
**objective:** List all content directed by 'Rajiv Chilaka'.
### 8. List All TV Shows with More Than 5 Seasons
```sql
select *, Split_part(duration,' ',1) from netflix_table where type = 'TV Show' and split_part(duration,' ',1) :: numeric > 5 ;
```
**objective:** Identify TV shows with more than 5 seasons.
### 9. Count the Number of Content Items in Each Genre
```sql
select  unnest(string_to_array( listed_in,',')) as gener, count(show_id) from netflix_table group by 1;
```
**objective:**  Count the number of content items in each genre.
### 10.Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release
```sql
select  extract (year from to_date(date_added,'month dd yyyy' )) as year,count(show_id), round( count(show_id) :: numeric/(select count(*) from netflix_table where country = 'India' )::numeric *100,2) As avg_content from netflix_table where country='India' group by 1 order by avg_content desc Limit 5;
 ```
**objective:** Calculate and rank years by the average number of content releases by India.
### 11. List All Movies that are Documentaries
```sql

 Select * from netflix_table where listed_in like'%Documentaries%' ;
```
**objective:** Retrieve all movies classified as documentaries.
### 12. Find All Content Without a Director
```sql
Select * from netflix_table where director is null ;
```
### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```sql
select * from netflix_table where  casts like '% Salman Khan%' and release_year > extract (year from current_date)-10;
```
**objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.
### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
``` sql
select unnest(string_to_array( casts,',')) as actor, count(show_id) from netflix_table where country like'%India%' group by 1 order by 2 desc Limit 10 ;
```
**objective:**  Identify the top 10 actors with the most appearances in Indian-produced movies.
### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```sql
with new_table 
 as(
 select  *,
 case
 when 
	 description  ilike '%kill%' or description ilike'%violence%' then 'Bad_content' 
	 else 'Good_content' 
	 end category
 
from netflix_table)
 select   category,count(*)from new_table group by 1;
 
 ```
**objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.
## Findings and Conclusion
- Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
- Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
- Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

## Author - Nithish Thalla
This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
- Linkedin:[ connect with me professionally ](www.linkedin.com/in/thalla-nithish-ab436a309)

 
