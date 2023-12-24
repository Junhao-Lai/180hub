-- SELECT COUNT(*) AS populriry 
--     FROM Subscriptions C, SubscriptionKinds sk
--     WHERE C.subscriptionInterval = sk.subscriptionInterval
--     AND C.subscriptionMode = sk.subscriptionMode;

SELECT sk.subscriptionMode, sk.subscriptionInterval, COUNT(*) AS popularity
FROM SubscriptionKinds sk, Subscriptions C
WHERE  C.subscriptionInterval = sk.subscriptionInterval
    AND C.subscriptionMode = sk.subscriptionMode
GROUP BY sk.subscriptionMode, sk.subscriptionInterval
ORDER BY popularity DESC;


/*
        SELECT C.subscriberPhone
        FROM Subscriptions C
            SELECT COUNT(*) AS popularity 
            FROM SubscriptionKinds sk
            WHERE C.subscriptionInterval = sk.subscriptionInterval
            AND C.subscriptionMode = sk.subscriptionMode;
*/

/*
    	    SELECT p.personID
            FROM Persons p, Players play, GamePlayers gp
            WHERE p.personID = play.playerID 
              AND play.playerID = gp.playerID
              AND play.rating = 'L'
              AND play.teamID IS NOT NULL
            GROUP BY p.personID
            HAVING SUM(gp.minutesPlayed) > 60
            ORDER BY p.salary DESC;
*/
