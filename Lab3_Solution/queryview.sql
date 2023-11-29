-- queryview.sql

SELECT p2021v.articleAuthor, p2021v.articleCount2021, COUNT(*) AS articleCount2022
FROM ProlificIn2021View p2021v, Articles a
WHERE p2021v.articleAuthor = a.articleAuthor
  AND EXTRACT(YEAR FROM a.editionDate) = 2022
GROUP BY p2021v.articleAuthor, p2021v.articleCount2021
HAVING p2021v.articleCount2021 < COUNT(*);

/* Need to have p2021v.articleCount2021 in the GROUP BY, since it's in the SELECT.
   Views don't have Primary Keys.

   COUNT(*) can have any attribute that can't be NULL.

   DISTINCT is not needed in this query.
*/