-- Practice Homework 4
/*
– Beers(name,manufacturer)
– Bars(name,address,license)
– Sells(bar,beer,price)
– Drinkers(name,address,phone)
– Likes(drinker,beer)
– Frequents(drinker,bar)
– Friends(drinker1, drinker2)

1. Find all beers liked by two or more drinkers. 
2. Find all beers liked by three or more drinkers.
3. Find all beers liked by friends of Anna.
4. Find all bars that sell a beer that is cheaper than all beers sold by the bar 
‘99 Bottles’
*/

1. 
SELECT l.beer
FROM Likes l 
GROUP BY l.beer
HAVING COUNT(DISTINCT l.drinkers >= 2);

2. 
SELECT l.beer
FROM Likes l
GROUP BY l.beer
HAVING COUNT(DISTINCT l.drinkers >= 3);

3.
SELECT l.beer
FROM Likes l, Friends f
WHERE f.drinker1 = l.drinker
    AND f.drinker2 = 'Anna';

4. 
SELECT s.Bars
FROM Sells s
WHERE s.price < ALL (
    SELECT s2.price
    FROM Sells s2
    WHERE s2.bar = '99 BOttles'
);