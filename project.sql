CREATE TABLE Titles (
    id VARCHAR(255) PRIMARY KEY,
    title VARCHAR(255),
    type VARCHAR(50),
    description TEXT,
    release_year NUMERIC,
    age_certification VARCHAR(50),
    runtime NUMERIC,
    genres VARCHAR(255),
    production_countries VARCHAR(255),
    seasons INTEGER,
    imdb_id VARCHAR(255),
    imdb_score DECIMAL(20,8),
    imdb_votes INTEGER,
    tmdb_popularity DECIMAL(20,8),
    tmdb_score DECIMAL(20,8)
);

CREATE TABLE Credits (
    person_ID VARCHAR(255),
    id VARCHAR(255),
    name VARCHAR(255),
    character_name VARCHAR(5000),
    role VARCHAR(50),
    FOREIGN KEY (id) REFERENCES Titles(id)
);


SELECT * FROM titles;
select * from credits;

select * from titles
WHERE genres LIKE '%comedy%' OR genres LIKE '%war%';

select distinct(title), t.type, c.character_name, c.role,  from titles t
join credits c
on t.id=c.id;

--#1Retrieve all columns from the titles table.
select * from titles;

ALTER TABLE titles 
RENAME COLUMN type TO show_type;

--#2Retrieve titles where the show_type is 'TV show'.
select distinct(title) from titles
where show_type = 'SHOW' AND title IS NOT NULL;

--#3 Count the number of titles for each unique age certification.
select age_certification, count(distinct(titles))
from titles
group by age_certification;

--#4 Calculate the average runtime for movies.
select avg(runtime) as Average Runtime from titles
where show_type= 'MOVIE';

--#5 List all distinct genres
select distinct genres from titles
where genres is not null;

--#6 Titles released before 2000
select title from titles 
where release_year<2000;

--#7 Top 5 Popular Titles by tmdb_popularity
select title from titles
where tmdb_popularity is not null
order by tmdb_popularity DESC
limit 5;

--#8 Retrieve titles with an IMDB score above 8.
select count(title) from titles
where imdb_score>8;

--# 9 Join titles and credits table
select * from titles 
left outer join credits
on titles.id= credits.id;

select title from titles
where id = 'tm87233';

--#10 count credits by role- meaning count the values in the credits table by role
select role, count(*) as credit_count
from credits
group by role;

select * from titles;

--#11 Retrieve titles that don't have an IMDB score.
select title from titles 
where imdb_score is null;

--#12 Retrieve titles and their genres where more than one country produced the title. 

select title, genres from titles
where production_countries like '%,%';

--#13 Calculate the average IMDB score for each age certification.
select round(avg(imdb_score),2) as average_imdb_score, titles.age_certification from titles
where age_certification is not null
group by age_certification;

--#14 Retrieve titles with descriptions longer than 100 characters.
select title from titles 
where length(description)>100;

--#15 Identify the top 3 genres with the highest tmdb_popularity.
select genres, tmdb_popularity from titles
where tmdb_popularity is not null
order by tmdb_popularity desc
limit 3;

select * from titles;
select * from credits;

--#16 Count Titles with Multiple Genres:
select count(title)
from titles 
where genres like '%,%';

--#17 Retrieve titles released in the last 5 years.
select title, release_year from titles
where release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 5
ORDER BY RELEASE_YEAR DESC;

--#18 Count the number of titles for each unique show_type.
select count(title), show_type from titles
group by show_type;

--#19 Retrieve titles with more than 5 seasons.
select title from titles 
where seasons>5;

--#20 Identify the top 5 directors with the most titles.-IMP
SELECT name AS director, COUNT(*) AS title_count
FROM credits
WHERE role = 'DIRECTOR'
GROUP BY name
ORDER BY title_count DESC
LIMIT 5;

select * from credits 
where role= 'DIRECTOR';

--#21 Retrieve titles with fewer than 100 votes on IMDB.
select title from titles
where imdb_votes<100;

--#22 Calculate the total runtime for each genre.
select sum(runtime) as runtime, genres 
from titles
where genres is not null
group by genres
order by runtime desc;

--#23 Retrieve titles that have similar descriptions.- redo
select title, description from titles;

--#24 Retrieve titles released in 2020 with an IMDB score above 7.
select title from titles
where release_year= 2020 and imdb_score>7;

--#25 Count the number of credits for each person. -redo
select distinct name, count(*)
from credits
group by name;

--#26 Retrieve titles where the character_name is the same as the person's name.
SELECT t.title, c.character_name, c.name
FROM titles t
JOIN credits c ON t.id = c.id
WHERE c.character_name = c.name;

--#27 Calculate the total number of votes on IMDB for each title:
SELECT title, SUM(imdb_votes) AS total_imdb_votes
FROM titles
GROUP BY title;

--#28 Retrieve titles with both high IMDB scores (above 8) and high tmdb_popularity (above average)
SELECT title, imdb_score, tmdb_popularity
FROM titles
WHERE imdb_score > 8
AND tmdb_popularity > (SELECT AVG(tmdb_popularity) FROM titles);

select * from titles;
select * from credits;
--#29 Calculate the average IMDB score for titles that belong to more than one genre.
select title, ROUND(AVG(imdb_score),2) as avg_imdb from titles
where genres like '%,%' and imdb_score is not null and titles is not null
group by title;

--#30 Calculate the total number of votes on IMDB for each title.
SELECT title, SUM(imdb_votes) AS total_imdb_votes
FROM titles
GROUP BY title;

-- #31 Retrieve titles where a person has both ACTOR and DIRECTOR roles.
select t.title, c1.name as person_name
from titles t
join credits c1
on t.id= c1.id
join credits c2
on t.id= c2.id
where c1.role = 'ACTOR'
and c2.role = 'DIRECTOR'
and c1.name=c2.name

select name,role from credits 
where name= 'William Wyler'

--#32 Retrieve titles with an IMDB score higher than the average of the top 5 genres.
-- CTE:WITH  

WITH TopGenres AS(
	select genres, avg(imdb_score) as avg_genre_score
	from titles
	group by genres
	order by avg(imdb_score) desc
	limit 5
)

select t.title, t.imdb_score
from titles t
join TopGenres tg ON t.genres = tg.genres
where t.imdb_score > tg.avg_genre_score;

select * from titles;
select * from credits;
--#33 Identify titles with a high ratio of IMDB votes to tmdb_popularity.
select title, imdb_votes, tmdb_popularity,
	 	CAST(imdb_votes AS FLOAT) / NULLIF(tmdb_popularity, 0) AS vote_popularity_ratio
from titles
where imdb_votes>0 and 
	  imdb_votes is not null and 
	  tmdb_popularity>0 and 
	  tmdb_popularity is not null and 
	  Cast(imdb_votes as float)/nullif(tmdb_popularity,0)>5000
	  
--#34 Retrieve titles that have different age certifications within the same genre.
SELECT t1.title, t1.age_certification AS certification_1, t2.age_certification AS certification_2, t1.genres
FROM titles t1
JOIN titles t2 ON t1.genres = t2.genres AND t1.title <> t2.title
WHERE t1.age_certification <> t2.age_certification;

--#35 Calculate the cumulative IMDB score for each director.
select c.name as director_name, sum(t.imdb_score) as imdb_score
from titles t join credits c
on t.id=c.id
where role= 'DIRECTOR'
group by c.name

--#36 Retrieve titles along with the names of actors who played in them.
select t.title, c.character_name
from titles t 
join credits c
on t.id=c.id

select * from credits
--#37 Display the titles and release years for all movies that a specific actor(Charles Williams, Ed Brady, Jack Curtis) has worked in.
select t.title, t.release_year
from titles t
join credits c
on t.id=c.id
where c.name in ('Charles Williams') and t.show_type= 'MOVIE'

--#38 Find titles where the same person has both acted and directed.
select t.title
from credits c1
join credits c2 on c1.id=c2.id
join titles t on c1.id=t.id
where c1.person_id=c2.person_id and c1.role in ('ACTOR','DIRECTOR')

--#39 Retrieve titles with actors and directors listed separately (pivot the data).
-- STRING_AGG(expression, delimiter)
SELECT t.title,
       STRING_AGG(CASE WHEN c.role = 'ACTOR' THEN c.name END, ', ') AS actors,
       STRING_AGG(CASE WHEN c.role = 'DIRECTOR' THEN c.name END, ', ') AS directors
FROM titles t
JOIN credits c ON t.id = c.id
GROUP BY t.title;

--#40 Find the total number of titles produced in each country.
select count(titles) as totaltitles, production_countries
from titles
where production_countries is not null 
group by production_countries

--#41 Calculate the average IMDB score and total votes for titles in each genre.
select genres, round(avg(imdb_score),2), count(imdb_votes)
from titles 
group by genres

select * from titles

--#42 Get the names of actors who have worked in titles with an IMDB score above 8.
select distinct c.name 
from credits c
join titles t
on t.id=c.id 
where imdb_score>8

--#43 Calculate the average IMDB score for each genre and select the top genre. USING CTE

with genre_avg_score as
	(select avg(imdb_score) as avg_scores, genres
	 from titles 
	 group by genres)
	 
	 select genres, round(avg_scores,2)
	 from genre_avg_score
	 where avg_scores is not null
	 order by avg_scores desc
	 limit 1

--#44 Find titles where actors have played characters with the same name.

SELECT DISTINCT t.title, c1.character_name, c1.name AS actor_name
FROM titles t
JOIN credits c1 ON t.id = c1.id
JOIN credits c2 ON t.id = c2.id
WHERE c1.name = c2.name -- Same actor
  AND c1.character_name = c2.character_name -- Same character name
  AND c1.person_id != c2.person_id; -- Ensure different occurrences of the same character

--#45 Rank titles based on IMDB score within each genre.

SELECT title, genre, imdb_score,
       RANK() OVER (PARTITION BY genre ORDER BY imdb_score DESC) AS imdb_rank
FROM titles;

--#46 Calculate the running total of IMDB votes over time for a specific title.

SELECT title, release_year, imdb_votes,
       SUM(imdb_votes) OVER (PARTITION BY title ORDER BY release_year) AS running_total_votes
FROM titles;

--#47 Calculate the Average IMDB Score Over the Years:
SELECT release_year, round(AVG(imdb_score),2) AS avg_imdb_score
FROM titles
GROUP BY release_year
ORDER BY release_year;

--#48 Identify Titles with Similar Descriptions
SELECT t1.title AS title1, t2.title AS title2, t1.description
FROM titles t1
JOIN titles t2 ON t1.description = t2.description AND t1.title <> t2.title;

--#49 Retrieve Titles with the Highest IMDB Score in Each Genre
SELECT genres, title, imdb_score
FROM (
    SELECT genres, title, imdb_score,
           ROW_NUMBER() OVER (PARTITION BY genres ORDER BY imdb_score DESC) AS rank
    FROM titles
) ranked_titles
WHERE rank = 1;

--#50 Calculate the Average IMDB Score for Titles with Above-Average Runtime:
SELECT AVG(imdb_score) AS avg_imdb_score
FROM titles
WHERE runtime > (SELECT AVG(runtime) FROM titles);