/* Lab2 Query 4

subscriptionInterval  is an attribute in SubscriptionKinds.  The end date of a subscription can be computed by adding its subscriptionStartDate to the subscriptionInterval for its subscription kind.  
But when you add a DATE and an INTERVAL, the result is a TIMESTAMP (not a DATE).  If you have a TIMESTAMP value myTimestamp, then one of the ways that you get the date from that TIMESTAMP is by writing DATE(myTimestamp).

Write a SQL query which finds all subscriptions where:
•	the subscription starts on or before December 17, 2022,
•	the subscription ends on or after October 3, 2023,
•	the address of the subscriber who has that subscription isn't NULL, 
•	the subscription kind (which is identified by subscriptionMode and subscriptionInterval) 
        is still being offered (stillOffered), and
•	there has been at least one hold (in Holds) placed on the subscription.

Attributes which should appear in your result as subscriberPhone, subscriptionStartDate, subscriptionEndDate, subscriberName and subscriptionRate, where:
o	subscriberPhone identifies the subscriber for the subscription,
o	subscriptionStartDate is the start date of the subscription,
o	subscriptionEndDate is the end date of the subscription,
o	subscriberName is the name of the subscriber, and
o	subscriptionRate is the rate for that kind of subscription.

No duplicates should appear in your result.
*/


SELECT DISTINCT sn.subscriberPhone, sn.subscriptionStartDate, 
   DATE(sn.subscriptionStartDate + sn.subscriptionInterval) AS subscriptionEndDate, 
   sr.subscriberName, sk.rate AS subscriptionRate
FROM Subscribers sr, Subscriptions sn, Holds h, subscriptionKinds sk
WHERE sn.subscriptionStartDate <= DATE '2022-12-17'
  AND DATE(sn.subscriptionStartDate + sn.subscriptionInterval) >= DATE '2023-10-03'
  AND sn.subscriberPhone = sr.subscriberPhone
  AND sr.subscriberAddress IS NOT NULL
  AND (sn.subscriptionMode, sn.subscriptionInterval) = (sk.subscriptionMode, sk.subscriptionInterval)
  AND sk.stillOffered = TRUE
  AND (sn.subscriberPhone, sn.subscriptionStartDate) = (h.subscriberPhone, h.subscriptionStartDate);

-- DISTINCT is needed because there could be more than one hold on a subscription.

-- DATE keyword is needed in CSE 180, but okay to write DATE '10/3/23', although it's better to 
-- use the standard format that's in our query.

-- There are other okay ways to coerce (sn.subscriptionStartDate + sn.subscriptionInterval) 
-- to a DATE, but this is the way you were given. 

-- Paired onditions can be written out as two condition, e.g., 
--   (sn.subscriptionMode, sn.subscriptionInterval) = (sk.subscriptionMode, sk.subscriptionInterval)
-- could be written as: 
--   sn.subscriptionMode = sk.subscriptionMode AND sn.subscriptionInterval = sk.subscriptionInterval
