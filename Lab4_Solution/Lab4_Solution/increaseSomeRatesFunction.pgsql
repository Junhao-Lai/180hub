
CREATE OR REPLACE FUNCTION 
increaseSomeRatesFunction(maxTotalRateIncrease INTEGER) 
RETURNS INTEGER AS $$
    
    DECLARE
	totalRateIncrease INTEGER;             /* Total rate increase so far */
	theSubscriptionMode CHAR(1);           /* Subscription kind's mode */
	theSubscriptionInterval INTERVAL;      /* Subscription kind's interval */
	thePopularity INTEGER;                 /* Popularity of subscription kind */
	theRate NUMERIC(6,2);                  /* Rate of subscription kind */
	potentialRateIncrease INTEGER;         /* Potential rate increase */
    
    DECLARE popularityCursor CURSOR FOR
	SELECT sn.subscriptionMode, sn.subscriptionInterval, COUNT(*), sk.rate
	FROM Subscriptions sn, SubscriptionKinds sk
        WHERE sn.subscriptionMode = sk.subscriptionMode
          AND sn.subscriptionInterval = sk.subscriptionInterval
        GROUP BY sn.subscriptionMode, sn.subscriptionInterval, sk.rate
        ORDER BY COUNT(*) DESC;

    BEGIN

	/* If maxTotalRateIncrease isn't positive, then return -1. */
 	IF maxTotalRateIncrease <= 0
	    THEN return -1;
        END IF;
        
	totalRateIncrease := 0;
        
	OPEN popularityCursor;
        
	LOOP
            
	    FETCH popularityCursor INTO theSubscriptionMode, theSubscriptionInterval, thePopularity, theRate;

	    /* Exit if we run out of subscription kinds or if owners, or if popularity < 2.
	     * (Could also exit if totalRateIncrease equals maxTotalRateIncrease.)
	     */

	    EXIT WHEN NOT FOUND OR thePopularity < 2;

            /* The following could be done with a CASE statement.
	     * Could also do individual updates for each popularity value possibility. 
             */

            IF thePopularity >= 5
		THEN potentialRateIncrease := 10;
	    ELSIF thePopularity >= 3
		THEN potentialRateIncrease := 5;
	    ELSE /* thePopularity must be 2 */ 
                potentialRateIncrease := 3;
	    END IF;

            /* If we can increase the rates for this subscription kind, do so */
            IF totalRateIncrease + potentialRateIncrease <= maxTotalRateIncrease THEN
	        UPDATE SubscriptionKinds
	        SET rate = rate + potentialRateIncrease
	        WHERE subscriptionMode = theSubscriptionMode
	          AND subscriptionInterval = theSubscriptionInterval;
            
                  totalRateIncrease := totalRateIncrease + potentialRateIncrease;   
	    END IF;
 
	END LOOP;
        
	RETURN totalRateIncrease;
    END
    
$$ LANGUAGE plpgsql;
