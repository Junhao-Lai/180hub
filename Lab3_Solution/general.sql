-- general.sql

-- These specific names are required for constraints

ALTER TABLE SubscriptionKinds
ADD CONSTRAINT positiveRate
    CHECK (rate > 0);

ALTER TABLE Holds
ADD CONSTRAINT okayDatesForHolds
    CHECK (subscriptionStartDate <= holdStartDate AND holdStartDate <= holdEndDate);

ALTER TABLE Subscribers
ADD CONSTRAINT ifNameNullThenAddressNull
    CHECK(subscriberName IS NOT NULL OR subscriberAddress IS NULL)

/* Okay to say:
      CHECK ( (subscriberName IS NULL AND subscriberAddress IS NULL) 
           OR (subscriberName IS NOT NULL) );
 */
