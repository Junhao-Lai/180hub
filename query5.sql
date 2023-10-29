SELECT DISTINCT S.subscriberName AS theSubscriberName, S.subscriberAddress AS theSubscriberAddress, A.editionDate AS theEditionDate
FROM Subscribers S, Articles A
WHERE S.subscriberName IN (
    SELECT articleAuthor
    FROM Articles
    GROUP BY articleAuthor, editionDate
    HAVING COUNT(*) > 1
);
