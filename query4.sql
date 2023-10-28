SELECT st.subscriberPhone, st.subscriptionStartDate, DATE(st.subscriptionStartDate + sk.subscriptionInterval) AS subscriptionEndDate, s.subscriberName, sk.rate AS subscriptionRate
FROM Subscriptions st, Subscribers s, SubscriptionKinds sk
WHERE st.subscriberPhone = s.subscriberPhone
    AND st.subscriptionStartDate >= DATE '2022-12-17'
    AND DATE(st.subscriptionStartDate + sk.subscriptionInterval) >= DATE '2023-10-03'
    AND s.subscriberAddress IS NOT NULL
    AND sk.stillOffered = 'TRUE'

    AND s.subscriberPhone IN (
    SELECT h.subscriberPhone
    FROM Holds h
   -- WHERE s.subscriberPhone = h.subscriberPhone
    );