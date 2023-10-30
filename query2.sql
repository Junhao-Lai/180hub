SELECT DISTINCT b.subscriberPhone, b.subscriberName
FROM Subscribers b, SubscriptionKinds sk, Subscriptions C
WHERE sk.rate > 137.25
    AND C.paymentReceived = 'FALSE'
    AND C.subscriberPhone = b.subscriberPhone
    AND C.subscriptionMode = sk.subscriptionMode
    AND C.subscriptionInterval = sk.subscriptionInterval

ORDER BY b.subscriberName, b.subscriberPhone DESC;

