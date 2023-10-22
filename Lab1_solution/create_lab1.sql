-- CSE 180 Fall 2023 Lab1 Solution

-- The following two lines are not needed in your solution, but they're useful.
DROP SCHEMA lab1 CASCADE;
CREATE SCHEMA lab1;


-- Specific spacing doesn't matter.

-- INT is equivalent to INTEGER.
-- DECIMAL is equivalent to NUMERIC.
-- CHAR is equivalent to CHARACTER.
-- BOOL is equivalent to BOOLEAN.

-- Primary Keys that have a single attribute can have PRIMARY KEY appearing next to that attribute,
-- instead of as a Schema Element.  Must use a Schema Element when Primary Key is multiple attributes.

-- Foreign Keys that have a single attribute can have REFERENCES next to that attribute, instead of
-- specifying the Foreign Key as a Schema Element.  Must use a Schema Element when Foreign Key is multiple
-- attributes.

-- When all attributes of Foreign Key are identical to all attributes of the referenced Primary Key, don't need
-- to specify attributes of the Primary Key (but you can).  For example, in Vehicles could write either:
--       FOREIGN KEY (subscriptionMode, subscriptionInterval) REFERENCES SubscriptionKinds         or
--       FOREIGN KEY (subscriptionMode, subscriptionInterval) 
--                       REFERENCES SubscriptionKinds(subscriptionMode, subscriptionInterval)  


CREATE TABLE SubscriptionKinds(
    subscriptionMode CHAR(1),
    subscriptionInterval INTERVAL,
    rate NUMERIC(6,2),
    stillOffered BOOLEAN,
    PRIMARY KEY (subscriptionMode, subscriptionInterval)
    );


CREATE TABLE Editions(
    editionDate DATE PRIMARY KEY,
    numArticles INT,
    numPages INT
    );


CREATE TABLE Subscribers(
    subscriberPhone INT PRIMARY KEY,
    subscriberName VARCHAR(30),
    subscriberAddress VARCHAR(60)
    );


CREATE TABLE Subscriptions(
    subscriberPhone INT REFERENCES Subscribers,
    subscriptionStartDate DATE,
    subscriptionMode CHAR(1),
    subscriptionInterval INTERVAL,
    paymentReceived BOOLEAN,
    PRIMARY KEY (subscriberPhone, subscriptionStartDate),
    FOREIGN KEY (subscriptionMode, subscriptionInterval) REFERENCES SubscriptionKinds
    );


CREATE TABLE Holds(
    subscriberPhone INT,
    subscriptionStartDate DATE,
    holdStartDate DATE,
    holdEndDate DATE,
    PRIMARY KEY (subscriberPhone, subscriptionStartDate, holdStartDate),
    FOREIGN KEY (subscriberPhone, subscriptionStartDate) REFERENCES Subscriptions
    );


CREATE TABLE Articles(
    editionDate DATE REFERENCES Editions,
    articleNum INT,
    articleAuthor VARCHAR(30),
    articlePage INT,
    PRIMARY KEY (editionDate, articleNum)
    );


CREATE TABLE ReadArticles(
    subscriberPhone INT REFERENCES Subscribers,
    editionDate DATE,
    articleNum INT,
    readInterval INTERVAL,
    PRIMARY KEY (subscriberPhone, editionDate, articleNum),
    FOREIGN KEY (editionDate, articleNum) REFERENCES Articles
    );
