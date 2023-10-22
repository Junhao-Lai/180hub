-- Junhao Lai 2023/10/7 

-- Sample Script file to create a bunch of tables for a beers database.
-- Every student has their own database.
-- No schema is specified, so all tables will be created in the public schema of that database.

-- Print out current time. NOT required in your Lab assignments
SELECT timeofday();


-- Create Tables

-- 1 
CREATE TABLE SubscriptionKinds (
    subscriptionMode CHAR(1),
    subscriptionInterval INTERVAL,
    rate NUMERIC(6,2),
    stillOffered BOOL,
    PRIMARY KEY (subscriptionMode, subscriptionInterval) 

);

-- 2
CREATE TABLE Editions (
    editionDate DATE,
    numArticles INT,
    numPages INT,
    PRIMARY KEY (editionDate)

);

-- 3
CREATE TABLE Subscribers (
    subscriberPhone INT,
    subscriberName VARCHAR(50),
    subscriberAddress VARCHAR(60),
    PRIMARY KEY (subscriberPhone)

);

-- 4
CREATE TABLE Subscriptions (
    subscriberPhone INT,
    subscriptionStartDate DATE,
    subscriptionMode CHAR(1),
    subscriptionInterval INTERVAL,
    paymentReceived BOOL,
    PRIMARY KEY (subscriberPhone, subscriptionStartDate),
    FOREIGN KEY (subscriberPhone) REFERENCES Subscribers,
    FOREIGN KEY (subscriptionMode, subscriptionInterval) REFERENCES SubscriptionKinds(subscriptionMode, subscriptionInterval)
);

-- 5
CREATE TABLE Holds (
    subscriberPhone INT,
    subscriptionStartDate DATE,
    holdStartDate DATE,
    holdEndDate DATE,
    PRIMARY KEY (subscriberPhone, subscriptionStartDate, holdStartDate),
    FOREIGN KEY (subscriberPhone, subscriptionStartDate) REFERENCES Subscriptions(subscriberPhone, subscriptionStartDate)
);

-- 6
CREATE TABLE Articles (
    editionDate DATE,
    articleNum INT,
    articleAuthor VARCHAR(30),
    articlePage INT,
    PRIMARY KEY (editionDate, articleNum),
    FOREIGN KEY (editionDate) REFERENCES Editions(editionDate)

--  FOREIGN KEY (editionDate,articlePage, articleNum) REFERENCES Editions(editionDate, numPages, numArticles)

);


-- 7 
CREATE TABLE ReadArticles (
    subscriberPhone INT,
    editionDate DATE,
    articleNum INT,
    readInterval INTERVAL,
    PRIMARY KEY (subscriberPhone, editionDate, articleNum),
    FOREIGN KEY (subscriberPhone) REFERENCES Subscribers(subscriberPhone),
    FOREIGN KEY (editionDate, articleNum) REFERENCES Articles(editionDate, articleNum)
 --   FOREIGN KEY (readInterval) REFERENCES SubscriptionKinds(subscriptionInterval)
);


/*
CREATE TABLE Beers (
  beer VARCHAR(30),
  manf VARCHAR(50),
  PRIMARY KEY (beer)
);

CREATE TABLE Bars (
  bar VARCHAR(30),
  addr VARCHAR(50),
  license VARCHAR(50),
  PRIMARY KEY (bar)
);

CREATE TABLE Sells (
  bar VARCHAR(30),
  beer VARCHAR(30), 
  price REAL,
  PRIMARY KEY (bar, beer),
  FOREIGN KEY (bar) REFERENCES Bars,
  FOREIGN KEY (beer) REFERENCES Beers
);

CREATE TABLE Drinkers (
  drinker VARCHAR(30),
  addr VARCHAR(50),
  phone CHAR(16),
  PRIMARY KEY (drinker)
);

CREATE TABLE Likes (
  drinker VARCHAR(30),
  beer VARCHAR(30),
  PRIMARY KEY (drinker, beer),
  FOREIGN KEY (drinker) REFERENCES Drinkers,
  FOREIGN KEY (beer) REFERENCES Beers
);

CREATE TABLE Frequents (
  drinker VARCHAR(30),
  bar VARCHAR(30),
  PRIMARY KEY (drinker, bar),
  FOREIGN KEY (drinker) REFERENCES Drinkers,
  FOREIGN KEY (bar) REFERENCES Bars
);
*/

-- Print out current time. NOT required in your Lab assignments
SELECT timeofday(); 
