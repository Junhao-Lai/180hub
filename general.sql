-- Lab3 add general constraints 

--1. In SubscriptionKinds, rate must be greater than zero. This constraint should be named positiveRate.
ALTER TABLE SubscriptionKinds
ADD CONSTRAINT positiveRate 
    CHECK ( rate > 0 );
-- 

--2. In Holds, subscriptionStartDate must be less than or equal to holdStartDate, and holdStartDate must be less
-- than or equal to holdEndDate. This constraint should be named okayDatesForHolds.
ALTER TABLE Holds
ADD CONSTRAINT okayDatesForHolds
    CHECK ( subscriptionStartDate <= holdStartDate AND (holdStartDate <= holdEndDate)); 
--

--3.  In Subscribers, if subscriberName is NULL then, subscriberAddress must also be NULL. This constraint
-- should be named ifNameNullThenAddressNull.
ALTER TABLE Subscribers
ADD CONSTRAINT ifNameNullThenAddressNull
    CHECK ( subscriberName IS NOT NULL OR subscriberAddress is NULL );
--
