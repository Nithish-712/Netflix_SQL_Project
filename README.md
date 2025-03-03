# Netflix Movies And TV Shows Data Analysis
![Netflix logo](https://github.com/Nithish-712/Netflix_SQL_Project/blob/main/logo.jpeg)

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
