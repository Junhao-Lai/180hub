-- 2022-11-12 midterm 前夕

-- FOREIGN KEY CONSTRAINTS 
ALTER TABLE Subscriptions
    ADD CONSTRAINT CC FOREIGN KEY(subscriberPhone)
        REFERENCES Subscribers(subscriberPhone)
            ON UPDATE CASCADE; 

ALTER TABLE Subscriptions
    ADD CONSTRAINT CK FOREIGN KEY(subscriptionMode, subscriptionInterval)
        REFERENCES SubscriptionKinds(subscriptionMode, subscriptionInterval)
                       ON DELETE SET NULL
                       ON UPDATE CASCADE;

ALTER TABLE Holds 
    ADD CONSTRAINT CH FOREIGN KEY(subscriberPhone, subscriptionStartDate)
        REFERENCES Subscriptions(subscriberPhone, subscriptionStartDate)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION;


