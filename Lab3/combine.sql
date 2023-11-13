-- Junhao Lai 2023-11-12 下昼


SELECT timeofday();
START TRANSACTION ISOLATION LEVEL SERIALIZABLE;

UPDATE ReadArticles ra
    SET subscriberPhone = nra.subscriberPhone, editionDate = nra.editionDate, articleNum = nra.articleNum, readInterval = nra.readInterval
    FROM NewReadArticles nra
    WHERE ra.subscriberPhone = nra.subscriberPhone
        AND ra.editionDate = nra.editionDate
        AND ra.articleNum = nra.articleNum;

INSERT INTO ReadArticles(subscriberPhone, editionDate, articleNum, readInterval)
    SELECT subscriberPhone, editionDate, articleNum, readInterval
    FROM NewReadArticles nra
    WHERE NOT EXISTS ( SELECT ra.subscriberPhone, ra.editionDate, ra.articleNum
                       FROM ReadArticles ra
                       WHERE ra.subscriberPhone = nra.subscriberPhone
                            AND ra.editionDate = nra.editionDate
                            AND ra.articleNum = nra.articleNum
    );
    
    
    COMMIT;
                
   