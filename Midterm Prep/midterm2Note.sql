-- 期中考复习 摘自课堂ppt

-- COUNT Examples 

-- 1. Find the total number of customers 
SELECT cid
FROM Customers;

-- 2. Find the total number of days that customers engaged in activites
SELECT COUNT(DISTINCT day)
FROM Activites;

-- COUNT query with join involve 
-- 3. Find the number of activites done by advanced customers
SELECT COUNT(a.cid)
FROM Activites a, Customers c
WHERE a.cid = c.cid
    AND c.level = 'Advanced';

-- 4. Find the number of activites done by DIFFERENT advanced customer 
SELECT COUNT(DISTINCT a.cid)
FROM Activites a, Customers C
WHERE a.cid = c.cid
    AND c.level = 'Advanced';

Would these queries have same results with COUNT(c.cid) instead of 
COUNT(a.cid)?  -- No, C 会count from the Customers table for customers with a level of 'Advanced'.

-- COUNT(*): Counts all rows.
-- COUNT(DISTINCT column): Counts the number of distinct values in the specified column.

-- COUNT Example with JOIN and GROUP BY
-- 5. For each day, find the number of activites that were done by advanced customers 
SELECT COUNT(a.cid)
FROM Activites a, Customers c 
WHERE a.cid = c.cid
    AND c.level = 'Advanced'
GROUP BY a.day

-- 6. For each day, find the number of different advanced customer who did at least one activity 
SELECT COUNT(DISTINCT a.cid) 
FROM Activites a, Customers c
WHERE a.cid = c.cid
    AND c.level = 'Advanced'
GROUP BY a.day


-- COUNT Examples, with JOIN and GROUP BY with Two Attributes 
-- 7. For each level and day, find the number of activites done that day by customer at that level 
SELECT a.day, c.level, COUNT(a.cid)
FROM Activites a, Customers c 
WHERE a.cid = c.cid
GROUP BY a.day c.level 

-- 8. For each level and day, find the number of activites done that day by different customers at that level.
SELECT a.day, c.level, COUNT(DISTINCT a.cid)
FROM Activites a, Customers c 
WHERE a.cid = c.cid
GROUP BY a.day c.level

/*
        COUNT Examples, with JOIN and GROUP BY and HAVING

 - For each customer level, find the number of times that customers who are 
 at that level went on a red slope, giving level as well as number of times, 
 but only if the number of times is at least 3. 
 The number of times should appear as redCount in the result.
*/

SELECT c.level, COUNT(*) AS redCount 
FROM Customers C, Activites a, Slopes s
WHERE a.cid = c.cid
    AND a.slopeid = s.slopeid
    AND s.color = 'Red'
GROUP BY C.level
HAVING COUNT(*) >= 3


-- sum avg min max --> written on paper 

