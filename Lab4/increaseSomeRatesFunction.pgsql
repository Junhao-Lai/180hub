CREATE OR REPLACE FUNCTION
increaseSomeRatesFunction(maxTotalRateIncrease INTEGER)
RETURNS INTEGER AS $$


    DECLARE
        totalIncrease INTEGER;
        currentIncrease INTEGER;
        popularity INTEGER;
        

    DECLARE subscriptionsCursor CURSOR FOR
        SELECT C.subscriberPhone
        FROM Subscriptions C
            SELECT COUNT(*) AS populriry 
            FROM SubscriptionKinds sk
            WHERE C.subscriptionInterval = sk.subscriptionInterval
            AND C.subscriptionMode = sk.subscriptionMode;


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



    BEGIN

	-- Input Validation
	IF maxTotalRateIncrease <= 0 THEN
	    RETURN -1;		/* Illegal value of maxFired */
	    END IF;

        maxTotalRateIncrease := 0;

        OPEN subscriptionsCursor;

        LOOP
 
            FETCH subscriptionsCursor INTO subscriberPhone;

            -- Exit if there are no more records for firingCursor,
            -- or when we already have performed maxFired firings.
            EXIT WHEN NOT FOUND;

            currentIncrease := 0;
            IF popularity >= 5 THEN
                currentIncrease := 10;
            END IF;
            IF popularity = 4 THEN
                currentIncrease := 5;
            END IF;            
            IF popularity = 3 THEN
                currentIncrease := 5;
            END IF;
            IF popularity = 2 THEN
                currentIncrease := 3;
            END IF;


            IF totalIncrease + currentIncrease <= maxTotalIncrease THEN
                UPDATE Things
                SET cost = theCost + currentIncrease
                WHERE thingID = theThingID;

                totalIncrease := totalIncrease + currentIncrease;
        END LOOP;
        CLOSE subscriptionsCursor;

	RETURN numFired;

    END

$$ LANGUAGE plpgsql;
