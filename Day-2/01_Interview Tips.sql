-- Problem 1 - Empty Neighborhoods

-- We’re given two tables, a users table with demographic information and the neighborhood they live in and a neighborhoods table.

-- Write a query that returns all neighborhoods that have 0 users. 

-- Example:

-- Input:

-- users table

-- Columns	Type
-- id	INTEGER
-- name	VARCHAR
-- neighborhood_id	INTEGER
-- created_at	DATETIME
-- neighborhoods table

-- Columns	Type
-- id	INTEGER
-- name	VARCHAR
-- city_id	INTEGER
-- Output:

-- Columns	Type
-- name	VARCHAR

-- Answer

-- Method 1
select  n.name
from    neighborhoods as n 
where   n.id not in
                                (
                                    select  neighborhood_id
                                    from    users
                                )

-- Method 2
select  n.name as name
from    neighborhoods as n left join users as u
            on n.id = u.neighborhood_id 
group by n.name
having  COUNT(u.id) = 0

-- Method 3
select  n.name as name
from    neighborhoods as n left join users as u
            on n.id = u.neighborhood_id 
where   u.neighborhood_id is NULL

-- Method 3 is more readable (Although 2 and 3 are same with efficiency)

-- Control Different ways while practicing


-- Problem 2 Third Unique Song

-- Given a table of song_plays and a table of users, write a query to extract the earliest date each user played their third unique song.

-- Example:

-- Input:

-- song_plays table

-- Columns	Type
-- user_id	INTEGER
-- song_name	TEXT
-- date_played	DATETIME
-- users table

-- Columns	Type
-- id	INTEGER
-- name	VARCHAR
-- Output:

-- Columns	Type
-- name	VARCHAR
-- date_played	DATETIME
-- song_name	TEXT

-- Tip:
-- Taking time to do steps when there's lot of logic or data needs to be cleaned up before anwering the question 
-- Meaning sometimes you need to pre process the data in order to implement the logic

-- Answer: 

with t1 as (
    SELECT  song_name,
            user_id,
            min(date_played) as date_played
    FROM    song_plays 
    GROUP   BY song_name, user_id
),

t2 as (
    SELECT  u.name,
            t1.song_name,
            t1.date_played,
            row_number() over (
                partition by u.name order by t1.date_played 
            ) as rn
    FROM    t1 JOIN users as u 
                ON t1.user_id = u.id
)

SELECT  name,
        date_played,
        song_name
FROM    t2
WHERE   rn = 3;

-- To Do:
-- Add below conditiona and modify query
-- Note: If a user has listened to less than three unique songs, display their name but with a NULL date and song name

-- Problem 3: Closest SAT Scores

-- Given a table of students and their SAT test scores, write a query to return the two students with the closest test scores with the score difference.

-- If there are multiple students with the same minimum score difference, select the student name combination that is higher in the alphabet. 

-- Example:

-- Input:

-- scores table

-- Column	Type
-- id	INTEGER
-- student	VARCHAR
-- score	INTEGER
-- Output:

-- Column	Type
-- one_student	VARCHAR
-- other_student	VARCHAR
-- score_diff	INTEGER

-- Answer: 

select  t1.student as one_student,
        t2.student as other_student,
        abs(t1.score - t2.score) as score_diff
from    scores as t1
        join scores as t2   
            on t1.id != t2.id 
order   by 3
limit   1;

-- Note:
-- Work for - If there are multiple students with the same minimum score difference, select the student name combination that is higher in the alphabet. 
