SELECT DISTINCT sb.subscriberPhone, sb.subscriberName
FROM subscribers sb, SubscriptionKinds sk
WHERE sk.rate > 137.25 
AND EXISTS(SELECT *
           FROM Subscriptions st
           WHERE st.paymentReceived = 'FALSE'
           AND st.subscriberPhone = sb.subscriberPhone
           )

ORDER BY sb.subscriberName, sb.subscriberPhone DESC;