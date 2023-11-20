-- 23:38
-- Foreign Constraints Test 

INSERT INTO Subscriptions( subscriberPhone, subscriptionStartDate, subscriptionMode, subscriptionInterval, paymentReceived )
    VALUES ( 12315, '2020-10-02', 'D', '2 years', TRUE );
-- Check 紧 Foreign 第一条（CC）  ADD CONSTRAINT CC FOREIGN KEY(subscriberPhone)


INSERT INTO Subscriptions( subscriberPhone, subscriptionStartDate, subscriptionMode, subscriptionInterval, paymentReceived )
    VALUES ( 8315512, '2018-01-01', 'D', '10 years', FALSE );
-- Check 紧 Foreign 第二条 （CK）ADD CONSTRAINT CK FOREIGN KEY(subscriptionMode, subscriptionInterval) vs SK



-- D|1 years|70.00|TRUE
-- 8315512|2023-01-01|D|1 years|FALSE


--  
INSERT INTO Holds( subscriberPhone, subscriptionStartDate, holdStartDate, holdEndDate )
    VALUES ( 8315512, '2020-10-02', '2023-01-01', '2023-11-01' );
--  Check 紧 Foreign 第三条 （CH）ADD CONSTRAINT CH FOREIGN KEY(subscriberPhone, subscriptionStartDate) vs C
 

--不能
UPDATE SubscriptionKinds
SET rate = 0
    WHERE subscriptionMode = 'D';
--

--可以
UPDATE SubscriptionKinds
SET rate = 10
    WHERE subscriptionMode = 'D';
--


-- 可以插入
UPDATE Subscribers
SET subscriberName = 'Leo Lin'
    WHERE subscriberPhone = '12345';
--

--  
UPDATE Subscribers
SET subscriberName = 'Caleb Wang'
    WHERE subscriberPhone = '12315';
--

-- 不能插入
UPDATE Subscribers 
SET subscriberName = NULL
    WHERE subscriberPhone = '8315512';

UPDATE Subscribers 
SET subscriberName = NULL
    WHERE subscriberPhone = '4155534';  



