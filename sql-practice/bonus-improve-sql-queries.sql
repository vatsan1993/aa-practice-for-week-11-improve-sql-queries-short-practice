----------
-- Step 0 - Create a Query
----------
-- Query: Find a count of `toys` records that have a price greater than
-- 55 and belong to a cat that has the color "Olive".
-- Your code here
select count(*)
from toys
    join cat_toys on toys.id = cat_toys.toy_id
    join cats on cats.id = cat_toys.cat_id
where
    cats.color = 'Olive'
    and price > 55;
-- Paste your results below (as a comment):
-- 215

----------
-- Step 1 - Analyze the Query
----------
-- Query:
EXPLAIN QUERY PLAN
select count(*)
from toys
    join cat_toys on toys.id = cat_toys.toy_id
    join cats on cats.id = cat_toys.cat_id
where
    cats.color = 'Olive'
    and price > 55;

-- Your code here
-- Paste your results below (as a comment):
-- QUERY PLAN
--SCAN cat_toys
--SEARCH toys USING INTEGER PRIMARY KEY (rowid=?)
--SEARCH cats USING INTEGER PRIMARY KEY (rowid=?)
-- What do your results mean?
-- its still a bit inefficient on cat_toys
-- Was this a SEARCH or SCAN?
-- scan on cat_toys.
-- What does that mean?
-- we need to add an index for both cat_id and toy_id combined.
----------
-- Step 2 - Time the Query to get a baseline
----------
-- Query (to be used in the sqlite CLI):
.timer ON
select count(*)
from toys
    join cat_toys on toys.id = cat_toys.toy_id
    join cats on cats.id = cat_toys.cat_id
where
    cats.color = 'Olive'
    and price > 55;

.timer off
-- Your code here
-- Paste your results below (as a comment):
-- Run Time: real 0.000 user 0.000072 sys 0.000016
----------
-- Step 3 - Add an index and analyze how the query is executing
----------
-- Create index:


CREATE INDEX idx_toys_price ON toys (price);

CREATE INDEX idx_cats_color ON cats (color);

create index idx_cat_toys_cat_id on cat_toys (cat_id);
-- Your code here
-- Analyze Query:
EXPLAIN QUERY PLAN
select count(*)
from toys
    join cat_toys on toys.id = cat_toys.toy_id
    join cats on cats.id = cat_toys.cat_id
where
    cats.color = 'Olive'
    and price > 55;

-- Your code here
-- Paste your results below (as a comment):
-- Analyze Results:
-- QUERY PLAN
-- |--SEARCH cats USING COVERING INDEX idx_cats_color (color=?)
-- |--SEARCH cat_toys USING INDEX idx_cat_toys_cat_id (cat_id=?)
-- `--SEARCH toys USING INTEGER PRIMARY KEY (rowid=?)
-- Is the new index being applied in this query?
-- yes
----------
-- Step 4 - Re-time the query using the new index
----------
-- Query (to be used in the sqlite CLI):
-- Your code here
.timer ON
select count(*)
from toys
    join cat_toys on toys.id = cat_toys.toy_id
    join cats on cats.id = cat_toys.cat_id
where
    cats.color = 'Olive'
    and price > 55;

.timer off
-- Paste your results below (as a comment):
-- Analyze Results:

-- 215
-- Run Time: real 0.002 user 0.000636 sys 0.001151

-- Are you still getting the correct query results?
-- Did the execution time improve (decrease)?
-- improved
-- Do you see any other opportunities for making this query more efficient?

---------------------------------
-- Notes From Further Exploration
---------------------------------
