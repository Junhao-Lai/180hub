-- createview.sql

CREATE VIEW ProlificIn2021View AS
    SELECT a.articleAuthor, COUNT(*) AS articleCount2021, 
                COUNT(DISTINCT a.editionDate) AS differentEditionCount2021
    FROM Articles a
    WHERE EXTRACT(YEAR FROM a.editionDate) = 2021
    GROUP BY a.articleAuthor
    HAVING COUNT(*) >= 3 AND COUNT(DISTINCT editionDate) >= 2;


/* Can't use articleCount2021 and differentEditionCount2021 in the HAVING clause, since
   they don't get defined until the SELECT clause is executed.

   For articleCount2021, okay to say COUNT(a) where a is any attribute that can't be NULL.
   But for differentEditionCount2021, need to say COUNT(DISTINCT a.editionDate).

   DISTINCT in not needed in the view definition.
 */