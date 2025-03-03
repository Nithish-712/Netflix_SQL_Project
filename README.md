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
**objective:** Determine the distribution of content types of Netflix
