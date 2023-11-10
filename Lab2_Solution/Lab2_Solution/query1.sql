/* Lab2 Query 1

The Editions table has attribute which specify the date of that edition, the number of articles in that edition and the number of pages in that edition.  But database systems don't understand English; obvious English constraints about values (like article numbers and page numbers) aren't enforced unless databases and applications enforce them.

Write a SQL query which finds the editionDate of editions which have at least one article whose article number is more than the number of articles in that edition, and whose page number is more than the number of pages in that edition.  

The attribute in your result should appear as theEditionDate.  No duplicates should appear in your result.

*/


SELECT DISTINCT e.editionDate AS theEditionDate
FROM Editions e, Articles a
WHERE a.editionDate = e.editionDate
  AND a.articleNum > e.numArticles
  AND a.articlePage > e.numPages;

-- DISTINCT is needed for this first solution, since there could be many articles in an edition
-- which have this property.


-- But DISTINCT is not needed for these other 3 solutions, since each edition is examined only once,
-- and editionDate is the Primary Key of Editions, so duplicates cannot occur.


SELECT e.editionDate AS theEditionDate
FROM Editions e
WHERE EXISTS ( SELECT *
               FROM Articles a
               WHERE a.editionDate = e.editionDate
                 AND a.articleNum > e.numArticles
                 AND a.articlePage > e.numPages );


SELECT e.editionDate AS theEditionDate
FROM Editions e
WHERE e.editionDate IN ( SELECT a.editionDate
                         FROM Articles a
                         WHERE a.articleNum > e.numArticles
                           AND a.articlePage > e.numPages );



SELECT e.editionDate AS theEditionDate
FROM Editions e
WHERE e.editionDate = ANY ( SELECT a.editionDate
                            FROM Articles a
                            WHERE a.articleNum > e.numArticles
                              AND a.articlePage > e.numPages );
