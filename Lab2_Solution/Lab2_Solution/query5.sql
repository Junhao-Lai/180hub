/* Lab2 Query t

For each article in the Articles table, articleAuthor gives the name of the author, and editionDate specifies the edition in which the article appears.  There could be a subscriber who has the same name as an article author.

Write a SQL query that finds the subscriber name, and subscriber address and edition whenever that subscriber's name appears as the author of more than one article which is in that edition.
The attributes in your result should appear as theSubscriberName, theSubscriberAddress and theEditionDate.  No duplicates should appear in your result.

*/

-- DISTINCT is needed in all of these solutions because there could be multiple subscribers
-- who have the same name and address who have this property.

-- There is a  way to rewrite the solutions which use "EXISTS" so that they use "IN" or "= ANY"
-- instead of "EXISTS", but you can't just replace the word "EXISTS" in those solutions.

-- Lab2 was assigned before the Lecture on Aggregates, and some of these solutions do not
-- use aggregates


SELECT DISTINCT sr.subscriberName AS theSubscriberName,
          sr.subscriberAddress AS theSubscriberAddress, a1.editionDate AS theEditionDate
FROM Subscribers sr, Articles a1, Articles a2
WHERE sr.subscriberName = a1.articleAuthor
  AND sr.subscriberName = a2.articleAuthor
  AND a1.editionDate = a2.editionDate
  AND a1.articleNum <> a2.articleNum;


SELECT DISTINCT sr.subscriberName AS theSubscriberName,
          sr.subscriberAddress AS theSubscriberAddress, a1.editionDate AS theEditionDate
FROM Subscribers sr, Articles a1
WHERE sr.subscriberName = a1.articleAuthor
    AND EXISTS ( SELECT *
                 FROM articles a2
                 WHERE a2.articleAuthor = sr.subscriberName
                   AND a2.editionDate = a1.editionDate
                   AND a2.articleNum <> a1.articleNum );


SELECT DISTINCT sr.subscriberName AS theSubscriberName, 
             sr.subscriberAddress AS theSubscriberAddress, e.editionDate AS theEditionDate
FROM Subscribers sr, Editions e
WHERE ( SELECT COUNT(*)
        FROM Articles a
        WHERE a.editionDate = e.editionDate
          AND a.articleAuthor = sr.subscriberName ) >= 2;
