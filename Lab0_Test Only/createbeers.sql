-- Sample Script file to create a bunch of tables for a beers database.
-- Every student has their own database.
-- No schema is specified, so all tables will be created in the public schema of that database.

-- Print out current time. NOT required in your Lab assignments
SELECT timeofday();

-- Create Tables
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

-- Print out current time. NOT required in your Lab assignments
SELECT timeofday(); 
