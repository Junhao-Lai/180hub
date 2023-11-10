/* Lab2 Query 2

A subscription kind is identified by its mode and interval.  For a subscription, paymentReceived indicates whether payment has been received for that subscription.

Write a SQL query which finds the phone and name for subscribers who have a subscription whose rate is more than 137.25 and for which payment has not been received.

The rows in your result should appear in alphabetical order by name.  If two result rows have the same name, then the row with the bigger phone number should appear before the row with the smaller phone number. 
 
No duplicates should appear in your result.
*/


-- In all of these answers, okay to write sr.subscriberName ASC in the ORDER BY clause,
-- but it's also okay to omit ASC, since that's the default.

-- Also, its okay to write sn.paymentReceived = FALSE instead of NOT sn.paymentReceived 


SELECT DISTINCT sr.subscriberPhone, sr.subscriberName
FROM Subscribers sr, Subscriptions sn, SubscriptionKinds sk
WHERE sr.subscriberPhone = sn.subscriberPhone
  AND sn.subscriptionMode = sk.subscriptionMode
  AND sn.subscriptionInterval = sk.subscriptionInterval
  AND sk.rate > 137.25
  AND NOT sn.paymentReceived
ORDER BY sr.subscriberName, sr.subscriberPhone DESC;

-- DISTINCT is needed for this first solution, since for a subscriber, there could be many 
-- subscriptions which have this property.


-- But DISTINCT is not needed for these other 3 solutions, since each subscriber is examined
-- only  once, and subscriberPhone is the Primary Key of Subscribers, so duplicates cannot occur.



SELECT sr.subscriberPhone, sr.subscriberName
FROM Subscribers sr
WHERE EXISTS ( SELECT *
               FROM Subscriptions sn, SubscriptionKinds sk
               WHERE sr.subscriberPhone = sn.subscriberPhone
                 AND sn.subscriptionMode = sk.subscriptionMode
                 AND sn.subscriptionInterval = sk.subscriptionInterval
                 AND sk.rate > 137.25
                 AND NOT sn.paymentReceived )
ORDER BY sr.subscriberName, sr.subscriberPhone DESC;


SELECT sr.subscriberPhone, sr.subscriberName
FROM Subscribers sr
WHERE sr.subscriberPhone IN ( SELECT sn.subscriberPhone
                              FROM Subscriptions sn, SubscriptionKinds sk
                              WHERE sn.subscriptionMode = sk.subscriptionMode
                                AND sn.subscriptionInterval = sk.subscriptionInterval
                                AND sk.rate > 137.25
                                AND NOT sn.paymentReceived )
ORDER BY sr.subscriberName, sr.subscriberPhone DESC;


SELECT sr.subscriberPhone, sr.subscriberName
FROM Subscribers sr
WHERE sr.subscriberPhone = ANY ( SELECT sn.subscriberPhone
                                 FROM Subscriptions sn, SubscriptionKinds sk
                                 WHERE sn.subscriptionMode = sk.subscriptionMode
                                   AND sn.subscriptionInterval = sk.subscriptionInterval
                                   AND sk.rate > 137.25
                                   AND NOT sn.paymentReceived )
ORDER BY sr.subscriberName, sr.subscriberPhone DESC;
