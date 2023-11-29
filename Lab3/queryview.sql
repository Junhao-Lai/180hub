-- 揾authors who appear in ProlificIn2021View and who also had more article in 2022 than 2021
-- 

SELECT p.articleAuthor AS authorName, COUNT(*) AS articleCount2021, COUNT(DISTINCT a.articleNum) AS articleCount2022
FROM ProlificIn2021View p, Articles a
WHERE p.articleAuthor = a.articleAuthor
    AND EXTRACT(YEAR FROM a.editionDate) = '2022'
GROUP BY p.articleAuthor, p.articleCount2021
HAVING p.articleCount2021 < COUNT(*);


DELETE FROM Articles WHERE editionDate = '2021-06-13' AND articleNum = 10;
DELETE FROM Articles WHERE editionDate = '2021-06-13' AND articleNum = 1;


SELECT p.articleAuthor AS authorName, COUNT(*) AS articleCount2021, COUNT(DISTINCT a.articleNum) AS articleCount2022
FROM ProlificIn2021View p, Articles a
WHERE p.articleAuthor = a.articleAuthor
    AND EXTRACT(YEAR FROM a.editionDate) = '2022'
GROUP BY p.articleAuthor, p.articleCount2021
HAVING p.articleCount2021 < COUNT(*);