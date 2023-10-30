SELECT b.subscriberPhone, C.subscriptionStartDate, DATE(C.subscriptionStartDate + sk.subscriptionInterval) AS subscriptionEndDate, b.subscriberName, sk.rate AS subscriptionRate
FROM Subscribers b, SubscriptionKinds sk, Subscriptions C
WHERE C.subscriptionStartDate <= DATE '2022-12-17'
    AND DATE(C.subscriptionStartDate + sk.subscriptionInterval) >= '2023-10-03'
    AND b.subscriberAddress IS NOT NULL
    AND sk.stillOffered = 'TRUE'
    AND EXISTS (SELECT *
                FROM Holds h
                WHERE C.subscriberPhone = h.subscriberPhone
                    AND C.subscriptionStartDate = h.subscriptionStartDate)
    AND b.subscriberPhone = C.subscriberPhone
    AND sk.subscriptionMode = C.subscriptionMode
    AND sk.subscriptionInterval = C.subscriptionInterval;