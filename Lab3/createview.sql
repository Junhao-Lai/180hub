-- hello view

CREATE VIEW ProlificIn2021View AS
  SELECT a.articleAuthor, COUNT(*) AS articleCount2021, COUNT(DISTINCT a.editionDate) AS differentEditionCount2021
  FROM Articles a 
  WHERE EXTRACT(YEAR FROM a.editionDate) = '2021'
  GROUP BY a.articleAuthor
  HAVING COUNT(*) >= 3 AND COUNT(DISTINCT a.editionDate) >= 2;