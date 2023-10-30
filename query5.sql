SELECT DISTINCT b.subscriberName AS theSubscriberName, b.subscriberAddress AS theSubscriberAddress, a.editionDate AS theEditionDate
FROM Subscribers b, Articles a 
WHERE b.subscriberName IN (
    SELECT a2.articleAuthor
    FROM Articles a2
    WHERE a.editionDate = a2.editionDate
    AND a.articleNum <> a2.articleNum
);