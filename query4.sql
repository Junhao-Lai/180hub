SELECT DISTINCT st.subscriberPhone, st.subscriptionStartDate, DATE(st.subscriptionStartDate + sk.subscriptionInterval) AS subscriptionEndDate, s.subscriberName, sk.rate AS subscriptionRate
FROM Subscriptions st, Subscribers s, SubscriptionKinds sk
WHERE st.subscriberPhone = s.subscriberPhone
    AND st.subscriptionStartDate <= DATE '2022-12-17'
    AND DATE(st.subscriptionStartDate + sk.subscriptionInterval) >= DATE '2023-10-03'
    AND s.subscriberAddress IS NOT NULL
    AND sk.stillOffered = 'TRUE'

    AND (s.subscriberPhone, st.subscriptionStartDate) IN (
    SELECT h.subscriberPhone, h.subscriptionStartDate
    FROM Holds h
   -- WHERE s.subscriberPhone = h.subscriberPhone
    );


-- SELECT DISTINCT st.subscriberPhone, st.subscriptionStartDate, DATE(st.subscriptionStartDate + sk.subscriptionInterval) AS subscriptionEndDate, s.subscriberName, sk.rate AS subscriptionRate
-- FROM Subscriptions st, Subscribers s, SubscriptionKinds sk
-- WHERE (s.subscriberPhone) = (st.subscriberPhone)
--     AND st.subscriptionStartDate <= DATE '2022-12-17'
--     AND DATE(st.subscriptionStartDate + sk.subscriptionInterval) >= DATE '2023-10-03'
--     AND s.subscriberAddress IS NOT NULL
--     AND sk.stillOffered = 'TRUE'
    
--     AND EXISTS(SELECT DISTINCT h.subscriberPhone
--                FROM Holds h
--                WHERE st.subscriberPhone = h.subscriberPhone
--                 AND s.subscriberPhone = h.subscriberPhone);
         


--  AND EXISTS
--      AND st.subscriptionStartDate <= DATE '2022-12-17'
--      AND DATE(st.subscriptionStartDate + sk.subscriptionInterval) >= DATE '2023-10-03'
--      AND s.subscriberAddress IS NOT NULL
--      AND sk.stillOffered = 'TRUE'

--      AND (s.subscriberPhone, st.subscriptionStartDate) IN (
--      SELECT h.subscriberPhone, h.subscriptionStartDate
--      FROM Holds h
--      WHERE s.subscriberPhone = h.subscriberPhone
--      );


-- SELECT DISTINCT
--     st.subscriberPhone AS subscriberPhone,
--     st.subscriptionStartDate AS subscriptionStartDate,
--     s.subscriberName AS subscriberName,
--     s.subscriberAddress AS subscriberAddress,
--     sk.rate AS subscriptionRate,
--     DATE(st.subscriptionStartDate + sk.subscriptionInterval) AS subscriptionEndDate
--     FROM Subscriptions st, SubscriptionKinds sk, Subscribers s
--     WHERE st.subscriptionStartDate <= DATE '2022-12-17'
--         AND DATE(st.subscriptionStartDate + sk.subscriptionInterval) >= DATE '2023-10-03'
--         AND s.subscriberPhone IS NOT NULL
--         AND sk.stillOffered = 'TRUE'
--         AND (s.subscriberPhone, st.subscriptionStartDate) IN (
--         SELECT subscriberPhone, subscriptionStartDate
--         FROM Holds
--     )
--     AND s.subscriberPhone = st.subscriberPhone;
