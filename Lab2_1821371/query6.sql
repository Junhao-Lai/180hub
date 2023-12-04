SELECT s1.subscriptionStartDate, s1.subscriptionInterval
    FROM Subscriptions s1, Subscribers b
    WHERE s1.subscriberPhone = b.subscriberPhone
    AND EXISTS(SELECT *
        FROM Subscriptions s2
        WHERE s1.subscriberPhone = s2.subscriberPhone
        AND s1.subscriptionStartDate <= s2.subscriptionStartDate 
        AND s2.subscriptionStartDate <= DATE(s1.subscriptionStartDate + s1.subscriptionInterval));