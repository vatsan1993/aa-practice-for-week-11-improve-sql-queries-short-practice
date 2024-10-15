----------
-- Step 0 - Create a Query
----------
-- Query: Select all cats that have a toy with an id of 5

-- Your code here
.headers ON 

select cats.*
from cats
    join cat_toys on cats.id = cat_toys.cat_id
where
    toy_id = 5;

-- Paste your results below (as a comment):
-- id|name|color|breed
-- 4002|Rachele|Maroon|Foldex Cat
-- 31|Rodger|Lavender|Oregon Rex
-- 77|Jamal|Orange|Sam Sawet
----------
-- Step 1 - Analyze the Query
----------
-- Query:
EXPLAIN QUERY PLAN
select cats.*
from cats
    join cat_toys on cats.id = cat_toys.cat_id
where
    toy_id = 5;
-- Your code here
-- Paste your results below (as a comment):
-- QUERY PLAN
-- SCAN cat_toys
-- SEARCH cats USING INTEGER PRIMARY KEY (rowid=?)
-- What do your results mean?
-- key is not set on the cat_id or toy_id in the cat_toys table
-- Was this a SEARCH or SCAN?
-- it was search for cats but scan for cat_toys table
-- What does that mean?
-- cat_toys table needs to have index
----------
-- Step 2 - Time the Query to get a baseline
----------
-- Query (to be used in the sqlite CLI):
-- Your code here
.timer ON 

select cats.*
from cats
    join cat_toys on cats.id = cat_toys.cat_id
where
    toy_id = 5;

.timer off
-- Paste your results below (as a comment):
-- id|name|color|breed
-- 4002|Rachele|Maroon|Foldex Cat
-- 31|Rodger|Lavender|Oregon Rex
-- 77|Jamal|Orange|Sam Sawet
-- Run Time: real 0.001 user 0.000032 sys 0.000095
----------
-- Step 3 - Add an index and analyze how the query is executing
----------
-- Create index:
-- Your code here
create index idx_cat_toys_toy_id on cat_toys(toy_id);

EXPLAIN QUERY PLAN
select cats.*
from cats
    join cat_toys on cats.id = cat_toys.cat_id
where
    toy_id = 5;
-- Analyze Query:
-- Your code here
-- Paste your results below (as a comment):
-- QUERY PLAN
--SEARCH cat_toys USING INDEX idx_cat_toys_toy_id (toy_id=?)
--SEARCH cats USING INTEGER PRIMARY KEY (rowid=?)
-- Analyze Results:
-- both are now search
-- Is the new index being applied in this query?
-- this will improve the search capability
----------
-- Step 4 - Re-time the query using the new index
----------
-- Query (to be used in the sqlite CLI):
-- Your code here
.timer ON 

select cats.*
from cats
    join cat_toys on cats.id = cat_toys.cat_id
where
    toy_id = 5;

.timer off
-- Paste your results below (as a comment):
-- id|name|color|breed
-- 4002|Rachele|Maroon|Foldex Cat
-- 31|Rodger|Lavender|Oregon Rex
-- 77|Jamal|Orange|Sam Sawet
-- Run Time: real 0.000 user 0.000027 sys 0.000080
-- Analyze Results:
-- the time has reduced
-- Are you still getting the correct query results?
-- Did the execution time improve (decrease)?
-- Do you see any other opportunities for making this query more efficient?
---------------------------------
-- Notes From Further Exploration
---------------------------------
