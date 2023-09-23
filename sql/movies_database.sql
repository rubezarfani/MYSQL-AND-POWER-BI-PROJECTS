#extracting required columns
select m.movie_id,title,budget,revenue,currency,unit
	from movies m
		join financials f
		on m.movie_id=f.movie_id;

-- to find how many movies are in the language "telugu" ;
#to find language_id 
SELECT m.title, l.name
	 FROM movies m 
		join languages l USING (language_id);
 
 #retriving the title of theh movies which are made in telugu language
SELECT title	
FROM movies m 
   LEFT JOIN languages l 
   ON m.language_id=l.language_id
WHERE l.name="Telugu";
   #(report) getting the count of movies made in each language
SELECT 
            l.name, 
            COUNT(m.movie_id) as no_movies
	FROM languages l
		LEFT JOIN movies m USING (language_id)        
	GROUP BY language_id
	ORDER BY no_movies DESC;
    #-------------------------------------------------#
    #joining two tables from the database and also generating a column called "profit "from the database
select 
    m.movie_id,title,budget,revenue,currency,unit,
    case
		when unit="thousands" then round((revenue-budget)/1000,1)  #normalising units in generated column
		when unit="billions" then round((revenue-budget)*1000,1)
		else round(revenue-budget,1)
    end as profit_in_mln
from movies m 
    join financials f on m.movie_id=f.movie_id
    where industry  ="bollywood"
    order by profit_in_mln desc;
#retriving the count of movies that each actor has acted in 
select actor_id,name,(select count(*) 
	from movie_actor
	where actor_id=actors.actor_id) as movies_count
from actors
order by movies_count desc 
#generating a report which contains all bollywood movies which made more than 600 million; 
with cte as (select title, release_year, (revenue-budget) as profit
			from movies m
				join financials f
				on m.movie_id=f.movie_id
			where release_year>2000 and industry="bollywood"
	) 
	select * from cte where profit>600
