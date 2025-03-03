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

select * from netflix_table;

select count (* ) as total_content from netflix_table;
select distinct  type as genre from netflix_table;
-- count the number of movies vs tv shows---

select type , count(*) as total_content from netflix_table group by type;

---Find the most common rating for Movies and TV Shows----


 select type, rating from  
 (select type, rating, count(*) ,rank()over(partition by type order by count(*) desc) as ranking from netflix_table group by 1,2) as c
 where ranking=1;
 
 ------List all movies released in specific year (e.g 2020)---

 
 select  * from netflix_table where type='Movie' and release_year=2020 ;
 
 ---- Find the top 5 countries with the most content on netflix-----

 
 select country from netflix_table;

 select unnest(string_to_array(country, ',')) as new_country, count(show_id) from netflix_table group by 1  order by 2 desc limit 5;


---- Identify the longest movie-----


select * from 
 (select distinct title as movie,
  split_part(duration,' ',1):: numeric as duration 
  from netflix_table
  where type ='Movie') as subquery
where duration = (select max(split_part(duration,' ',1):: numeric ) from netflix_table)


----Find the content added in last Five years-----

select *   from  netflix_table  where To_date(date_added, 'Month, DD, YYYY') >= current_date - interval '5 year';

 
 ---- Find the all TV shows/Movies by director ---

select * from netflix_table where  director like '%Rajiv Chilaka%';


--- List the all TV shows more than 5 seasons----

select *, Split_part(duration,' ',1) from netflix_table where type = 'TV Show' and split_part(duration,' ',1) :: numeric > 5 ;


----- count the number of content in  each genre----
 
 
 select  unnest(string_to_array( listed_in,',')) as gener, count(show_id) from netflix_table group by 1;

 
 
----Find each year and the average number of content releasse by india on netflix and retrun top 5 years with highest avg content----


select  extract (year from to_date(date_added,'month dd yyyy' )) as year,count(show_id), round( count(show_id) :: numeric/(select count(*) from netflix_table where country = 'India' )::numeric *100,2) As avg_content from netflix_table where country='India' group by 1 order by avg_content desc;
 
 
 --- listed all movies and they are in documentaries---
 
 
 Select * from netflix_table where listed_in like'%Documentaries%' ;
 
 ---- find all content without director---
 
 
 Select * from netflix_table where director is null ; 

 
 ---find  how many movies actor 'salmon khan ' appeared in last 10 years----


select * from netflix_table where  casts like '% Salman Khan%' and release_year > extract (year from current_date)-10;
 
 
 -----find the top 10 actors who acted in highest number of movies in india---
 
 
 select unnest(string_to_array( casts,',')) as actor, count(show_id) from netflix_table where country like'%India%' group by 1 order by 2 desc Limit 10 ;
 

--categroize the content based on the presence of keyword 'kill' and 'violence' in description field. label content keywords 'bad' and all other content keyword 'good'---
 
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
 
 