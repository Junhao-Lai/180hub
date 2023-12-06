CREATE OR REPLACE FUNCTION
increaseSomeRatesFunction(maxTotalRateIncrease INTEGER)
RETURNS INTEGER AS $$


    DECLARE
        totalIncrease INTEGER;
        currentIncrease INTEGER;
        popularity INTEGER;
        

    DECLARE subscriptionsCursor CURSOR FOR
            SELECT sk.subscriptionMode, sk.subscriptionInterval, COUNT(*) AS popularity
            FROM SubscriptionKinds sk, Subscriptions C
            WHERE  C.subscriptionInterval = sk.subscriptionInterval
                AND C.subscriptionMode = sk.subscriptionMode
                GROUP BY sk.subscriptionMode, sk.subscriptionInterval
                ORDER BY popularity DESC;


    BEGIN

	-- Input Validation
	IF maxTotalRateIncrease <= 0 THEN
	    RETURN -1;		/* Illegal value of maxTotalRateIncrease */
	    END IF;

        maxTotalRateIncrease := 0;

        OPEN subscriptionsCursor;

        LOOP
 
            FETCH subscriptionsCursor INTO totalIncrease;

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
                UPDATE SubscriptionKinds sk
                SET rate = rate + currentIncrease
                WHERE rate = totalIncrease;

                totalIncrease := totalIncrease + currentIncrease;
            END IF;
        END LOOP;
        CLOSE subscriptionsCursor;

	RETURN totalIncrease;

    END

$$ LANGUAGE plpgsql;
