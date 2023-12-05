CREATE OR REPLACE FUNCTION
increaseSomeRatesFunction(maxTotalRateIncrease INTEGER)
RETURNS INTEGER AS $$


    DECLARE
    	maxTotalRateIncrease        INTEGER;


    DECLARE firingCursor CURSOR FOR
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

    DECLARE curs1 CURSOR FOR
        SELECT COUNT(*) AS numSubscriberSK
        FROM Subscriptions C, SubscriptionKinds sk
        WHERE C.subscriptionInterval = sk.subscriptionInterval
        AND C.subscriptionMode = sk.subscriptionMode;


    BEGIN

	-- Input Validation
	IF maxTotalRateIncrease <= 0 THEN
	    RETURN -1;		/* Illegal value of maxFired */
	    END IF;

        maxTotalRateIncrease := 0;

        OPEN firingCursor;

        LOOP
 
            FETCH firingCursor INTO thePlayerID;

            -- Exit if there are no more records for firingCursor,
            -- or when we already have performed maxFired firings.
            EXIT WHEN NOT FOUND OR numFired >= maxFired;

            UPDATE Players
            SET teamID = NULL
            WHERE playerID = thePlayerID;

            numFired := numFired + 1;

        END LOOP;
        CLOSE firingCursor;

	RETURN numFired;

    END

$$ LANGUAGE plpgsql;
