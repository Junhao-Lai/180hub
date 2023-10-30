SELECT DISTINCT a.articleNum, a.articleAuthor, a.articlePage
FROM Articles a
WHERE NOT EXISTS (SELECT *
            FROM ReadArticles ra, Subscribers sb
            WHERE ra.readInterval > INTERVAL '20m' 
            AND sb.subscriberPhone = ra.subscriberPhone
            AND sb.subscriberName LIKE '%er%'
            AND a.editionDate = ra.editionDate
            AND ra.articleNum = a.articleNum

); 



