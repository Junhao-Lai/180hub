-- unittests.sql

-- Violate first foreign key constraint
INSERT INTO Subscriptions VALUES (8315532, '2023-01-01', 'D', '1 years', false);

-- Violate second foreign key constraint
INSERT INTO Subscriptions VALUES (8315512, '2023-02-01', 'D', '3 years', false);

-- Violate third foreign key constraint
INSERT INTO Holds VALUES (6502124, '2022-12-06', '2023-01-01', '2023-11-01');


-- An UPDATE that meets general constraint 1.
UPDATE SubscriptionKinds
SET rate = 80
WHERE subscriptionMode = 'D'
  AND subscriptionInterval = INTERVAL '1 years';

-- An UPDATE that violates general constraint 1.
UPDATE SubscriptionKinds
SET rate = -1
WHERE subscriptionMode = 'B'
  AND subscriptionInterval = INTERVAL '8 years';


-- An UPDATE command that meets general constraint 2. 
UPDATE Holds
SET holdStartDate = DATE '2023-02-01'
WHERE subscriberPhone = 6502123
  AND subscriptionStartDate = DATE '2022-12-06'
  AND holdStartDate = DATE '2023-01-01';

-- An UPDATE command that violates general constraint 2. 
UPDATE Holds
SET holdStartDate = DATE '2023-10-01'
WHERE subscriberPhone = 8313293
  AND subscriptionStartDate = DATE '2022-10-01'
  AND holdStartDate = DATE '2022-10-01';



-- An UPDATE command that meets general constraint 3. 
UPDATE Subscribers
SET subscriberName = NULL, subscriberAddress = NULL
WHERE subscriberPhone = 6505523;

-- An UPDATE command that violates general constraint 3. 
UPDATE Subscribers
SET subscriberName = NULL, subscriberAddress = '343, Miramar Avenue, San Lorenzo, 95060'
WHERE subscriberPhone = 6505523;