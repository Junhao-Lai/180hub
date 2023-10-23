SELECT a.articleNum, a.articleAuthor, a.articlePage
FROM Articles a
WHERE NOT EXISTS (SELECT *
            FROM ReadArticles ra, Subscribers sb
            WHERE ra.readInterval > INTERVAL '20' MINUTE
            AND sb.subscriberPhone = ra.subscriberPhone
            AND sb.subscriberName LIKE '%er%'
            AND ra.articleNum = a.articleNum

); 



