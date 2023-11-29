
-- combine.sql

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- Okay to say BEGIN TRANSACTION READ WRITE ISOLATION LEVEL SERIALIZABLE;

UPDATE ReadArticles ra
SET readInterval = ra.readInterval + nra.ReadInterval
FROM NewReadArticles nra
WHERE ra.subscriberPhone = nra.subscriberPhone
  AND ra.editionDate = nra.editionDate
  AND ra.articleNum = nra.articleNum;

INSERT INTO ReadArticles
    SELECT *
    FROM NewReadArticles nra
    WHERE NOT EXISTS ( SELECT *
                       FROM ReadArticles ra
                       WHERE ra.subscriberPhone = nra.subscriberPhone
                         AND ra.editionDate = nra.editionDate
                         AND ra.articleNum = nra.articleNum );

COMMIT TRANSACTION;

/* If the INSERT preceded the UPDATE, the solution would be incorrect, because the inserted
   rows would  be modified, doubling the readInterval value.

   The description of combine.sql in the Lab3 pdf specified the effect that your transaction
   should have.  It did not tell you that the order in which the statements should be executed.

   In the outer SELECT for the INSERT, okay to write:
        SELECT subscriberPhone, editionDate, articleNum, readInterval
   instead of writing SELECT *

   In the INNER SELECT, okay to write anything legal instead of SELECT *
*/
