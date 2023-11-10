-- Junhao Lai 10/24 Query 1 (2)

SELECT e.editionDate AS theEditionDate
FROM Editions e
WHERE EXISTS (SELECT *
            FROM Articles a
            WHERE e.editionDate = a.editionDate
            And a.articleNum > e.numArticles
            AND a.articlePage > e.numPages );




