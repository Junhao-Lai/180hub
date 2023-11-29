-- foreign.sql

-- All constraints should  have names but they don't have to be the names shown below.

ALTER TABLE Subscriptions
ADD CONSTRAINT fk_susbscriber
FOREIGN KEY (subscriberPhone) REFERENCES Subscribers
    ON DELETE RESTRICT
    ON UPDATE CASCADE;
-- Okay to leave out ON DELETE RESTRICT, because that's the default.
-- Okay to say ON DELETE NO ACTION instead of ON DELETE RESTRICT


ALTER TABLE Subscriptions
ADD CONSTRAINT fk_subscriptionkind
FOREIGN KEY (subscriptionMode, subscriptionInterval) REFERENCES SubscriptionKinds
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE Holds
ADD CONSTRAINT fk_subscription
FOREIGN KEY (subscriberPhone, subscriptionStartDate) REFERENCES Subscriptions
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;
-- Okay to leave out ON DELETE RESTRICT or ON UPDATE RESTRICT, because that's the default.
-- Okay to say NO ACTION instead of RESTRICT